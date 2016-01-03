require(raster)
require(landsim)

raster.file <- "../../layers/cleaned/desert_veg-western-saline"

habitat <- raster(raster.file)
habitat.description <- "
western_mojave_saline.R :
    - derived from ds735, vegtypes for Western Mojave
    - see 'layers/make-western-desert_veg-raster.R' for details
    - just the 'saline' category
"
