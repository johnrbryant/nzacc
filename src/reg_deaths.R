
library(methods)
library(tidyr)
library(dplyr)
library(dembase)
library(readr)

## Process data

reg_deaths <- read_csv(file = "data-raw/VSD349201_20181004_082014_77.csv",
                       skip = 2,
                       n_max = 5)
Male <- reg_deaths %>%
    select(Infant:`100 years and over`) %>%
    gather(key = age, value = count) %>%
    mutate(sex = "Male")
Female <- reg_deaths %>%
    select(Infant_1:`100 years and over_1`) %>%
    gather(key = age, value = count) %>%
    mutate(sex = "Female") %>%
    mutate(age = sub("_1", "", age))
reg_deaths <- bind_rows(Female, Male) %>%
    mutate(age = cleanAgeGroup(age)) %>%
    mutate(time = "2002-2006") %>%
    xtabs(count ~ age + sex + time, data = .) %>%
    Counts()

## Check against original data. Totals are rounded independently,
## so have to check against exactly the same cells
check_total <- read_csv(file = "data-raw/VSD349201_20181004_082014_77.csv",
                        skip = 2,
                        n_max = 5) %>%
    select(-X1) %>%
    unlist() %>%
    sum()

stopifnot(all.equal(sum(reg_deaths), check_total))


## Save

saveRDS(reg_deaths,
        file = "data/reg_deaths.rds")
