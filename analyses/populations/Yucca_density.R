carrying.capacity <- 120 * prod(res(habitat))/270^2  # estimated from google maps near desert queen mine
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
                  description = paste( habitat.description, "
    - defines carrying.capacity to be 120/270^2 m^2
    - only good habitat areas are accessible and habitable
", sep="\n")
             )


