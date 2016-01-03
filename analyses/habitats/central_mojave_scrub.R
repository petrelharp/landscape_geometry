require(raster)
require(landsim)

raster.file <- "../../layers/cleaned/desert_veg-central-scrub"

habitat <- raster(raster.file)
values(habitat) <- values(habitat)/100
values(habitat)[values(habitat)==0] <- NA
habitat.description <- "
central_mojave_scrub.R :
    - derived from ds735, vegtypes for Western Mojave
    - see 'layers/make-central-desert_veg-raster.R' for details
    - just the 'scrub' category
"
