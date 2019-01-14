
library(methods)
library(demest)

population <- Model(population ~ Poisson(mean ~ age * sex + age * time,
                                         useExpose = FALSE),
                    age ~ DLM(level = Level(scale = HalfT(scale = 0.1)),
                              damp = NULL,
                              error = Error(scale = HalfT(scale = 0.1))),
                    sex ~ ExchFixed(sd = 0.05),
                    time ~ DLM(level = Level(scale = HalfT(scale = 0.05)),
                               trend = NULL,
                               damp = NULL,
                               error = Error(scale = HalfT(scale = 0.05))),
                    age:time ~ DLM(level = Level(scale = HalfT(scale = 0.05)),
                                   trend = NULL,
                                   damp = NULL,
                                   error = Error(scale = HalfT(scale = 0.05))),
                    priorSD = HalfT(scale = 0.1),
                    jump = 0.019)

births <- Model(births ~ Poisson(mean ~ age * time + sex),
                age ~ DLM(level = Level(scale = HalfT(scale = 0.05)),
                          trend = NULL,
                          damp = NULL,
                          error = Error(scale = HalfT(scale = 0.05))),
                sex ~ ExchFixed(sd = 0.05),
                time ~ DLM(level = Level(scale = HalfT(scale = 0.025)),
                           trend = NULL,
                           damp = NULL,
                           error = Error(scale = HalfT(scale = 0.025))),
                age:time ~ DLM(level = Level(scale = HalfT(scale = 0.0125)),
                               trend = NULL,
                               damp = NULL,
                               error = Error(scale = HalfT(scale = 0.0125))),
                priorSD = HalfT(scale = 0.1),
                lower = 0.00001,
                upper = 1,
                jump = 0.02)

deaths <- Model(deaths ~ Poisson(mean ~ age * time + age * sex),
                age ~ DLM(level = Level(scale = HalfT(scale = 0.025)),
                          trend = Trend(scale = HalfT(scale = 0.025)),
                          damp = NULL,
                          error = Error(scale = HalfT(scale = 0.025))),
                time ~ DLM(level = Level(scale = HalfT(scale = 0.025)),
                           trend = Trend(scale = HalfT(scale = 0.025)),
                           damp = NULL,
                           error = Error(scale = HalfT(scale = 0.025))),
                age:time ~ DLM(level = Level(scale = HalfT(scale = 0.0125)),
                               trend = NULL,
                               damp = NULL,
                               error = Error(scale = HalfT(scale = 0.0125))),
                priorSD = HalfT(scale = 0.1),
                lower = 0.00001,
                upper = 1,
                jump = 0.1)

in_migration <- Model(in_migration ~ Poisson(mean ~ age + time + sex),
                      age ~ DLM(level = Level(scale = HalfT(scale = 0.05)),
                                trend = NULL,
                                damp = NULL,
                                error = Error(scale = HalfT(scale = 0.05))),
                      time ~ DLM(level = Level(scale = HalfT(scale = 0.05)),
                                 trend = NULL,
                                 damp = NULL,
                                 error = Error(scale = HalfT(scale = 0.05))),
                      priorSD = HalfT(scale = 0.1),
                      lower = 0.00001,
                      upper = 1,
                      jump = 0.15)

out_migration <- Model(out_migration ~ Poisson(mean ~ age + time + sex),
                       age ~ DLM(level = Level(scale = HalfT(scale = 0.05)),
                                 trend = NULL,
                                 damp = NULL,
                                 error = Error(scale = HalfT(scale = 0.05))),
                       time ~ DLM(level = Level(scale = HalfT(scale = 0.05)),
                                  trend = NULL,
                                  damp = NULL,
                                  error = Error(scale = HalfT(scale = 0.05))),
                       priorSD = HalfT(scale = 0.1),
                       lower = 0.00001,
                       upper = 1,
                       jump = 0.15)


system_models <- list(population,
                      births,
                      deaths,
                      in_migration,
                      out_migration)


saveRDS(system_models,
        file = "out/system_models.rds")


                      

