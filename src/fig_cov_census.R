

library(methods)
library(demest)
library(latticeExtra)
library(dplyr)
library(demlife)


cov_cen <- fetchCoverage("out/model.est", dataset = "census")

p <- dplot(~ age | factor(time) * sex,
           data = cov_cen,
           col = "salmon",
           xlab = "Year",
           ylab = "Coverage",
           midpoints = "age",
           as.table = TRUE) %>%
    useOuterStrips()


graphics.off()
pdf(file = "out/fig_cov_census.pdf",
    width = 7,
    height = 4.5)
plot(p)
dev.off()
