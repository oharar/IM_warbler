library(PointedSDMs)

load("Data/BTWarblerData.RData")

# change mesh vars with Meshpars -> more vertices = better approximation = longer calculations 
# units same as in projection
Meshpars <- list(max.edge = c(0.15, 0.3), offset = c(0.1, 0.4), cutoff = 0.2)

Mesh <- MakeSpatialRegion2(data = NULL, bdry = PA, meshpars = Meshpars,
                           proj =  proj)
stk.ip <- MakeIntegrationStack(mesh = Mesh$mesh, data = covariates, area=Mesh$w, 
                               tag='ip', InclCoords=TRUE)

# make data for projections
Nxy.scale <- 0.01 # change the resolution of the predictions
Boundary <- Mesh$mesh$loc[Mesh$mesh$segm$int$idx[,2],]
Nxy <- round(c(diff(range(Boundary[,1])), diff(range(Boundary[,2])))/Nxy.scale)
stk.pred <- MakeProjectionGrid(nxy = Nxy, mesh = Mesh$mesh, data = covariates,
                               tag = 'pred', boundary = Boundary)
# data stacks
stk.BBS <- MakeBinomStack(observs = BBS_sp,data = covariates, mesh=Mesh$mesh,
                          presname="NPres", trialname="Ntrials", tag='BBS', InclCoords=TRUE)
stk.gbif <- MakePointsStack(presences = GBIF_sp, data = covariates_gbif, mesh = Mesh$mesh, 
                            tag = 'gbif', InclCoords = TRUE)
stk.BBA <- MakeBinomStack(observs = BBA_sp, data = covariates, mesh = Mesh$mesh,
                          presname='present', tag='BBA', InclCoords=TRUE)

save(stk.ip, stk.pred, stk.gbif, stk.BBS, stk.BBA, Mesh, file="Data/Stacks.RData")