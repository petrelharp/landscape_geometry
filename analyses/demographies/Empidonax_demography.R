
demog <- demography(
        prob.seed = 0.8,
        fecundity = vital(
                 function (N, ...) {
                     out <- f0 / ( 1 + migrate(competition,x=rowSums(N))/carrying.capacity )
                     return( cbind( aa=out, aA=s*out, AA=s^2*out ) )
                 },
                 f0 = 3,       # base fecundity in uncrowded situations
                 s = 1.5,      # multiplicative selective benefit of the A allele
                 competition = migration(
                                         kern="gaussian",
                                         sigma=200,
                                         radius=400,
                                         normalize=1
                                     )
             ),
        prob.germination = 0.8,
        prob.survival = 0.9,
        pollen.migration = migration(
                            kern = "gaussian",
                            sigma = 300,
                            radius = 1000,
                            normalize = NULL,
                            n.weights=c(rep(0,8),1)
                     ),
        seed.migration = migration(
                            kern = "gaussian",
                            sigma = 400,
                            radius = 1500,
                            normalize = 1,
                            n.weights=c(rep(0,3),1)
                     ),
        genotypes = c("aa","aA","AA"),
        description = "
Empidonax-motivated: 
    - density-dependent population regulation via fecundity
    - low fecundity; most establish
    - moderate dispersal of mates; higher dispersal of young
    - needs 'carrying.capacity' to be defined.
    - growth rate for aa at low density is 0.8 * 3 * 0.8 + 1-0.9 = 2.02
"
    )


