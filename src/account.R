
library(methods)
library(dembase)
library(dplyr)


set.seed(0)

population <- readRDS("data/census.rds")

births <- readRDS("data/reg_births.rds")

deaths <- readRDS("data/reg_deaths.rds") %>%
    collapseIntervals(dimension = "age", breaks = seq(0, 85, 5))
    
in_migration <- readRDS("data/arrivals.rds") %>%
    expandIntervals(dimension = "age", breaks = seq(0, 85, 5))

out_migration <- readRDS("data/departures.rds") %>%
    expandIntervals(dimension = "age", breaks = seq(0, 85, 5))


account <- Movements(population = population,
                     births = births,
                     entries = list(in_migration = in_migration),
                     exits = list(deaths = deaths,
                                  out_migration = out_migration)) %>%
    makeConsistent()


saveRDS(account,
        file = "out/account.rds")
