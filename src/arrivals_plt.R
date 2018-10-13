
library(methods)
library(tidyr)
library(dplyr)
library(dembase)
library(readr)


## Process data

arrivals_plt <- read_csv(file = "data-raw/ITM340201_20181014_083122_44.csv",
                         skip = 1,
                         col_types = "-cciii",
                         n_max = 640) %>%
    rename(age = X2, sex = X3, time = X4) %>%
    mutate(age = fillForward(age),
           age = cleanAgeGroup(age)) %>%
    mutate(sex = fillForward(sex)) %>%
    xtabs(Arrivals ~ age + sex + time, data = .) %>%
    Counts(dimscales = c(time = "Intervals")) %>%
    collapseIntervals(dimension = "time", width = 5)

## Check against original data.
## so have to check against exactly the same cells
check_total <- read_csv(file = "data-raw/ITM340201_20181014_083122_44.csv",
                        skip = 2,
                        col_types = "----i-",
                        n_max = 640,
                        col_names = FALSE) %>%
    unlist() %>%
    sum()

stopifnot(all.equal(sum(arrivals_plt), check_total))


## Save

saveRDS(arrivals_plt,
        file = "data/arrivals_plt.rds")
