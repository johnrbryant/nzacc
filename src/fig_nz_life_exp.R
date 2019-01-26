
library(methods)
library(demest)
library(latticeExtra)
library(dplyr)
library(demlife)

population <- fetch("out/model.est",
                    where = c("account", "population"))
exposure <- exposure(population)

death_rate <- fetch("out/model.est",
                    where = c("system", "deaths", "likelihood", "rate"),
                    impute = TRUE) %>%
    collapseDimension(dimension = "triangle",
                      weights = 1)

life_exp <- death_rate %>%
    LifeTable() %>%
    lifeExpectancy()

p <- dplot(~ time | sex,
           data = life_exp,
           col = "grey",
           xlab = "Year",
           scales = list(tck = 0.4,
                         y = list(relation = "free")),
           midpoints = "time",
           ylab = "Life expectancy",
           prob = c(0.025, 0.5, 0.975),
           par.settings = list(fontsize = list(text = 7),
                               strip.background = list(col = "grey90")),
           between = list(y = 0.2))


graphics.off()
pdf(file = "out/fig_nz_life_exp.pdf",
    width = 5,
    height = 2.5)
plot(p)
dev.off()
