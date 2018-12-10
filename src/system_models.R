
library(methods)
library(demest)

population <- Model(population ~ Poisson(mean ~ age * sex + age * time, useExpose = FALSE),
                    jump = 0.02)

births <- Model(births ~ Poisson(mean ~ age * time + sex),
                age ~ DLM(trend = NULL,
                          damp = NULL),
                sex ~ ExchFixed(sd = 0.05),
                time ~ DLM(trend = NULL,
                           damp = NULL),
                age:time ~ DLM(trend = NULL,
                               damp = NULL),
                jump = 0.02)

deaths <- Model(deaths ~ Poisson(mean ~ age * time + age * sex),
                age ~ DLM(damp = NULL),
                time ~ DLM(damp = NULL),
                age:time ~ DLM(trend = NULL,
                               damp = NULL),
                jump = 0.1)

in_migration <- Model(in_migration ~ Poisson(mean ~ age * time + sex),
                      age ~ DLM(trend = NULL,
                                damp = NULL),
                      time ~ DLM(trend = NULL,
                                 damp = NULL),
                      jump = 0.1)

out_migration <- Model(out_migration ~ Poisson(mean ~ age * time + sex),
                       age ~ DLM(trend = NULL,
                                 damp = NULL),
                       time ~ DLM(trend = NULL,
                                  damp = NULL),
                       jump = 0.1)


system_models <- list(population,
                      births,
                      deaths,
                      in_migration,
                      out_migration)


saveRDS(system_models,
        file = "out/system_models.rds")


                      

