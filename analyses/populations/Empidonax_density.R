
carrying.capacity <- 1 * prod(res(habitat))/270^2  # complete guess
habitable <- (!is.na(values(habitat)) & values(habitat)>0)
pop <- population( 
                  habitat = habitat,
                  accessible = rep(TRUE,length(values(habitat))),
                  habitable = habitable,
                  genotypes = c("aa","aA","AA"),
                  carrying.capacity = carrying.capacity,
                  N = cbind( aa=rpois(sum(habitable),carrying.capacity),
                             aA=0, 
                             AA=0 ),
                  description = paste(habitat.description,"
    - defines carrying.capacity to be 1 / 270^2 m^2  # complete guess
    - all areas are accessible
    - only good habitat areas are habitable
", sep='\n')
             )


