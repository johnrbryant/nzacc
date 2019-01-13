library(demest)

debug(continueEstimation)
continueEstimation("out/model.est", nSim = 100, useC = FALSE)
## set control.args$parallel to FALSE by hand
debug(demest:::updateAccount)
debug(demest:::updateProposalAccountMoveComp)
object <- updateProposalAccountMoveComp(object)
expand.grid(dimnames(account@components[[2]]))[805,]
i.cell <- 805L
expand.grid(dimnames(combined@expectedExposure))[805,]
expand.grid(dimnames(account@population))[1007,]
expand.grid(dimnames(combined@accession))[998,]


diff.log.lik <- diffLogLikAccount(object)
diff.log.dens <- diffLogDensAccount(object)


debug(diffLogDensJumpComp)
diffLogDensJumpComp(object)


debug(diffLogDensExpComp)
diffLogDensExpComp(object)

expand.grid(dimnames(object@account@components[[2]]))[5654,]
expand.grid(dimnames(component))[6262,]
