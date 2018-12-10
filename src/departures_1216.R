
library(methods)
library(tidyr)
library(dplyr)
library(dembase)
library(readr)


## Process data

departures_1216 <- read_csv(file = "data-raw/ITM525401_20181209_055319_42.csv",
                          skip = 1,
                          n_max = 68) %>%
    rename(direction = X1, age = X2, sex = X3) %>%
    gather(key = "time", value = "count", `2002`:`2017`) %>%
    mutate(direction = fillForward(direction),
           age = fillForward(age),
           age = cleanAgeGroup(age),
           sex = fillForward(sex)) %>%
    filter(direction == "Departures") %>%
    xtabs(count ~ age + sex + time, data = .) %>%
    Counts(dimscales = c(time = "Intervals"))

check_total <- read_csv(file = "data-raw/ITM525401_20181209_055319_42.csv",
                          skip = 1,
                        n_max = 68) %>%
    slice(35:68) %>%
    select(`2002`:`2017`) %>%
    unlist() %>%
    sum()


stopifnot(all.equal(sum(departures_1216), check_total))


## Save

saveRDS(departures_1216,
        file = "data/departures_1216.rds")
