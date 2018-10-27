
library(methods)
library(tidyr)
library(dplyr)
library(dembase)
library(readr)
library(docopt)

'
Usage:
reg_deaths.R [options]

Options:
--add_lexis [default: FALSE]
' -> doc
opts <- docopt(doc)
add_lexis <- opts$add_lexis %>% as.logical()


## Process data

reg_deaths <- read_csv(file = "data-raw/VSD349201_20181014_082255_47.csv",
                       skip = 1,
                       n_max = 44) %>%
    rename(sex = X1, age = X2) %>%
    mutate(sex = fillForward(sex)) %>%
    mutate(age = cleanAgeGroup(age)) %>%
    gather(key = time, value = count, -age, -sex) %>%
    xtabs(count ~ age + sex + time, data = .) %>%
    Counts(dimscale = c(time = "Intervals")) %>%
    collapseIntervals(dimension = "time", width = 5) %>%
    collapseIntervals(dimension = "age", width = 5)

if (add_lexis) {
    reg_deaths <- reg_deaths %>%
        addDimension(name = "triangle", labels = c("Lower", "Upper"), scale = 0.5) %>%
        toInteger(force = TRUE)
}


## Check against original data. Totals are rounded independently,
## so have to check against exactly the same cells
check_total <- read_csv(file = "data-raw/VSD349201_20181014_082255_47.csv",
                        skip = 1,
                        n_max = 44) %>%
    select(-X1, -X2) %>%
    unlist() %>%
    sum()

stopifnot(all.equal(sum(reg_deaths), check_total, tol = 0.001))


## Save

file <- if (add_lexis) "data/reg_deaths_lex.rds" else "data/reg_deaths.rds"
saveRDS(reg_deaths, file = file)
