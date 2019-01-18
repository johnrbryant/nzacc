
library(methods)
library(demest)
library(latticeExtra)
library(dplyr)

population <- fetch("out/model.est",
                    where = c("account", "population"))

census <- fetch("out/model.est",
                where = c("datasets", "census"))


sex_ratio <- 100 * subarray(population, sex == "Male") / subarray(population, sex == "Female")
sex_ratio_census <- 100 * subarray(census, sex == "Male") / subarray(census, sex == "Female")


census_years <- dimnames(census)$time

p <- dplot(~ age | factor(time),
           data = sex_ratio,
           subarray = time %in% census_years & age < 60,
           as.table = TRUE,
           col = "grey",
           scales = list(tck = 0.4),
           midpoints = "age",
           xlab = "Year",
           ylab = "",
           par.settings = list(fontsize = list(text = 7),
                               strip.background = list(col = "grey90")),
           between = list(y = 0.2)) +
    as.layer(dplot(~ age | factor(time),
                   data = sex_ratio_census,
                   subarray = age < 60,
                   type = "l",
                   midpoints = "age",
                   col = "black")) +
    layer(panel.abline(h = 100, lty = "dotted"))


    as.layer(dplot(~ time | age,
                   data = census,
                   type = "p",
                   pch = 3,
                   cex = 0.6,
                   subarray = age %in% age_groups,
                   col = "black"))

graphics.off()
pdf(file = "out/fig_nz_population.pdf",
    width = 5,
    height = 3.5)
plot(p)
dev.off()
