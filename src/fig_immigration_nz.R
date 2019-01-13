
library(methods)
library(demest)
library(latticeExtra)
library(dplyr)

in_migration <- fetch("out/model.est",
                     where = c("account", "in_migration"))

arrivals_plt <- fetch("out/model.est",
                      where = c("datasets", "arrivals_plt"))

departures_plt <- fetch("out/model.est",
                      where = c("datasets", "departures_plt"))

dplot(~ time, fetchCoverage("out/model.est", "departures_plt"), weights = departures_plt)



arrivals_1216 <- fetch("out/model.est",
                       where = c("datasets", "arrivals_1216"))

p <- dplot(~ time | age,
           data = in_migration,
           subarray = year == 2010,
           as.table = TRUE,
           col = "grey",
           scales = list(tck = 0.4,
                         y = list(relation = "free")),
           ylim = c(0, NA),
           layout = c(2, 2),
           prob = c(0.025, 0.5, 0.975),
           xlab = "Year",
           ylab = "",
           par.settings = list(fontsize = list(text = 7),
                               strip.background = list(col = "grey90")),
           between = list(y = 0.2)) +
    as.layer(dplot(~ time | age,
                   data = census,
                   type = "p",
                   pch = 3,
                   cex = 0.8,
                   subarray = age %in% age_groups,
                   col = "black"))

graphics.off()
pdf(file = "out/fig_population_nz.pdf",
    width = 5,
    height = 3.5)
plot(p)
dev.off()
