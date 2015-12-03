# Adaptation to changing environments across real geographies

 
> How locally adaptive alleles arise and spread is well-understood on
> ideal, 1- or 2-dimensional "billiard table" landscapes,
> but real species may have to spread adaptive innovations across
> geographic barriers on many scales.  I examine how a range of habitat shapes
> inspired by real California geographies affect the speed, parallelism,
> and probability of evolutionary rescue.


## Statistics: across spatial scales,

1.  Decay of heterozygosity (coalescence rate)
2.  Probability of establishment of advantageous mutation
3.  Speed of spread of advantageous mutation


## Model:

Each plant produces a zero-or-Poisson number of seeds,
these are pollinated by other individuals with probability proportional to the pollen dispersal kernel;
then they disperse according to the seed dispersal kernel.
Local recruitment rates depend on the local density of competitors 
and the genotype of the seed.

Specifically, we suppose there is local logistic density regulation,
so that if the local number of individuals per unit area is $\rho$,
then the probability of recruitment is proportional to $1-\rho/\rho_{*}$.


**Parameters:**

1.  Masting probability $p_m=1-e^{-\gamma_m}$ and mean seed fecundity, $\mu_s$.
2.  Pollen dispersal kernel, $\phi_p(x,y)$.
3.  Seed dispersal kernel, $\phi_s(x,y)$.
4.  Basic recruitment probability $p_r=1-e^{-\gamma_r}$, and carrying capacity $\rho_{*}$.


Selection could come in most naturally
by modifying either masting probability $p_m$ or recruitment probability $\gamma$:
if $g \in \{0,1/2,1\}$ is the genotype at the selected locus,

* $p_m = 1-e^{-\gamma_m - sg}$
* or, $p_r = 1-e^{-\gamma_r - sg}$.

(Note that we can incorporate dominanse by replacing $sg$ with $(4h-1)sg + (2-4h)sg^2$,
which is equal to $hs$ for $g=1/2$ and equal to $s$ for $g=1$.)


## Methods:

Use geography plus migration kernel to obtain migration matrix;
simulate forwards-time in R.
