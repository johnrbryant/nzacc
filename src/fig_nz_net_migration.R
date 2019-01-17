
library(methods)
library(demest)
library(latticeExtra)
library(dplyr)

in_migration <- fetch("out/model.est",
                      where = c("account", "in_migration")) %>%
    collapseDimension(dimension = "triangle") %>%
    collapseIntervals(dimension = "age", breaks = seq(0, 70, 5))

out_migration <- fetch("out/model.est",
                      where = c("account", "out_migration")) %>%
    collapseDimension(dimension = "triangle") %>%
    collapseIntervals(dimension = "age", breaks = seq(0, 70, 5))

net_migration <- in_migration - out_migration


arrivals_plt <- fetch("out/model.est",
                      where = c("datasets", "arrivals_plt")) %>%
    collapseIntervals(dimension = "age", breaks = seq(0, 70, 5))

departures_plt <- fetch("out/model.est",
                        where = c("datasets", "departures_plt")) %>%
    collapseIntervals(dimension = "age", breaks = seq(0, 70, 5))

net_plt <- arrivals_plt - departures_plt


arrivals_1216 <- fetch("out/model.est",
                       where = c("datasets", "arrivals_1216")) %>%
    collapseIntervals(dimension = "age", breaks = seq(0, 70, 5))

departures_1216 <- fetch("out/model.est",
                         where = c("datasets", "departures_1216")) %>%
    collapseIntervals(dimension = "age", breaks = seq(0, 70, 5))

net_1216 <- arrivals_1216 - departures_1216


age_groups <- c("0-4", "25-29", "50-54", "70+")

p <- dplot(~ time | age,
           data = net_migration,
           subarray = age %in% age_groups,
           as.table = TRUE,
           col = "grey",
           scales = list(tck = 0.4,
                         y = list(relation = "free")),
           layout = c(2, 2),
           xlab = "Year",
           midpoints = "time",
           ylab = "",
           par.settings = list(fontsize = list(text = 7),
                               strip.background = list(col = "grey90")),
           between = list(y = 0.2)) +
    as.layer(dplot(~ time | age,
                   data = net_plt,
                   type = "l",
                   lty = "dotted",
                   midpoints = "time",
                   cex = 0.5,
                   subarray = age %in% age_groups,
                   col = "black"),
             under = FALSE) +
    as.layer(dplot(~ time | age,
                   data = net_1216,
                   type = "l",
                   lty = "dashed",
                   midpoints = "time",
                   cex = 0.5,
                   subarray = age %in% age_groups,
                   col = "black"),
             under = FALSE)

graphics.off()
pdf(file = "out/fig_nz_net_migration.pdf",
    width = 5,
    height = 3.5)
plot(p)
dev.off()
