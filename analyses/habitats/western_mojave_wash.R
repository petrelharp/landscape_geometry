require(raster)
require(landsim)

raster.file <- "../../layers/cleaned/desert_veg-western-wash_wetland"

habitat <- raster(raster.file)
habitat.description <- "
western_mojave_wash.R :
    - derived from ds735, vegtypes for Western Mojave
    - see 'layers/make-western-desert_veg-raster.R' for details
    - just the 'wash/wetland' category
"
