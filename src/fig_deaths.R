
library(methods)
library(demest)
library(latticeExtra)
library(dplyr)

deaths <- fetch("out/model.est",
                where = c("account", "deaths"))

exposure <- fetch("out/model.est",
                  where = c("account", "population")) %>%
    exposure(triangles = TRUE)

p <- dplot(~ age | factor(time) * sex,
           data = deaths,
           weights = exposure,
           midpoints = "age",
           col = "salmon",
           xlab = "Age",
           ylab = "",
           scales = list(y = list(log = TRUE)),
           prob = c(0.025, 0.975),
           as.table = TRUE) %>%
    useOuterStrips()

graphics.off()
pdf(file = "out/fig_deaths.pdf",
    width = 0,
    height = 0,
    paper = "a4r")
plot(p)
dev.off()


