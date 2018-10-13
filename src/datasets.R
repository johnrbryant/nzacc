
library(methods)
library(dplyr)
library(dembase)



census <- readRDS("data/census.rds")

reg_births <- readRDS("data/reg_births.rds")

reg_deaths <- readRDS("data/reg_deaths.rds") %>%
    collapseIntervals(dimension = "age", breaks = seq(0, 85, 5))

arrivals <- readRDS("data/arrivals.rds")

departures <- readRDS("data/departures.rds")

datasets <- list(census = census,
                 reg_births = reg_births,
                 reg_deaths = reg_deaths,
                 arrivals = arrivals,
                 departures = departures)

saveRDS(datasets,
        file = "out/datasets.rds")


