
library(methods)
library(tidyr)
library(dplyr)
library(dembase)
library(readr)

## Process data

arrivals_1216 <- read_csv(file = "data-raw/ITM525401_20181014_082741_1.csv",
                          skip = 1,
                          n_max = 510) %>%
    rename(age = X1, sex = X2, time = X3) %>%
    mutate(age = fillForward(age),
           age = cleanAgeGroup(age)) %>%
    mutate(sex = fillForward(sex)) %>%
    xtabs(Arrivals ~ age + sex + time, data = .) %>%
    Counts(dimscales = c(time = "Intervals")) %>%
    collapseIntervals(dimension = "time", width = 5)

## Check against original data. Totals are rounded independently,
## so have to check against exactly the same cells
check_total <- read_csv(file = "data-raw/ITM525401_20181014_082741_1.csv",
                        skip = 1,
                        n_max = 510) %>%
    select(Arrivals) %>%
    unlist() %>%
    sum()

stopifnot(all.equal(sum(arrivals_1216), check_total))


## Save

saveRDS(arrivals_1216,
        file = "data/arrivals_1216.rds")
