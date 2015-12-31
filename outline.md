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

1.  Masting probability $p_m=1-e^{-\gamma_m}$ and mean seed fecundity, $\lambda_s$.
2.  Pollen dispersal kernel, $\phi_p(x,y)$.
3.  Seed dispersal kernel, $\phi_s(x,y)$.
4.  Basic recruitment probability $p_r=1-e^{-\gamma_r}$, and carrying capacity $\rho_{*}$.
5.  Death rate, $\mu$.


Selection could come in most naturally
by modifying masting probability $p_m$, 
recruitment probability $\gamma$,
or death rate $\mu$:
if $g \in \{0,1/2,1\}$ is the genotype at the selected locus,

* $p_m = 1-e^{-\gamma_m - sg}$
* or, $p_r = 1-e^{-\gamma_r - sg}$.

(Note that we can incorporate dominance by replacing $sg$ with $(4h-1)sg + (2-4h)sg^2$,
which is equal to 0 for $g=0$ and equal to $hs$ for $g=1/2$ and equal to $s$ for $g=1$.)

### Specifics

Suppose that the local numbers of individuals of genotype $g$ is given by $N_g$.

1.  Number of seed-producing individuals is
    $$ M_g \sim \text{Binomial}($N_g$,$p_m$) $$

2.  Probability a pollen parent at $x$ is of genotype $h$ from $y$ is
    $$ p_p(h;y,x) = \frac{ N_h(y) \phi_p(y,x) }{ \sum_z N(z) \phi_p(z,x) } $$
    *Note:* could introduce pollen limitation here by changing the denominator, to get a substochastic matrix.

3.  Number of seeds produced by (seed,pollen) parents $(g,h)$ at $x$ with pollen from $y$ and dispersing to $z$ is
    $$ \text{Poisson}( p_p(h;y,x) M_g(x) \phi_s(x,z) ) $$

4.  Total number of new seeds with parents $(g,h)$ germinating at $z$ is Poisson with mean
    $$ m_{g,h}(z) = \sum_{x,y} p_p(h;y,x) M_g(x) \phi_s(x,z) p_r(z) $$

5.  If parents $g_1$, $g_2$ have probability $\delta(g_1,g_2;h)$ of producing offspring $h$,
    then the number of new seeds of type $h$ germinating at $z$ is 
    $$ S_h(z) \sim \text{Poisson}(\sum_{g_1,g_2} \delta(g_1,g_2;h) \sum_{x,y} p_p(h;y,x) M_g(x) \phi_s(x,z) p_r(z) ) $$

6.  Some of these new offspring mutate.

7.  The number of previous individuals surviving is Binomial$(N_g,1-\mu)$.

Putting this together, 
$$ \begin{aligned}
m_{g,h}(z) 
    &= \sum_{x,y} \frac{ N_h(y) \phi_p(y,x) }{ \sum_z N(z) \phi_p(z,x) } M_g(x) \phi_s(x,z) p_r(z)  \\
\end{aligned} $$

1.  For each $g$,
    let $N_g$ and $M_g$ be vectors indexed by location;

2.  Let $\Phi_p$ be the pollen dispersal matrix,
    so that $\Phi_p(y,x)$ is the amount of pollen arriving at $x$ per unit produced at $y$ (should be substochastic),
    and let $\phi_h(x)$ be the total amount of $h$-pollen arriving at $x$, so that
    $$\phi_h = N_h \Phi_p ,$$
    and $\phi = \sum_h \phi_h$,
    so that we will have $\sum_y p_p(h;y,x) = \phi_h(x)/\phi(x)$.

3.  Define the mean number of $h$-seeds produced at $x$ to be $\psi'_h(x)$, where
    $$ \psi'_h = \sum_{g_1,g_2} \delta(g_1,g_2;h) \frac{ M_{g_1} \phi_{g_2} }{ \phi } ; $$

4.  Finally, let $\Phi_s$ be the seed dispersal matrix,
    so that $\Phi_s(x,y)$ is the probability a seed produced at $x$ ends up at $y$,
    and define the number of $h$-seeds germinating at $x$ to be $\psi_h(x)$, where
    $$ \psi_h = (\psi' \Phi_s) * p_r , $$
    where $a*b$ denotes component-wise multiplication.

5.  Previous individuals are Binomially thinned.

5.  The number of new, unmutated individuals is Poisson($\psi_h (1-\mu_h)$), where $\mu_h$ is the mutation probability;
    a Poisson($\sum_x \phi_h(x) \mu_h$) number of mutants are placed in locations chosen proportionally to $\phi_h$.


We will (almost?) always want to have **no mutation**
for measuring the above quantities.

Note that we have old individuals die *before* germation occurs, 
so that if death is required to make room for new individuals,
this can happen.


### Measuring the rate of drift

On a practical level, what we care about most is the maintenance of variation,
so we might want to run the simulation to mutation-drift equilibrium,
and see how much variation there is on different scales.

A quicker method of measuring the same thing
is to measure the variance in allele frequency increments:
pick a circle,
look at the time series of an allele frequency $p_t$ in that circle,
and compute the variance of $dp_t = p_{t+1}-p_t$,
probably divided by $p_t(1-p_t)$.
To avoid problems around $p_t = 0$ or $1$,
maybe do this with an allele with heterozygote advantage,
so that allele frequencies will hover around 50%?


### Measuring the probability of establishment

Run the simulation on small (local) parts of the map;
initiated with just a few mutant copies.
The time necessary to see if it will establish is about $1/s$;
and so the radius of the map necessary is $\sigma/\sqrt{s}$.

**Local competition:**
If we begin with $n$ mutants at location $x$,
and their fates are independent,
the probability the mutation establishes near $x$ is $1-(1-p_e)^n$.
Therefore, if $p_e(n)$ is this probability,
sublinearity in $\log(1-p_e(n))$ indicates the strength of local competition.

**Selection:** 
the probability of establishment depends on $s$;
it may make sense to look at $(1-(1-p_e(n))^{1/n})/s$ 
to compare different values of $s$.



### Measuring the rate of spread

Begin the simulation with small clusters of mutants:
either all in the same location
or perhaps the outcome of the previous local simulations.


### Habitat geometry

A summary statistic of habitat geometry related to all these things
is the profile of circle volume over radius;
we can get this in an intrinsic way by
running a simulation of an expanding advantageous allele
and looking at the profile of the resulting circles.


## Modeling


**Questions:**

1.  Should measure distance intrinsically (within the set of accessible locations) or extrinsically (as the crow flies)?


**Notes:**

1.  Code the range as 1 for habitable, 0 for accessible but inhabitable, and NA for inaccessible.
2.  The density of heterozygotes says where an expanding wave is and the strength of local drift.

**To-do:**

1.  Make a generic report applicable to an arbitrary demographic setup.
2.  Test this on flatspace and Sierpinski-ized habitats.
3.  Allow habitable and accessible to be migration-specific rather than population-specific (as functions of habitat values).
4.  Implement other offspring number distributions.
5.  Implement biased dispersal based on raster values.
6.  Include pollen limitation.

# Templated analyses

## Combinations to analyze

Rasters will cover about 200km on a side.
At a resolution of 200m, this is $10^6$ cells;
For instance, the *Yucca brevifolia* raster is 430 x 590 km, at 270m resolution;
it has $3.5\times10^6$ cells, but only 200,000 nonzero cells.

1.  Dispersal distance: long / short
2.  Dispersal distribution: local / long-tailed
3.  Dispersal: intrinsic / extrinsic
4.  Habitat shape: 1D / treelike / netlike / holey / 2D
5.  Population density: high / low
6.  Reproduction: high / low variance


## Set-up for the template

In an analysis we need to specify:

1.  A habitat raster and a portion of the raster to use. (in `habitats/`)
2.  Carrying capacities and choice of accessible portions of the raster. (in `populations/`)
2.  Models of migration and methods for population regulation. (in `demographies/`)


We will then record:

1.  Probability of establishment of a new mutation.
2.  Speed and width of adaptive waves.
3.  Dispersal distance, $\sigma$, computed from the migration matrix.
4.  Total population size.


## Analyses done

```
./templated.R test_habitat_reports/test_habitat_gaussian-expsqrt.html habitats/test_habitat.R demographies/gaussian-expsqrt.R
./templated.R random_landscape_reports/random_landscape_gaussian-expsqrt.html habitats/random_landscape.R demographies/gaussian-expsqrt.R
./templated.R Empidonax_traillii_extimus_reports/Empidonax_traillii_extimus_gaussian-expsqrt.html habitats/Empidonax_traillii_extimus.R populations/Empidonax_density.R demographies/gaussian-expsqrt.R
./templated.R Eschscholzia_minutiflora_ssp_twisselmannii_reports/Eschscholzia_minutiflora_ssp_twisselmannii_gaussian-expsqrt.html habitats/Eschscholzia_minutiflora_ssp_twisselmannii.R populations/Eschscholzia_density.R demographies/gaussian-expsqrt.R
./templated.R Xerospermophilus_mohavensis_reports/Xerospermophilus_mohavensis_gaussian-expsqrt.html habitats/Xerospermophilus_mohavensis.R populations/Xerospermophilus_density.R demographies/gaussian-expsqrt.R
./templated.R Yucca_brevifolia_reports/Yucca_brevifolia_gaussian-expsqrt.html habitats/Yucca_brevifolia.R populations/Yucca_density.R demographies/gaussian-expsqrt.R
```

Pulling updated htmls from phoebe:
```
rsync -avim --include="*_reports/" --include="*html" --exclude="*" peter@phoebe.usc.edu:$PWD/ .

```
