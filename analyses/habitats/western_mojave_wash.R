require(raster)
require(landsim)

raster.file <- "../../layers/cleaned/desert_veg-western-wash_wetland.tif"

habitat <- raster(raster.file)
values(habitat) <- values(habitat)/100
values(habitat)[values(habitat)==0] <- NA
habitat.description <- "
western_mojave_wash.R :
    - derived from ds735, vegtypes for Western Mojave
    - see 'layers/make-western-desert_veg-raster.R' for details
    - just the 'wash/wetland' category
"
