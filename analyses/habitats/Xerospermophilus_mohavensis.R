require(raster)
require(landsim)

orig.infile <- "../../layers/Mojavset/Spatial/targets/biodiversity/binary/Xerospermophilus_mohavensis_broad_extent_avg.tif"
orig.outfile <- file.path("../../layers/cleaned",gsub("[.]tif$","_cleaned.tif",basename(orig.infile)))
if (FALSE) {
    # to *prepare* the raster
    x <- y <- raster(orig.infile)
    ngen <- 2
    N <- 1000
    migr <- migration( kern="gaussian", sigma=200, radius=1000, normalize=1/ngen )
    for (k in 1:ceiling(log(1e-8)/log(1/ngen))) {
        y <- y + migrate_raster(y,migr) 
    }
    y <- (1-1/ngen)*y
    values(y)[values(y)<1/N] <- NA
    y.clumps <- clump( y )
    z <- mask(y.clumps,x,maskvalue=0)
    clump.sizes <- sort( table(values(z))/sum(!is.na(values(z))), decreasing=FALSE )
    # include biggest clumps to get up to 95% of habitat
    big.clumps <- as.numeric( names( clump.sizes )[ cumsum(clump.sizes) > 0.05 ] )
    if (interactive()) { 
        plot(z,zlim=range(0,values(z),finite=TRUE)) 
        round( clump.sizes, 2 )
    }
    values(z) <- ifelse(values(z) %in% big.clumps, 1, NA)
    writeRaster(trim(z),file=orig.outfile,overwrite=TRUE)
}

habitat <- raster(orig.outfile)
carrying.capacity <- 5000 * prod(res(habitat))/270^2  # complete guess
habitable <- (!is.na(values(habitat)) & values(habitat)>0)
pop <- population( 
                  habitat = habitat,
                  accessible = !is.na(values(habitat)),
                  habitable = habitable,
                  genotypes = c("aa","aA","AA"),
                  carrying.capacity = carrying.capacity,
                  N = cbind( aa=rpois(sum(habitable),carrying.capacity),
                             aA=0, 
                             AA=0 ),
                  description = "
Xerospermophilus_mohavensis.R : 
    - from Xerospermophilus_mohavensis_broad_extent_avg.tif
    - defines carrying.capacity to be 10 / 270^2 m^2  # complete guess
    - only good habitat areas are accessible and habitable
"
             )

