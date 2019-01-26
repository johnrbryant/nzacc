
library(methods)
library(dplyr)
library(dembase)


census <- readRDS("data/census.rds")

idi_erp <- readRDS("data/idi_erp.rds")

reg_births <- readRDS("data/reg_births.rds")

reg_deaths <- readRDS("data/reg_deaths.rds")

arrivals_plt <- readRDS("data/arrivals_plt.rds")

departures_plt <- readRDS("data/departures_plt.rds")

arrivals_1216 <- readRDS("data/arrivals_1216.rds")

departures_1216 <- readRDS("data/departures_1216.rds")

datasets <- list(census = census,
                 idi_erp = idi_erp,
                 reg_births = reg_births,
                 reg_deaths = reg_deaths,
                 arrivals_plt = arrivals_plt,
                 departures_plt = departures_plt,
                 arrivals_1216 = arrivals_1216,
                 departures_1216 = departures_1216)

saveRDS(datasets, file = "out/datasets.rds")


