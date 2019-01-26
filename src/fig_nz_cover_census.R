

library(methods)
library(demest)
library(latticeExtra)
library(dplyr)

coverage <- fetchCoverage("out/model.est",
                          dataset = "census")

p <- dplot(~ age | factor(time),
           data = coverage,
           subarray = sex == "Male",
           col = "grey",
           xlab = "Year",
           as.table = TRUE,
           scales = list(tck = 0.4),
           ylab = "",
           midpoints = "age",
           prob = c(0.025, 0.5, 0.975),
           par.settings = list(fontsize = list(text = 7),
                               strip.background = list(col = "grey90")),
           between = list(x = 0.2, y = 0.2)) +
    layer(panel.abline(h = 1, col = "black", lwd = 0.5),
          under = TRUE)

graphics.off()
pdf(file = "out/fig_nz_cover_census.pdf",
    width = 5,
    height = 3)
plot(p)
dev.off()







