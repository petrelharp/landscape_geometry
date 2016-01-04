## low density

habitable <- (!is.na(values(habitat)) & values(habitat)>0)
base.carrying.capacity <- 1/(100^2)  # per square meter
pop <- population( 
                  habitat = habitat,
                  accessible = !is.na(values(habitat)),
                  habitable = habitable,
                  genotypes = c("aa","aA","AA"),
                  carrying.capacity = base.carrying.capacity * prod(res(habitat)) * values(habitat)[habitable],
                  N = cbind( aa=rep(0,sum(habitable)),
                             aA=0, 
                             AA=0 ),
                  description = paste( habitat.description, "
    - defines carrying.capacity to be 1 per hectare
    - multiplied by values in habitat
    - only good habitat areas are accessible and habitable
", sep="\n")
             )


pop$N[,"aa"] <- rpois(sum(habitable),pop$carrying.capacity)
