require(raster)
require(landsim)

raster.file <- "../../layers/cleaned/desert_veg-central-saline.tif"

habitat <- raster(raster.file)
values(habitat) <- values(habitat)/100
habitat.description <- "
central_mojave_saline.R :
    - derived from ds735, vegtypes for Central Mojave
    - see 'layers/make-central-desert_veg-raster.R' for details
    - just the 'saline' category
"
