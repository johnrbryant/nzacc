
library(methods)
library(demest)
library(dplyr)


## Census + PES

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

# mult by 3 because splitting into smaller groups
sd <- (3 * (percent_error / 100) * census_counts / 1.96) %>% 
    Values()

census <- Model(census ~ NormalFixed(mean = mean, sd = sd, useExpose = TRUE),
                series = "population")



## IDI-ERP

idi_erp <- readRDS("data/idi_erp.rds")

mean <- idi_erp / idi_erp


sd <- 0.02 * idi_erp %>% 
    Values(dimscale = c(time = "Points"))

idi_erp <- Model(idi_erp~ NormalFixed(mean = mean, sd = sd, useExpose = TRUE),
                 series = "population")



## Registered births

reg_births <- Model(reg_births ~ Round3(),
                    series = "births")


## Registered deaths

reg_deaths <- Model(reg_deaths ~ Round3(),
                    series = "deaths")

arrivals_plt <- Model(arrivals_plt ~ Poisson(mean ~ age + sex),
                      age ~ DLM(level = Level(scale = HalfT(scale = 0.05)),
                                trend = NULL,
                                damp = NULL,
                                error = Error(scale = HalfT(scale = 0.05))),
                      series = "in_migration",
                      priorSD = HalfT(scale = 0.1),
                      jump = 0.045)

departures_plt <- Model(departures_plt ~ Poisson(mean ~ age + sex),
                        age ~ DLM(level = Level(scale = HalfT(scale = 0.05)),
                                  trend = NULL,
                                  damp = NULL,
                                  error = Error(scale = HalfT(scale = 0.05))),
                        series = "out_migration",
                        priorSD = HalfT(scale = 0.1),
                        jump = 0.045)


## Arrivals and departures - 12/16 rule

arrivals_1216 <- Model(arrivals_1216 ~ PoissonBinomial(prob = 0.95),
                       series = "in_migration")

departures_1216 <- Model(departures_1216 ~ PoissonBinomial(prob = 0.95),
                         series = "out_migration")





## Save

data_models <- list(census = census,
                    idi_erp = idi_erp,
                    reg_births = reg_births,
                    reg_deaths = reg_deaths,
                    arrivals_plt = arrivals_plt,
                    departures_plt = departures_plt,
                    arrivals_1216 = arrivals_1216,
                    departures_1216 = departures_1216)

saveRDS(data_models,
        file = "out/data_models.rds")
