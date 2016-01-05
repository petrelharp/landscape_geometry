
Polygon-based simulations
=========================

These would be possible, using tools in rGEOS.
For instance, as [mentioned here](http://stackoverflow.com/questions/26499010/finding-adjacent-polygons-in-r-neighbors) 
a quick way to find adjacent polygons is
```
nb <- spdep::poly2nb( vegmap, foundInBox=rgeos::gUnarySTRtreeQuery(vegmap) ) 
```
This took 7 minutes on the western desert_veg dataset, with 47,514 polygons.
