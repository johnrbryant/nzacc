
library(methods)
library(dplyr)
library(dembase)
library(docopt)

'
Usage:
datasets.R [options]

Options:
--add_lexis [default: FALSE]
' -> doc
opts <- docopt(doc)
add_lexis <- opts$add_lexis %>% as.logical()



census <- readRDS("data/census.rds")

if (add_lexis) {

    reg_births <- readRDS("data/reg_births.rds")

    reg_deaths <- readRDS("data/reg_deaths.rds") %>%
        collapseIntervals(dimension = "age", breaks = seq(0, 85, 5))

    arrivals_plt <- readRDS("data/arrivals_plt.rds")

    departures_plt <- readRDS("data/departures_plt.rds")

    arrivals_1216 <- readRDS("data/arrivals_1216.rds")

    departures_1216 <- readRDS("data/departures_1216.rds")

} else {

    reg_births <- readRDS("data/reg_births_lex.rds")

    reg_deaths <- readRDS("data/reg_deaths_lex.rds") %>%
        collapseIntervals(dimension = "age", breaks = seq(0, 85, 5))

    arrivals_plt <- readRDS("data/arrivals_plt_lex.rds")

    departures_plt <- readRDS("data/departures_plt_lex.rds")

    arrivals_1216 <- readRDS("data/arrivals_1216_lex.rds")

    departures_1216 <- readRDS("data/departures_1216_lex.rds")

}

datasets <- list(census = census,
                 reg_births = reg_births,
                 reg_deaths = reg_deaths,
                 arrivals_plt = arrivals_plt,
                 departures_plt = departures_plt,
                 arrivals_1216 = arrivals_1216,
                 departures_1216 = departures_1216)

file <- if (add_lexis) "out/datasets_lex.rds" else "out/datasets.rds"
saveRDS(datasets, file = file)


