
demog <- demography(
        prob.seed = 0.2,
        fecundity = 500,
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
                            kern = function (x) { exp(-sqrt(x)) },
                            sigma = 300,
                            radius = 1200,
                            normalize = NULL
                     ),
        seed.migration = migration(
                            kern = "gaussian",
                            sigma = 100,
                            radius = 1200,
                            normalize = 1
                     ),
        genotypes = c("aa","aA","AA")
        description = "
Yucca-demography.R :
    - density-dependent population regulation via probability of germination
    - Gaussian seed dispersal
    - exp-sqrt pollen dispersal
    - needs 'carrying.capacity' to be defined.
"
    )


