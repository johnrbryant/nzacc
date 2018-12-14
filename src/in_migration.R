
library(methods)
library(demest)
library(latticeExtra)
library(dplyr)

in_migration <- fetch("out/model.est",
                      where = c("account", "in_migration"))


p <- dplot(~ age | factor(time) * sex,
           data = in_migration,
           midpoints = "age",
           col = "salmon",
           xlab = "Age",
           ylab = "",
           prob = c(0.025, 0.975),
           as.table = TRUE) %>%
    useOuterStrips()
p_mid <- dplot(~ age | factor(time) * sex,
           data = in_migration,
           midpoints = "age",
           col = "salmon",
           prob = 0.5)
p <- p + p_mid

graphics.off()
pdf(file = "out/fig_in_migration.pdf",
    width = 7,
    height = 4.5)
plot(p)
dev.off()




