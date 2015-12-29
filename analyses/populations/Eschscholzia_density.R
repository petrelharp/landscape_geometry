
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
                  description = paste(habitat.description,"
Eschscholzia_minutiflora_ssp_twisselmannii.R : 
    - from Eschscholzia_minutiflora_ssp_twisselmannii_broad_extent_avg.tif
    - defines carrying.capacity to be 5000 / 270^2 m^2
    - only good habitat areas are accessible and habitable
", sep="\n")
             )


