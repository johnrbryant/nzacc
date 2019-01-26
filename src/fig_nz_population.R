
library(methods)
library(demest)
library(latticeExtra)
library(dplyr)

population <- fetch("out/model.est",
                    where = c("account", "population"))

census <- fetch("out/model.est",
                where = c("datasets", "census"))

## idi_erp <- fetch("out/model.est",
##                  where = c("datasets", "idi_erp"))

age_groups <- c("0", "25", "100+")

p <- dplot(~ time | age,
           data = population,
           subarray = age %in% age_groups & sex == "Female",
           as.table = TRUE,
           col = "grey",
           scales = list(tck = 0.4,
                         y = list(relation = "free")),
           ylim = c(0, NA),
           layout = c(3, 1),
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
                   cex = 0.6,
                   subarray = age %in% age_groups & sex == "Female",
                   col = "black"))
    ## as.layer(dplot(~ time | age,
    ##                data = idi_erp,
    ##                type = "l",
    ##                subarray = age %in% age_groups,
    ##                col = "black"))

graphics.off()
pdf(file = "out/fig_nz_population.pdf",
    width = 5.5,
    height = 2.2)
plot(p)
dev.off()
