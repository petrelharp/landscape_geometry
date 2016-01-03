require(raster)
require(landsim)

raster.file <- "../../layers/cleaned/desert_veg-western-scrub"

habitat <- raster(raster.file)
habitat.description <- "
western_mojave_scrub.R :
    - derived from ds735, vegtypes for Western Mojave
    - see 'layers/make-western-desert_veg-raster.R' for details
    - just the 'scrub' category
"
