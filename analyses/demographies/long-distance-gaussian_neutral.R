
demog <- demography(
        prob.seed = 0.2,
        fecundity = vital( 
                 function (N, ...) {
                     out <- f0 / ( 1 + migrate(competition,x=rowSums(N))/carrying.capacity )
                     return( cbind( aa=out, aA=s*out, AA=s^2*out ) )
                 },
                 f0 = 100, 
                 s = 1.0,    # multiplicative selective benefit of the A allele
                 competition = migration(
                                         kern="gaussian",
                                         sigma=100,
                                         radius=300,
                                         normalize=1
                                     )
             ),
        prob.germination = 0.1,
        prob.survival = 0.9,
        pollen.migration = migration(
                            kern = "gaussian",
                            sigma = 200,
                            radius = 600,
                            normalize = NULL,
                            n=9
                     ),
        seed.migration = migration(
                            kern = "gaussian",
                            sigma = 200,
                            radius = 600,
                            normalize = 1,
                            n=6  # sqrt(6)*200 = 489
                     ),
        genotypes = c("aa","aA","AA"),
        description = "
long-distance-gaussian :
    - density-dependent population regulation via probability of germination
    - Gaussian seed and pollen dispersal over a long range
    - needs 'carrying.capacity' to be defined.
"
    )


