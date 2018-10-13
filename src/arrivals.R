
library(methods)
library(tidyr)
library(dplyr)
library(dembase)
library(readr)

## Process data

arrivals <- read_csv(file = "data-raw/ITM525401_20181004_082501_59.csv",
                     skip = 2,
                     n_max = 6) %>%
    select(`0-4 years`:X35) %>%
    slice(-1)
names(arrivals)[seq(2, 34, 2)] <- names(arrivals)[seq(1, 33, 2)]
names(arrivals) <- paste(names(arrivals), c("Female", "Male"), sep = "__")
arrivals <- arrivals %>%
    gather(key = age_sex, value = count) %>%
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
    select(X2:X35) %>%
    unlist() %>%
    sum()

stopifnot(all.equal(sum(arrivals), check_total))


## Save

saveRDS(arrivals,
        file = "data/arrivals.rds")
