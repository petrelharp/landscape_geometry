require(raster)
require(landsim)

seedish <- floor(1e6*runif(1))
# reproducible landscape
set.seed(42)


habitat <- random_habitat(diam=1000,res=100)
carrying.capacity <- values(habitat)[(!is.na(values(habitat)) & values(habitat)>0)]
pop <- population( 
                  habitat = habitat,
                  accessible = !is.na(values(habitat)),
                  habitable = (!is.na(values(habitat)) & values(habitat)>0),
                  genotypes = c("aa","aA","AA"),
                  carrying.capacity = carrying.capacity,
                  N = cbind( aa=rpois(length(carrying.capacity),carrying.capacity),
                             aA=0, 
                             AA=0 ),
                  description = "
random_landscape.R : 
    - Samples a random landscape using a smoothed Cauchy
    - defines carrying.capacity
"
             )

# restore randomness, hopefully
set.seed(seedish)
