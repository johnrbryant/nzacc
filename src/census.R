
library(methods)
library(tidyr)
library(dplyr)
library(dembase)
library(readr)

## Process data

census <- read_csv("data-raw/Age_by_sex/TABLECODE8001_Data_e35fb0f7-8ed5-4d62-86c4-269454dd04f4.csv") %>%
    select(age = "Age group", sex = Sex, time = Year, count = Value) %>%
    mutate(age = cleanAgeGroup(age)) %>%
    xtabs(count ~ age + sex + time, data = .) %>%
    Counts(dimscales = c(time = "Points"))

check_total <- read_csv("data-raw/Age_by_sex/TABLECODE8001_Data_e35fb0f7-8ed5-4d62-86c4-269454dd04f4.csv") %>%
    pull(Value) %>%
    sum()

stopifnot(all.equal(sum(census), check_total))


## Save

saveRDS(census,
        file = "data/census.rds")
