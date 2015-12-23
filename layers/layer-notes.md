

Vegetation classification:
==========================

- [Desert vegtation classification](desert_veg)
    * downloaded from [BIOS](https://map.dfg.ca.gov/bios/?bookmark=534) on 11/24/15
    * by Todd Keeler-Wolf for DRECP
    * [western](desert_veg/western/metadata.html)
    * [eastern](desert_veg/eastern/metadata.html)
    * [anza borrego](desert_veg/anza_borrego/metadata.html)
    * to read, use e.g. `x <- readOGR(layer="ds165",dsn="ds165.gdb")`



Maxent species distribution models:
==========================


Climate projection models
-------------------------

From environmental niche models, including various climate scenarios, for desert plant species, 
on [data basin](http://databasin.org/galleries/f6344e81da864023a9fb550231fdcafc):

How to get these into `R`, using *Mentzelia tridentata* as an example:

0.  In the downloaded `.zip` file, there's a `data/v93/tempgdb.gdb/` directory with various `gdb` files in it.
    (Find these with `find . -name gdb`.)

1.  This gives info about the files: `ogrinfo -al data/v93/tempgdb.gdb/` including the layer name

2.  This can convert the file to something `R` can manage: `ogr2ogr output_dirname data/v93/tempgdb.gdb/`

*Note:*  in R, this works, once `ogrinfo` has given us the layer name (here is `"Mentzelia_tridentata"`): 
`ogrInfo("mentzelia_tridentata",layer="Mentzelia_tridentata")`


**Mojave:**


- [Mentzelia tridentata](mentzelia_tridentata) (creamy blazing star)
    * relatively continuous
    * downloaded from [data basin](http://databasin.org/datasets/fe1ade4bfc0e4ba6967320cf1eb4d231) on 11/24/15
    * 270m

- [Eschscholzia minutiflora ssp twisselmannii](http://databasin.org/datasets/96a4bf19c331413b9c5acc783adcfabc) (red rock poppy)
    * sparser, with many snakey/linear bits

- [Mimulus mohavensis](http://databasin.org/datasets/5aa3a1a3a6cc47aa909de45cc63e46af) (Mojave monkeyflower)
    * lots of little sparse patches

- [Muhlenbergia appressa](http://databasin.org/datasets/efbac3d421d24d0386d0290b197197c8) (Devil's canyon muhly, a grass)
    * fewer, bigger patches

**Sonoran:**

    - [Senna covesii](http://databasin.org/datasets/857237fc5ff64a1584674bd274013ce8) (Coves' senna)
    * lots of big, connected patches

- [Astragalus insularis var harwoodii](http://databasin.org/datasets/73d2dafe5c2447aca58597f9a1a9984b) (Harwood's milkvetch)
    * semi-connected, smallish patches

- [Abronia villosa var aurita](http://databasin.org/datasets/8d888852c9d74c0499dcfba8b3f215e1) (desert sand-verbena)
    * widely distributed around on mountains


Current extent 
--------------

These are available through the [UCSB Bren school](http://www.biogeog.ucsb.edu/);
a big file containing TIFFs of ranges for many species is [available](ftp://ftp.biogeog.ucsb.edu/pub/org/biogeog/data/CEC_desert/Mojavset.rar).

- [Downloaded](ftp://ftp.biogeog.ucsb.edu/pub/org/biogeog/data/CEC_desert/Mojavset.rar) on 12/20/2015.
- Species ranges in [Mojavset/Spatial/targets/biodiversity/binary](Mojavset/Spatial/targets/biodiversity/binary).
- Load with e.g. `x <- raster("Mojavset/Spatial/targets/biodiversity/binary/Boechera_shockleyi_broad_extent_avg.tif")`.
