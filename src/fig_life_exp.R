

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
           col = "salmon",
           xlab = "Period",
           ylab = "Years")


graphics.off()
pdf(file = "out/fig_life_exp.pdf",
    width = 0,
    height = 0,
    paper = "a4r")
plot(p)
dev.off()
