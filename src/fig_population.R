
library(methods)
library(demest)
library(latticeExtra)
library(dplyr)

population <- fetch("out/model.est",
                    where = c("account", "population"))


graphics.off()
pdf(file = "out/fig_population.pdf",
    width = 0,
    height = 0,
    paper = "a4r")
for (SEX in c("Female", "Male")) {
    p <- dplot(~ time | age,
               data = population,
               subarray = sex == SEX,
               main = sprintf("Population by age and time: %s", SEX),
               xlab = "",
               ylab = "",
               scales = list(tck = 0.4),
               col = "salmon",
               as.table = TRUE,
               par.settings = list(fontsize = list(text = 9),
                                   strip.background = list(col = "grey90")))
    plot(p)
}
dev.off()

