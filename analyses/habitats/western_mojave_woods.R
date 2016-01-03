require(raster)
require(landsim)

raster.file <- "../../layers/cleaned/desert_veg-western-woods_chaparral"

habitat <- raster(raster.file)
values(habitat) <- values(habitat)/100
values(habitat)[values(habitat)==0] <- NA
habitat.description <- "
western_mojave_woods.R :
    - derived from ds735, vegtypes for Western Mojave
    - see 'layers/make-western-desert_veg-raster.R' for details
    - just the 'woods/chaparral' category
"
