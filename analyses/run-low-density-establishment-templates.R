#!/usr/bin/Rscript

library(raster)
library(rmarkdown)

# layer.files <- list.files("../layers/cleaned","^[^.]*[.]tif",full.names=TRUE)
# layer.extents <- lapply( layer.files, function (x) { plot(raster(x)); drawExtent() } )
# names(layer.extents) <- basename(layer.files)
layer.extents <- structure(c(233443.098570033, 311701.205571521, -229665.03807998, 
                -149298.943683523, 273093.87278412, 327874.547685162, -298550.261848372, 
                -252626.779336111, 352395.421212295, 395698.240419785, -278719.667127168, 
                -247408.201777899, 240225.467843495, 277267.638490866, -235405.473394013, 
                -191047.564149215, 438254.993228854, 462321.746138384, 3863717.22672952, 
                3888836.95676809, 428488.774656871, 461972.952617956, 3880812.59856133, 
                3901745.70692681, 458833.810934004, 458833.810934204, 3799173.47593585, 
                3799173.47593605, 355939.722407854, 394307.00965493, 3851506.24684965, 
                3887441.4162104, -1977064.94831181, -1852562.41470005, 1384719.57455622, 
                1490440.13562651, -1946861.70297134, -1917706.42845807, 1586645.90067353, 
                1609733.22251032, -1937358.40111462, -1859315.3099733, 1534863.13398487, 
                1591828.45717179, -2008333.17236116, -1928455.14536052, 1583111.794443, 
                1667005.75377039), .Dim = c(4L, 12L), .Dimnames = list(NULL, 
                    c("desert_veg-central-saline.tif", "desert_veg-central-scrub.tif", 
                    "desert_veg-central-wash_wetland.tif", "desert_veg-central-woods_chaparral.tif", 
                    "desert_veg-western-saline.tif", "desert_veg-western-scrub.tif", 
                    "desert_veg-western-wash_wetland.tif", "desert_veg-western-woods_chaparral.tif", 
                    "Empidonax_traillii_extimus_broad_extent_avg_cleaned.tif", 
                    "Eschscholzia_minutiflora_ssp_twisselmannii_broad_extent_avg_cleaned.tif", 
                    "Xerospermophilus_mohavensis_broad_extent_avg_cleaned.tif", 
                    "Yucca_brevifolia_broad_extent_avg_cleaned.tif")))

layer.files <- file.path("../layers/cleaned", colnames(layer.extents))

source("run_template.R")  # provides run_template function

outdir <- "establishment-probs_low-density"
dir.create(outdir,showWarnings=FALSE)

for (k in seq_along(layer.files)) {
    output.file <- file.path( outdir, paste(colnames(layer.extents)[k],"_prob.html",sep='') )
    habitat <- crop( raster( layer.files[k] ), extent(layer.extents[,k]) )
    run_template( "establishment-prob-low-density-template.Rmd", output=output.file )
}
