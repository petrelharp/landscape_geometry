require(raster)
require(maps)
require(maptools)

.thisdir <- file.path(normalizePath("."))

#' Get county outlines to overlay on a Raster* object
#' @param x The Raster* object.
get_counties <- function (x) {
    mojave.outlines <- map("county",c("california","nevada","arizona"),
        xlim=c(-120,-113),ylim=c(31,37), plot=FALSE)
    mojave.outlines.sp <- map2SpatialLines(mojave.outlines,proj4string=CRS("+proj=longlat"))
    spTransform(mojave.outlines.sp,CRS(proj4string(x)))
}


#' Get elevation contours to overlay on a Raster* object
#' @param x The Raster* object.
get_dem <- function (x) {
    dem <- raster(file.path(.thisdir,"background/dem_30"))
    spTransform( rasterToContour(dem,nlevels=25), CRS(proj4string(x)) )
}

#' Get elevation shading to overlay on a Raster* object
#' @param x The Raster* object.
get_elev <- function (x) {
    # SR <- raster(file.path(.thisdir,"background/US_MSR_10M/US_MSR.tif"))
    # SR <- raster(file.path(.thisdir,"background/SR_HR/SR_HR.tif"))
    SR <- raster(file.path(.thisdir,"background/cropped_SR_HR.tif"))
    projectRaster(SR,to=raster(extent(x),res=500,crs=CRS(proj4string(x))))

}
