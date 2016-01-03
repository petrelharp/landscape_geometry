require(raster)
require(landsim)

raster.file <- "../../layers/cleaned/desert_veg-central-woods_chaparral"

habitat <- raster(raster.file)
habitat.description <- "
central_mojave_woods.R :
    - derived from ds735, vegtypes for Western Mojave
    - see 'layers/make-central-desert_veg-raster.R' for details
    - just the 'woods/chaparral' category
"
