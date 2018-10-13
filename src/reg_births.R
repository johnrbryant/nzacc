
library(methods)
library(tidyr)
library(dplyr)
library(dembase)
library(readr)

## Process data

sex_ratio_at_birth <- 105
pr_female_male <- c(100, sex_ratio_at_birth) / (100 + sex_ratio_at_birth)

reg_births <- read_csv(file = "data-raw/VSB355801_20181004_081753_17.csv",
                       skip = 1,
                       n_max = 5,
                       col_types = "-iiiiiiii") %>%
    gather(key = "age", value = "count") %>%
    mutate(time = "2002-2006") %>%
    mutate(age = recode(age, "Under 15 years" = "10-14", "45 years and over" = "45-49"),
           age = cleanAgeGroup(age)) %>%
    xtabs(count ~ age + time, data = .) %>%
    Counts() %>%
    addDimension(name = "sex",
                 labels = c("Female", "Male"),
                 scale = pr_female_male) %>%
    toInteger(force = TRUE)

    
## Check against original data. Totals are rounded independently,
## so have to check against exactly the same cells
check_total <- read_csv(file = "data-raw/VSB355801_20181004_081753_17.csv",
                        skip = 2,
                        n_max = 5,
                        col_types = "-iiiiiiii",
                        col_names = FALSE) %>%
    sum()
stopifnot(all.equal(sum(reg_births), check_total, tol = 0.001))


## Save

saveRDS(reg_births,
        file = "data/reg_births.rds")
