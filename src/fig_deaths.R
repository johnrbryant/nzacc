
library(methods)
library(demest)
library(latticeExtra)
library(dplyr)

deaths <- fetch("out/model.est",
                where = c("account", "deaths"))

exposure <- fetch("out/model.est",
                  where = c("account", "population")) %>%
    exposure(triangles = TRUE)


age_groups <- dimnames(deaths)$age[c(TRUE, FALSE, FALSE, FALSE, FALSE)]

col <- c("dark orange", "dark blue")
prob <- c(0.025, 0.975)
p <- dplot(~ time | age,
           data = deaths,
           weights = population,
           subarray = sex == "Female" & age %in% age_groups,
           midpoints = "time",
           col = col[1L],
           main = "Population by age and sex",
           xlab = "",
           ylab = "",
           scales = list(tck = 0.4),
           prob = prob, 
           as.table = TRUE,
           layout = c(7, 3),
           par.settings = list(fontsize = list(text = 9),
                               strip.background = list(col = "grey90")),
           key = list(text = dimnames(population)["sex"],
                      rectangles = list(col = col, border = FALSE),
                      columns = 2,
                      space = "bottom",
                      padding.text = 3)) +
    as.layer(dplot(~ time | age,
                   data = deaths,
                   weights = exposure,
                   subarray = sex == "Male" & age %in% age_groups,
                   col = col[2],
                   prob = prob))
graphics.off()
pdf(file = "out/fig_deaths.pdf",
    width = 0,
    height = 0,
    paper = "a4r")
plot(p)
dev.off()


