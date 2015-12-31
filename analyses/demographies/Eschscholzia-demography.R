
demog <- demography(
        prob.seed = 0.9,
        fecundity = 10000,
        prob.germination = vital( 
                 function (N, ...) {
                     out <- r0 / ( 1 + rowSums(N)/carrying.capacity )
                     return( cbind( aa=out, aA=s*out, AA=s^2*out ) )
                 },
                 r0 = 0.01,  
                 s = 1.5    # multiplicative selective benefit of the A allele
             ),
        prob.survival = 0.75,
        pollen.migration = migration(
                            kern = "cauchy",
                            sigma = 100,
                            radius = 3000,
                            normalize = NULL
                     ),
        seed.migration = migration(
                            kern = "cauchy",
                            sigma = 50,
                            radius = 1000,
                            normalize = 1
                     ),
        genotypes = c("aa","aA","AA"),
        description = "
Escscholzia-demography : 
    - high fecundity
    - density-dependent population regulation via probability of germination
    - Cauchy seed dispersal over a short range
    - Cauchy pollen dispersal over a medium range
    - needs 'carrying.capacity' to be defined.
"
    )


