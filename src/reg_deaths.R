
library(methods)
library(tidyr)
library(dplyr)
library(dembase)
library(readr)

reg_deaths <- read_csv(file = "data-raw/VSD349201_20181209_054420_13.csv",
                       skip = 1,
                       n_max = 202) %>%
    rename(sex = X1, age = X2) %>%
    mutate(sex = fillForward(sex)) %>%
    mutate(age = cleanAgeGroup(age)) %>%
    gather(key = time, value = count, -age, -sex) %>%
    xtabs(count ~ age + sex + time, data = .) %>%
    Counts(dimscale = c(time = "Intervals"))

check_total <- read_csv(file = "data-raw/VSD349201_20181209_054420_13.csv",
                          skip = 1,
                          n_max = 202) %>%
    select(`2000`:`2018`) %>%
    unlist() %>%
    sum()

stopifnot(all.equal(sum(reg_deaths), check_total))


saveRDS(reg_deaths,
        file = "data/reg_deaths.rds")
