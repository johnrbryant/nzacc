
library(methods)
library(tidyr)
library(dplyr)
library(dembase)
library(readr)

## Process data

departures <- read_csv(file = "data-raw/ITM525401_20181004_082501_59.csv",
                       skip = 2,
                       n_max = 6) %>%
    select(`0-4 years_1`:X69) %>%
    slice(-1)
names(departures)[seq(2, 34, 2)] <- names(departures)[seq(1, 33, 2)]
names(departures) <- paste(names(departures), c("Female", "Male"), sep = "__")
departures <- departures %>%
    gather(key = age_sex, value = count) %>%
    mutate(age_sex = sub("_1", "", age_sex)) %>%
    separate(col = "age_sex", into = c("age", "sex"), sep = "__") %>%
    mutate(age = cleanAgeGroup(age)) %>%
    mutate(time = "2002-2006") %>%
    mutate(count = as.integer(count)) %>%
    xtabs(count ~ age + sex + time, data = .) %>%
    Counts()

## Check against original data. Totals are rounded independently,
## so have to check against exactly the same cells
check_total <- read_csv(file = "data-raw/ITM525401_20181004_082501_59.csv",
                        skip = 4,
                        n_max = 5,
                        col_names = FALSE) %>%
    select(X36:X69) %>%
    unlist() %>%
    sum()

stopifnot(all.equal(sum(departures), check_total))


## Save

saveRDS(departures,
        file = "data/departures.rds")
