
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

# mult by 2 because splitting into smaller groups
sd <- (2 * (percent_error / 100) * census_counts / 1.96) %>% 
    Values()

census <- Model(census ~ NormalFixed(mean = mean, sd = sd, useExpose = TRUE),
                series = "population")


## Other

reg_births <- Model(reg_births ~ Round3(),
                    series = "births")

reg_deaths <- Model(reg_deaths ~ Round3(),
                    series = "deaths")

arrivals_plt <- Model(arrivals_plt ~ Poisson(mean ~ age + time),
                      age ~ DLM(trend = NULL,
                                 damp = NULL,
                                 error = Error(scale = HalfT(scale = 0.05))),
                      time ~ DLM(trend = NULL,
                                 damp = NULL,
                                 error = Error(scale = HalfT(scale = 0.05))),
                      series = "in_migration",
                      jump = 0.03)

departures_plt <- Model(departures_plt ~ Poisson(mean ~ age + time),
                        age ~ DLM(trend = NULL,
                                  damp = NULL,
                                  error = Error(scale = HalfT(scale = 0.05))),
                        time ~ DLM(trend = NULL,
                                   damp = NULL,
                                   error = Error(scale = HalfT(scale = 0.05))),
                        series = "out_migration",
                        jump = 0.03)

arrivals_1216 <- Model(arrivals_1216 ~ PoissonBinomial(prob = 0.96),
                       series = "in_migration")

departures_1216 <- Model(departures_1216 ~ PoissonBinomial(prob = 0.96),
                         series = "out_migration")


## Save

data_models <- list(census = census,
                    reg_births = reg_births,
                    reg_deaths = reg_deaths,
                    arrivals_plt = arrivals_plt,
                    departures_plt = departures_plt,
                    arrivals_1216 = arrivals_1216,
                    departures_1216 = departures_1216)

saveRDS(data_models,
        file = "out/data_models.rds")
