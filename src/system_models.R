
library(methods)
library(demest)

population <- Model(population ~ Poisson(mean ~ age * sex + time, useExpose = FALSE),
                    jump = 0.01)

births <- Model(births ~ Poisson(mean ~ age + sex),
                age ~ DLM(trend = NULL,
                          damp = NULL),
                sex ~ ExchFixed(sd = 0.05),
                priorSD = HalfT(scale = 0.05),
                jump = 0.01)

deaths <- Model(deaths ~ Poisson(mean ~ age + sex),
                age ~ DLM(damp = NULL),
                jump = 0.04)

in_migration <- Model(in_migration ~ Poisson(mean ~ age),
                      age ~ DLM(trend = NULL,
                                damp = NULL),
                      jump = 0.04)

out_migration <- Model(out_migration ~ Poisson(mean ~ age),
                       age ~ DLM(trend = NULL,
                                 damp = NULL),
                       jump = 0.04)


system_models <- list(population,
                      births,
                      deaths,
                      in_migration,
                      out_migration)


saveRDS(system_models,
        file = "out/system_models.rds")


                      

