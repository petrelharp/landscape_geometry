## Make a smallish number of layers of various combinations from the Western Mojave layer
#
# NOTE: set TMPDIR to a partition with lots of space before running

library(rgdal)
library(raster)
library(sp)
library(rgeos)
library(colorspace)
library(maps)
source("layer_utils.R",chdir=TRUE)

vegmap <- readOGR("desert_veg/western/ds735.gdb","ds735")

# remove disconnected bits down towards jtree
vegmap <- crop(vegmap, extent(c(xmin=335703.53824523, xmax=547983.986822801, ymin=3793198.76315726, ymax=3964630.37789317)) )

# grrr, unicode: two versions of the same level
levels(vegmap$NVCSMG) <- gsub("–"," - ",levels(vegmap$NVCSMG))

# note that `North American Warm Semi-Desert Cliff, Scree, and Other Rock Vegetation` for some reason includes playas and rocky hillsides:
# with(subset(vegmap@data,NVCSMG=="North American Warm Semi-Desert Cliff, Scree, and Other Rock Vegetation"),table(droplevels(NVCSName)))

type.table <- c(  
    `Mojavean - Sonoran Desert Scrub` = "scrub",
    `Inter-Mountain Dry Shrubland and Grassland` = "scrub",
    `North American Warm Semi-Desert Cliff, Scree, and Other Rock Vegetation` = NA,
    `Warm Semi-Desert/Mediterranean Alkali - Saline Wetland` = "saline",
    `California Annual and Perennial Grassland` = NA,
    `Madrean Warm Semi-Desert Wash Woodland/Scrub` = "wash/wetland",
    `Cool Semi-Desert Alkali-Saline Flats` = "saline",
    `Cool Semi-desert wash and disturbance scrub` = "wash/wetland",
    `California Coastal Scrub` = "woods/chaparral",
    `California Forest and Woodland` = "woods/chaparral",
    `California Chaparral` = "woods/chaparral",
    `Warm Interior Chaparral` = "woods/chaparral",
    `Southwestern North American Riparian, Flooded and Swamp Forest` = "wash/wetland",
    `Great Basin Saltbrush Scrub` = "saline",
    `Intermountain Basins Pinyon-Juniper Woodland` = "woods/chaparral",
    `Western North America Tall Sage Shrubland and Steppe` = NA,
    `Western North America Wet Meadow and Low Shrub Carr` = "wash/wetland",
    `Western North American Freshwater Marsh` = "wash/wetland",
    `Californian - Vancouverian Montane and Foothill Forest` = NA,
    `Cool Semi-Desert Alkali - Saline Wetlands` = "saline",
    `Western Cordilleran Montane Shrubland and Grassland` = NA,
    `Western North American Vernal Pool` = "wash/wetland",
    `Western Cordilleran Montane - Boreal Riparian Scrub and Forest` = NA
  )
types <- sort(unique(type.table))

vegmap$Partition <- factor( type.table[match(vegmap$NVCSMG,names(type.table))], levels=types )

counties <- get_counties(vegmap)
elev <- get_dem(vegmap)
shade <- get_elev(vegmap)

# plot
png(file="western-desert_veg-parition.png",width=8*150,height=8*150,res=150,pointsize=10)

type.cols <- RColorBrewer::brewer.pal(length(types),"Dark2")

plot( shade, col=adjustcolor(grey(seq(0,1,length.out=101)),0.5), legend=FALSE )
for (k in seq_along(types)) {
    plot( subset(vegmap,Partition==types[k]), col=adjustcolor(type.cols[k],0.9), border=if(types[k]=="wash/wetland"){adjustcolor("black",0.75)}else{NA}, add=TRUE )
}
lines(counties,lty=2,col=adjustcolor("black",0.5))
lines(elev,col=adjustcolor('grey',0.5))
legend("topright", fill=type.cols, border=ifelse(types=="wash/wetland",adjustcolor("black",0.75),NA), legend=types)

dev.off()

## make layers for each
## TAKES A LONG TIME
for (tt in types) {
        cat(tt,"\n")
        x <- rasterize( subset(vegmap,Partition==tt),
                   raster(extent(vegmap),res=200), getCover=TRUE )
        # rasterize returns PERCENTS
        values(x) <- values(x)/100
        writeRaster( x,
                    file=paste("cleaned/desert_veg-western-",gsub("/","_",tt),".tif",sep=''),
                    format="GTiff", overwrite=TRUE)
}

