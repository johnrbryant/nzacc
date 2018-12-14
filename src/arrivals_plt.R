
library(methods)
library(tidyr)
library(dplyr)
library(dembase)
library(readr)


arrivals_plt <- read_csv(file = "data-raw/ITM340201_20181209_055538_93.csv",
                         skip = 1,
                         n_max = 64) %>%
    select(-X1) %>%
    gather(key = time, value = count, `1997`:`2018`) %>%
    rename(direction = X2, sex = X3, age = X4) %>%
    mutate(direction = fillForward(direction),
           sex = fillForward(sex),
           age = fillForward(age),
           age = cleanAgeGroup(age)) %>%
    filter(direction == "Arrivals") %>%
    xtabs(count ~ age + sex + time, data = .) %>%
    Counts(dimscales = c(time = "Intervals"))


check_total <- read_csv(file = "data-raw/ITM340201_20181209_055538_93.csv",
                          skip = 1) %>%
    slice(1:32) %>%
    select(`1997`:`2018`) %>%
    unlist() %>%
    sum()

stopifnot(all.equal(sum(arrivals_plt), check_total))


saveRDS(arrivals_plt,
        file = "data/arrivals_plt.rds")
