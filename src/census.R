
library(methods)
library(tidyr)
library(dplyr)
library(dembase)
library(readxl)

## Process data

census <- read_xls(path = "data-raw/QuickStatsPopulationandDwellings.xls",
                   sheet = "Table 3",
                   skip = 7,
                   n_max = 18) %>%
    select(age = X__1,
           "Male 2001" = Male__1,
           "Female 2001" = Female__1,
           "Male 2006" = Male__2,
           "Female 2006" = Female__2) %>%
    gather(key = "sex_time", value = "count", -age) %>%
    separate(col = sex_time, into = c("sex", "time")) %>%
    mutate(age = cleanAgeGroup(age)) %>%
    xtabs(count ~ age + sex + time, data = .) %>%
    Counts(dimscales = c(time = "Points")) %>%
    toInteger()

## Check against original data. Totals are rounded independently,
## so have to check against exactly the same cells
check_total_01 <- read_xls(path = "data-raw/QuickStatsPopulationandDwellings.xls",
                           sheet = "Table 3",
                           range = "E9:F26",
                           col_names = FALSE) %>%
    sum()
stopifnot(all.equal(sum(subarray(census, time == "2001")), check_total_01))

check_total_06 <- read_xls(path = "data-raw/QuickStatsPopulationandDwellings.xls",
                           sheet = "Table 3",
                           range = "H9:I26",
                           col_names = FALSE) %>%
    sum()
stopifnot(all.equal(sum(subarray(census, time == "2006")), check_total_06))


## Save

saveRDS(census,
        file = "data/census.rds")
