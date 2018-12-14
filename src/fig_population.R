
library(methods)
library(demest)
library(latticeExtra)
library(dplyr)

population <- fetch("out/model.est",
                    where = c("account", "population"))

p <- dplot(~ age | factor(time) * sex,
           data = population,
           midpoints = "age",
           col = "salmon",
           xlab = "Age",
           ylab = "",
           prob = c(0.025, 0.975),
           as.table = TRUE) %>%
    useOuterStrips()
p_mid <- dplot(~ age | factor(time) * sex,
           data = population,
           midpoints = "age",
           col = "salmon",
           prob = 0.5)
p <- p + p_mid

graphics.off()
pdf(file = "out/fig_population.pdf",
    width = 0,
    height = 0,
    paper = "a4r")
plot(p)
dev.off()

