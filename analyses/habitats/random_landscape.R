set.seed(42)
devtools::load_all("../../landsim")

habitat <- random_habitat()
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

