
library(methods)
library(demest)
library(latticeExtra)
library(dplyr)

cov_arr <- fetchCoverage("out/model.est", dataset = "arrivals_plt")

quartz()
dplot(~ age | factor(time) * sex,
      data = cov_arr,
      midpoints = "age")

cov_dep <- fetchCoverage("out/model.est", dataset = "departures_plt")

dplot(~ age | factor(time) * sex,
      data = cov_dep,
      midpoints = "age")

cov_dep1216 <- fetchCoverage("out/model.est", dataset = "departures_1216")

dplot(~ age | factor(time) * sex,
      data = cov_dep1216,
      midpoints = "age")


cov_arr1216 <- fetchCoverage("out/model.est", dataset = "arrivals_1216")

dplot(~ age | factor(time) * sex,
      data = cov_arr1216,
      midpoints = "age")








