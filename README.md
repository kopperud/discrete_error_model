## Modeling observation error in discrete traits

Tree estimation using discrete molecular data is often based on very precise observational procedures (choosing conserved DNA regions, sequencing the same region many times, and sequencing techniques are robust). In other words, it is often safe to assume that the observation error is zero, or negligibly small. Therefore, it has not been necessary to incorporate observation error in the evolutionary model (with some exceptions, see single-cell sequencing literature).

With morphological data, it is not as reasonable to assume that the observation error is zero. Several factors can contribute:

1. Among-person scoring variation
2. Within-person scoring variation
3. Within-species phenotypic variation
4. Taphonomic processes, differences in preservation
5. Specimens vary in condition, for example in developmental stage, developmental deformities, injuries, tumors etc

Since it is not safe to assume that the observational error is negligibly zero, one approach is to incorporate it into the model. This repository 

1. Simulates some trees under the BD model
2. Simulates some character data under the Markov-chain model, and adds random observation error on the tip data
3. Inference of unrooted trees using RevBayes, modeling the observation error as a random variable
4. Evaluation of bias and precision of 
    a. Branch lengths
    b. Topology
5. Also a test using an empirical dataset. What is the best estimate for the magnitude of the observation error ($\beta$)?
