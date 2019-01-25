

library(methods)
library(demest)
library(latticeExtra)
library(dplyr)

coverage <- fetchCoverage("out/model.est",
                          dataset = "census")

p <- dplot(~ age | factor(time) * sex,
           data = coverage,
           col = "grey",
           xlab = "Year",
           as.table = TRUE,
           scales = list(tck = 0.4),
           ylab = "",
           midpoints = "age",
           par.settings = list(fontsize = list(text = 7),
                               strip.background = list(col = "grey90")),
           between = list(y = 0.2)) %>%
    useOuterStrips() +
    layer(panel.abline(h = 1, lty = "dotted"))

graphics.off()
pdf(file = "out/fig_cover_census.pdf",
    width = 5,
    height = 3.5)
plot(p)
dev.off()
