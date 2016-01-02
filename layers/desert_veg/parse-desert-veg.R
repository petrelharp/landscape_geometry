library(rgdal)
library(raster)
library(sp)
library(colorspace)
library(maps)
source("../layer_utils.R",chdir=TRUE)

outdir <- "thumbs"
dir.create(outdir,showWarnings=FALSE)

### central Mojave

prefix <- "central"

vegmap <- readOGR("central","ds166")
names(vegmap)[match(c("AREA_","LABEL_1"),names(vegmap))] <- c("AREA","VEGTYPE")
vegtypes <- levels(vegmap$VEGTYPE)
counties <- get_counties(vegmap)
elev <- get_dem(vegmap)
shade <- get_elev(vegmap)

# to get total area by each
areas <- sort( tapply(vegmap$AREA,vegmap$VEGTYPE,sum) )

# dput( sample( rainbow_hcl(nlevels(vegmap$VEGTYPE)) ) )
central.cols <- c("#3CBCC1", "#8BB772", "#B7A0E0", "#3DBEAB", "#6BBC87", "#A7B166", 
        "#D89E80", "#DE9B8C", "#9AB46A", "#B4AE64", "#C49CDD", "#4ABACB", 
        "#5ABD93", "#E29898", "#70B3DA", "#E495A5", "#D1A276", "#84AFDF", 
        "#37BDB7", "#E293BC", "#7CBA7C", "#5CB7D3", "#C9A66D", "#BFAA67", 
        "#E494B1", "#4ABE9F", "#96AAE1", "#CF98D7", "#A7A5E2", "#DE94C7", "#D895D0")

png(file=file.path(outdir,paste(prefix,"_",gsub(" ","_","everything"),".png",sep='')), width=6*180, height=6*180, res=180)
plot( shade, col=adjustcolor(grey(seq(0,1,length.out=101)),0.5), legend=FALSE )
plot( vegmap, col=central.cols, border=NA, add=TRUE )
lines(counties,lty=2,col=adjustcolor("black",0.5))
lines(elev,col=adjustcolor('grey',0.5))
dev.off()

for (vt in vegtypes) {
    png(file=file.path(outdir,paste(prefix,"_",gsub("[ /]","_",vt),".png",sep='')), width=6*180, height=6*180, res=180)
    plot( shade, col=adjustcolor(grey(seq(0,1,length.out=101)),0.5), legend=FALSE )
    # plot( vegmap, col=adjustcolor(central.cols,0.5), border=NA, add=TRUE )
    lines(counties,lty=2,col=adjustcolor("black",0.5))
    lines(elev,col=adjustcolor('grey',0.5))
    plot( subset(vegmap,VEGTYPE==vt), col=central.cols[match(vt,vegtypes)],
        main=vt, xlab='', ylab='', add=TRUE )
    dev.off()
}


### western Mojave

prefix <- "western"

vegmap <- readOGR("western/ds735.gdb","ds735")


names(vegmap)[match(c("Shape_Area","NVCSName"),names(vegmap))] <- c("AREA","VEGTYPE")
vegtypes <- levels(vegmap$VEGTYPE)
counties <- get_counties(vegmap)
elev <- get_dem(vegmap)
shade <- get_elev(vegmap)

# to get total area by each
areas <- sort( tapply(vegmap$AREA,vegmap$VEGTYPE,sum) )

# dput( sample( rainbow_hcl(nlevels(vegmap$VEGTYPE)) ) )
central.cols <- c(
    "#8BB772", "#5EB6D4", "#40BEA9", "#B8A0E0", "#43BEA6", "#6CB4D9", 
    "#BFAA67", "#ACB065", "#61BD8F", "#74BB81", "#D397D4", "#C59CDD", 
    "#38BDBC", "#80B979", "#65BC8C", "#3DBEAB", "#C9A66D", "#C79BDB", 
    "#91ACE1", "#84B977", "#99B56B", "#9CB469", "#E494AE", "#E2979C", 
    "#C4A86A", "#D4A07A", "#C29DDE", "#59BD94", "#51BE9A", "#3CBCC1", 
    "#DC94CA", "#50B9CE", "#BDAB66", "#CFA373", "#8CADE0", "#7FB0DE", 
    "#55BD97", "#3EBCC3", "#7AB1DC", "#41BBC5", "#3ABCBE", "#DE9A8D", 
    "#E29899", "#D1A275", "#B8AC65", "#E3969F", "#D995CE", "#A2A7E2", 
    "#46BEA3", "#DD9B8A", "#B1A2E1", "#BF9EDF", "#E393B9", "#8FB770", 
    "#B2AE64", "#49BEA0", "#CBA56F", "#99A9E2", "#69BC89", "#A3B267", 
    "#6DBC86", "#75B2DB", "#A6B266", "#CA9ADA", "#E193C0", "#D89F7F", 
    "#59B7D2", "#E495A5", "#83AFDF", "#E494B3", "#ADA3E2", "#E09993", 
    "#D3A177", "#38BEB4", "#38BDB9", "#67B5D7", "#48BACA", "#7CBA7B", 
    "#88AEDF", "#E19896", "#E293BB", "#3BBEAE", "#B5AD64", "#9EA8E2", 
    "#AFAF64", "#CD99D9", "#DF9A90", "#E396A2", "#C2A968", "#DC9C87", 
    "#45BBC8", "#DA9D85", "#AAA5E2", "#CDA471", "#BAAC65", "#D198D6", 
    "#E494AB", "#5DBD91", "#96B56C", "#A0B368", "#37BDB6", "#D99E82", 
    "#95AAE1", "#D596D2", "#E494B0", "#55B8D0", "#DF94C5", "#88B874", 
    "#71B3DA", "#A6A6E2", "#E393B6", "#4DBE9D", "#78BA7E", "#E093C3", 
    "#92B66E", "#63B6D5", "#39BEB1", "#DB95CC", "#4CB9CC", "#A9B165", 
    "#B5A1E1", "#D796D0", "#D6A07D", "#E495A8", "#BB9FE0", "#E293BE", 
    "#CF98D7", "#C6A76B", "#71BB83", "#DE94C8")

png(file=file.path(outdir,paste(prefix,"_",gsub(" ","_","everything"),".png",sep='')), width=6*180, height=6*180, res=180)
plot( shade, col=adjustcolor(grey(seq(0,1,length.out=101)),0.5), legend=FALSE )
plot( vegmap, col=central.cols, border=NA, add=TRUE )
lines(counties,lty=2,col=adjustcolor("black",0.5))
lines(elev,col=adjustcolor('grey',0.5))
dev.off()

for (vt in vegtypes) {
    png(file=file.path(outdir,paste(prefix,"_",gsub(" ","_",vt),".png",sep='')), width=6*180, height=6*180, res=180)
    plot( shade, col=adjustcolor(grey(seq(0,1,length.out=101)),0.5), legend=FALSE )
    # plot( vegmap, col=adjustcolor(central.cols,0.5), border=NA )
    lines(counties,lty=2,col=adjustcolor("black",0.5))
    lines(elev,col=adjustcolor('grey',0.5))
    plot( subset(vegmap,VEGTYPE==vt), col=central.cols[match(vt,vegtypes)],
        main=vt, xlab='', ylab='', add=TRUE )
    dev.off()
}
