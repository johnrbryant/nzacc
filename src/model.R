
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
--seed [default: 0]
' -> doc
opts <- docopt(doc)
n_burnin <- opts$n_burnin %>% as.integer()
n_sim <- opts$n_sim %>% as.integer()
n_chain <- opts$n_chain %>% as.integer()
n_thin <- opts$n_thin %>% as.integer()
seed <- opts$seed %>% as.numeric()

set.seed(seed)

account <- readRDS("out/account.rds")
system_models <- readRDS("out/system_models.rds")
datasets <- readRDS("out/datasets.rds")
data_models <- readRDS("out/data_models.rds")

filename <- "out/model.est"

Sys.time()

estimateAccount(account = account,
                systemModels = system_models,
                datasets = datasets,
                dataModels = data_models,
                filename = filename,
                nBurnin = n_burnin,
                nSim = n_sim,
                nChain = n_chain,
                nThin = n_thin)
Sys.time()


options(width = 120)
fetchSummary(filename)
