migr <- migration( kern="gaussian", sigma=100, radius=400, normalize=1 )
demog <- demography(
        prob.seed = 0.2,
        fecundity = 100,
        carrying.capacity=10,
        prob.germination = vital( 
                 function (N, ...) {
                     out <- r0 / ( 1 + rowSums(N)/carrying.capacity )
                     return( cbind( aa=out, aA=s*out, AA=s^2*out ) )
                 },
                 r0 = 0.01,  # one in ten seeds will germinate at low densities
                 s = 1.0     # multiplicative selective benefit of the A allele
             ),
        prob.survival = 0.9,
        pollen.migration = migr,
        seed.migration = migr,
        genotypes = c("aa","aA","AA"),
        mating = mating_tensor( c("aa","aA","AA") ),
        description = "
test-demography.R : a simple demography
    - density-dependent population regulation via probability of germination
    - Gaussian seed and pollen dispersal with same kernel
    - fixed carrying capacity equal to 10
"
    )


