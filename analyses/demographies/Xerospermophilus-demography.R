
demog <- demography(
        prob.seed = 0.5,
        fecundity = vital( 
                 function (N, ...) {
                     out <- f0 / ( 1 + migrate(competition,x=rowSums(N))/carrying.capacity )
                     return( cbind( aa=out, aA=s*out, AA=s^2*out ) )
                 },
                 f0 = 10,
                 s = 1.5,    # multiplicative selective benefit of the A allele
                 competition = migration(
                                         kern="gaussian",
                                         sigma=100,
                                         radius=300,
                                         normalize=1
                                     )
             ),
        prob.germination = 0.5,
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
Xerospermophilus-demography.R :
    - low fecundity
    - density-dependent population regulation via fecundity
    - Gaussian dispersal of young over a short range
    - almost no dispersal of mates
    - needs 'carrying.capacity' to be defined.
"
    )


