
library(methods)
library(tidyr)
library(dplyr)
library(dembase)
library(readr)

## Process data

idi_erp <- read_csv("data-raw/exp-pop-estimates-2007-16-csv.csv") %>%
    mutate(age = ifelse(age == 90, "90+", age)) %>%
    rename(time = year) %>%
    xtabs(idierp ~ age + sex + time, data = .) %>%
    Counts(dimscales = c(time = "Points"))

check_total <- read_csv("data-raw/exp-pop-estimates-2007-16-csv.csv") %>%
    pull(idierp) %>%
    sum()

stopifnot(all.equal(sum(idi_erp), check_total))


## Save

saveRDS(idi_erp,
        file = "data/idi_erp.rds")
