
library(methods)
library(demest)
library(docopt)
library(dplyr)

'
Usage:
model.R [options]

Options:
--n_burnin [default: 5]
--n_sim [default: 5]
--n_chain [default: 4]
--n_thin [default: 1]
' -> doc
opts <- docopt(doc)
n_burnin <- opts$n_burnin %>% as.integer()
n_sim <- opts$n_sim %>% as.integer()
n_chain <- opts$n_chain %>% as.integer()
n_thin <- opts$n_thin %>% as.integer()


set.seed(0)

account <- readRDS("out/account.rds")
system_models <- readRDS("out/system_models.rds")
datasets <- readRDS("out/datasets.rds")
data_models <- readRDS("out/data_models.rds")

estimateAccount(account = account,
                systemModels = system_models,
                datasets = datasets,
                dataModels = data_models,
                filename = "out/model.est",
                nBurnin = n_burnin,
                nSim = n_sim,
                nChain = n_chain,
                nThin = n_thin)

options(width = 120)
fetchSummary("out/model.est")
