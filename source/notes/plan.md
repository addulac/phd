# Thesis Plan as it should be

**Title** : Random Graph model for links prediction: Social network perspective



# Introduction
## thesis overview

## thesis outline


# State of the art

* Social network analysis
    * type of networks and applications (clustering, link prediction, compression) 
    * Properties (micro properties / vs macro properties)
    * Algorithms and applications
* Random graph model (how to represent them, as object, as model..)
    * Erdos-Reni
    * Barabasi-ALbert
    * Stochatic Blockmodel
        * SB
        * IRM
    * Stochastic Mixed-Membership model
        * (latent space ?)
        * LFM
        * MMSB
        * non parametric extensions
* Bayesian Inference (how to infer the model given observation / probabilistic representation, expoential familly, links with bregman divergence and matrix factorisation =>  cast it in more genreal theory.)
    * Markov Chain Monte Carlo (MCMC)
    * Variational Inference
    * Stochastic Variationan Inference (SVB)
* Other Approach
    * matrix factorization
    * Deep learning



# Study of random graph model properties for social network (contrib 1)

* homophily
* preferential attachment
* sparsity
* experimentation

* (note on pymake (contrib 3): * plateform for reproducible research (open source project)

<!-- reproduce experiment for sampled mask 10 zeros for each edges -->


# Model for weighted and temporal networks (contrib 2)

* poisson process (and/or neg bin, ) model extension of MMSB (retains as best properties and scalable trough SVB)
* temporal/weighted large scale networks inference

if possible:

* review theoritical properties defined contrib 1
* process with growing edge and node.



# Perspective
...

# Conclusion
...

# Mathematical/Formal Background

* Probability (and random process)

    * (Measurable space, random variable, probability space)
    * (sigma algebra, measurable function. (and other, polish space ?))
    * Random variable, random vector, array and process and object in general.
    * Convergence of random variable
    * Bayesian inference
* Exponential familly distributions
* Fondemental Theorem
    * representation theorems
* Nonparametric prior (DP, HDP, GP)

