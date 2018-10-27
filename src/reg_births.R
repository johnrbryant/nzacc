
library(methods)
library(tidyr)
library(dplyr)
library(dembase)
library(readr)
library(docopt)

'
Usage:
reg_births.R [options]

Options:
--add_lexis [default: FALSE]
' -> doc
opts <- docopt(doc)
add_lexis <- opts$add_lexis %>% as.logical()


## Process data

reg_births <- read_csv(file = "data-raw/VSB355801_20181014_082447_13.csv",
                       skip = 1,
                       n_max = 20) %>%
    rename(time = X1) %>%
    gather(key = "age", value = "count", `Under 15 years`:`45 years and over`) %>%
    mutate(age = recode(age, "Under 15 years" = "10-14", "45 years and over" = "45-49"),
           age = cleanAgeGroup(age)) %>%
    xtabs(count ~ age + time, data = .) %>%
    Counts(dimscale = c(time = "Intervals")) %>%
    collapseIntervals(dimension = "time", width = 5)

if (add_lexis) {
    reg_births <- reg_births %>%
        addDimension(name = "triangle", labels = c("Lower", "Upper"), scale = 0.5) %>%
        toInteger(force = TRUE)
}


## Check against original data. Totals are rounded independently,
## so have to check against exactly the same cells
check_total <- read_csv(file = "data-raw/VSB355801_20181014_082447_13.csv",
                        skip = 2,
                        n_max = 20,
                        col_types = "-iiiiiiii",
                        col_names = FALSE) %>%
    sum()
stopifnot(all.equal(sum(reg_births), check_total, tol = 0.001))


## Save

file <- if (add_lexis) "data/reg_births_lex.rds" else "data/reg_births.rds"
saveRDS(reg_births, file = file)
