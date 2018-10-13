
library(methods)
library(demest)
library(dplyr)


## Census

census_counts <- readRDS("data/census.rds")

net_undercount <- readRDS("data/net_undercount.rds")

percent_undercount <- net_undercount %>%
    filter(variable == "percent") %>%
    xtabs(value ~ time + age, data = .) %>%
    Values()

mean <- (1 - percent_undercount / 100) %>%
    makeCompatible(y = census_counts)

percent_error <- net_undercount %>%
    filter(variable == "error") %>%
    xtabs(value ~ time + age, data = .) %>%
    Values()

sd <- ((percent_error / 100) * census_counts / 1.96) %>%
    Values()

census <- Model(census ~ NormalFixed(mean = mean, sd = sd, useExpose = TRUE),
                series = "population")


## Other

reg_births <- Model(reg_births ~ PoissonBinomial(prob = 0.98),
                    series = "births")

reg_deaths <- Model(reg_deaths ~ PoissonBinomial(prob = 0.98),
                    series = "deaths")

arrivals <- Model(arrivals ~ PoissonBinomial(prob = 0.98),
                  series = "in_migration")

departures <- Model(departures ~ PoissonBinomial(prob = 0.98),
                    series = "out_migration")


## Save

data_models <- list(census = census,
                    reg_births = reg_births,
                    reg_deaths = reg_deaths,
                    arrivals = arrivals,
                    departures = departures)

saveRDS(data_models,
        file = "out/data_models.rds")
