
library(methods)
library(demest)
library(latticeExtra)

population <- fetch("out/model.est", where = c("account", "population"))

dplot(~ age | factor(time) * sex,
      data = population,
      midpoints = "age")


in_migration <- fetch("out/model.est", where = c("account", "in_migration"))

dplot(~ age | factor(time) * triangle,
      data = in_migration,
      midpoints = "age")


out_migration <- fetch("out/model.est", where = c("account", "out_migration"))

dplot(~ age | factor(time) * sex,
      data = out_migration,
      midpoints = "age")


births <- fetch("out/model.est", where = c("account", "births"))

dplot(~ age | factor(time),
      data = births,
      midpoints = "age")



out_migration <- fetch("out/model.est", where = c("account", "out_migration"))

dplot(~ age | factor(time) * sex,
      data = out_migration,
      midpoints = "age")

