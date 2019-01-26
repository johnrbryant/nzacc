
library(methods)
library(dembase)
library(dplyr)
library(docopt)

'
Usage:
account.R [options]

Options:
--sex_ratio [default: 106]
--seed [default: 0]
' -> doc
opts <- docopt(doc)
sex_ratio <- opts$sex_ratio %>% as.numeric()
seed <- opts$seed %>% as.numeric()


pr_female_male <- c(100 / (100 + sex_ratio), sex_ratio / (100 + sex_ratio))

set.seed(seed)

population <- readRDS("data/census.rds") %>%
    subarray(time == "1996", drop = FALSE) %>%
    extrapolate(along = "time", labels = 1997:2018)

births <- readRDS("data/reg_births.rds") %>%
    addDimension(name = "sex", labels = c("Female", "Male"), scale = pr_female_male) %>%
    toInteger(force = TRUE) %>%
    expandIntervals(dimension = "age", breaks = 13:50)

deaths <- readRDS("data/reg_deaths.rds") %>%
    extrapolate(along = "time", labels = 1997:1999)
    
in_migration <- readRDS("data/arrivals_plt.rds") %>%
    expandIntervals(dimension = "age", breaks = 0:100)

out_migration <- readRDS("data/departures_plt.rds") %>%
    expandIntervals(dimension = "age", breaks = 0:100)


account <- Movements(population = population,
                     births = births,
                     entries = list(in_migration = in_migration),
                     exits = list(deaths = deaths,
                                  out_migration = out_migration)) %>%
    makeConsistent()


saveRDS(account,
        file = "out/account.rds")
