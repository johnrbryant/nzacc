

library(methods)
library(demest)
library(latticeExtra)
library(dplyr)

cov_cen <- fetchCoverage("out/model.est",
                         dataset = "census")

p <- dplot(~ age | factor(time) * sex,
           data = cov_cen,
           col = "salmon",
           xlab = "Year",
           ylab = "Coverage",
           midpoints = "age",
           as.table = TRUE) %>%
    useOuterStrips()

graphics.off()
pdf(file = "out/fig_cover_census.pdf",
    width = 0,
    height = 0,
    paper = "a4r")
plot(p)
dev.off()
