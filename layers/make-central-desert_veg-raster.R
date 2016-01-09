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

vegmap <- readOGR("desert_veg/central","ds166")

type.table <- c(  
        Creosote                       =  "scrub",
        `Joshua Tree`                  =  NA,
        Blackbrush                     =  NA,
        `Mojave Yucca`                 =  NA,
        Playa                          =  "saline",
        Pinyon                         =  NA,
        `Low Elevation Wash System`    =  "wash/wetland",
        Shadscale                      =  "saline",  # atriplex confertifolia
        `Big Sagebrush`                =  NA,
        Saltbush                       =  "saline",
        `Sparse Vegetation`            =  NA,
        `Lava Beds and Cinder Cones`   =  NA,
        Dunes                          =  NA,
        `Desert Holly`                 =  NA,
        Hopsage                        =  NA,
        `Mid Elevation Wash System`    =  "wash/wetland",
        Juniper                        =  NA,
        `Iodine Bush-Bush Seepweed`    =  "saline",
        `Creosote-Brittlebush`         =  "scrub",
        `White Burrobush`              =  "scrub",
        Mesquite                       =  "wash/wetland",
        Urban                          =  NA,
        `Nevada Joint-Fir`             =  "woods/chaparral",
        Mining                         =  NA,
        Galleta                        =  NA,
        `Rural Development`            =  NA,
        `High Elevation Wash System`   =  "wash/wetland",
        Menodora                       =  NA,
        `Limber Pine/Bristlecone Pine` =  "woods/chaparral",
        Agriculture                    =  NA,
        `Alkali Meadow/Sink`           =  "saline"
    )

types <- sort(unique(type.table))

vegmap$Partition <- factor( type.table[match(vegmap$LABEL_1,names(type.table))], levels=types )

counties <- get_counties(vegmap)
elev <- get_dem(vegmap)
shade <- get_elev(vegmap)


# plot vegmap
png(file="central-desert_veg.png",width=8*150,height=8*150,res=150,pointsize=10)

vegtype.cols <- rainbow_hcl(nlevels(vegmap$LABEL_1))
vegtype.cols[match("Creosote",levels(vegmap$LABEL_1))] <- "gold2"

plot( shade, col=adjustcolor(grey(seq(0,1,length.out=101)),0.5), legend=FALSE )
plot( vegmap, col=vegtype.cols[vegmap$LABEL_1], border=NA, add=TRUE )
lines(counties,lty=2,col=adjustcolor("black",0.5))
lines(elev,col=adjustcolor('black',0.25))

dev.off()


# plot paritition
png(file="central-desert_veg-parition.png",width=8*150,height=8*150,res=150,pointsize=10)

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
                    file=paste("cleaned/desert_veg-central-",gsub("/","_",tt),".tif",sep=''),
                    format="GTiff", overwrite=TRUE)
}
