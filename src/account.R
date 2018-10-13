
library(methods)
library(dembase)
library(dplyr)
library(docopt)

'
Usage:
account.R [options]

Options:
--sex_ratio [default: 106]
' -> doc
opts <- docopt(doc)
sex_ratio <- opts$sex_ratio %>% as.numeric()

pr_female_male <- c(100 / (100 + sex_ratio), sex_ratio / (100 + sex_ratio))

set.seed(0)

population <- readRDS("data/census.rds") %>%
    extrapolate(along = "time", labels = c("2011", "2016"))

births <- readRDS("data/reg_births.rds") %>%
    addDimension(name = "sex", labels = c("Female", "Male"), scale = pr_female_male) %>%
    toInteger(force = TRUE)

deaths <- readRDS("data/reg_deaths.rds") %>%
    collapseIntervals(dimension = "age", breaks = seq(0, 85, 5)) %>%
    extrapolate(along = "time", labels = "1997-2001")
    
in_migration <- readRDS("data/arrivals_plt.rds") %>%
    expandIntervals(dimension = "age", breaks = seq(0, 85, 5))

out_migration <- readRDS("data/departures_plt.rds") %>%
    expandIntervals(dimension = "age", breaks = seq(0, 85, 5))


account <- Movements(population = population,
                     births = births,
                     entries = list(in_migration = in_migration),
                     exits = list(deaths = deaths,
                                  out_migration = out_migration)) %>%
    makeConsistent()


saveRDS(account,
        file = "out/account.rds")
