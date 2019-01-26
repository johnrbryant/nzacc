
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


age_groups <- c("0-4", "20-24")


p <- dplot(~ time | age,
           data = net_migration,
           subarray = age %in% age_groups,
           as.table = TRUE,
           col = "grey",
           scales = list(tck = 0.4),
           xlab = "Year",
           ylim = c(-11000, 16000),
           midpoints = "time",
           prob = c(0.025, 0.5, 0.975),
           ylab = "",
           par.settings = list(fontsize = list(text = 7),
                               strip.background = list(col = "grey90")),
           between = list(x = 0.2, y = 0.2)) +
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
             under = FALSE) +
    layer(panel.abline(h = 0, col = "black", lwd = 0.5),
          under = TRUE)
    


graphics.off()
pdf(file = "out/fig_nz_net_migration.pdf",
    width = 5,
    height = 2.5)
plot(p)
dev.off()
