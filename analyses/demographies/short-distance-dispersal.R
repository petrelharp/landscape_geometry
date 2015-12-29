
demog <- demography(
        prob.seed = 0.2,
        fecundity = 100,
        prob.germination = vital( 
                 function (N, ...) {
                     out <- r0 / ( 1 + migrate(competition,x=rowSums(N))/carrying.capacity )
                     return( cbind( aa=out, aA=s*out, AA=s^2*out ) )
                 },
                 r0 = 0.01,  # one in ten seeds will germinate at low densities
                 s = 1.5,    # multiplicative selective benefit of the A allele
                 competition = migration(
                                         kern="gaussian",
                                         sigma=100,
                                         radius=300,
                                         normalize=1
                                     )
             ),
        prob.survival = 0.9,
        pollen.migration = migration(
                            kern = "gaussian",
                            sigma = 10,
                            radius = 50,
                            normalize = NULL
                     ),
        seed.migration = migration(
                            kern = "gaussian",
                            sigma = 50,
                            radius = 500,
                            normalize = 1
                     ),
        genotypes = c("aa","aA","AA"),
        description = "
short-distance-dispersal :
    - density-dependent population regulation via probability of germination
    - Gaussian seed dispersal over a short range
    - almost no pollen dispersal
    - needs 'carrying.capacity' to be defined.
"
    )


