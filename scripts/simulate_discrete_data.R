library(ape)
library(phytools)

set.seed(123)
n_traits <- 50
n_trees <- 10

cat("Reading in trees. \n")
trees <- list()
for (i in 1:n_trees){
  fpath <- paste0("data/tree", i, ".tre")
  trees[[i]] <- read.tree(fpath)
}
n_tips <- length(trees[[1]]$tip.label)

### The Markov process
mu <- 0.05
Q <- matrix(
  c(-mu, mu, mu, -mu),
  ncol = 2
)


## Simulate histories
cat("Simulating character histories. \n")
histories <- list()
tip_states <- list()
for (i in 1:n_trees){
  h2 <- list()
  tip_states_m <- matrix(NA, nrow = n_tips, ncol = n_traits)
  for (j in 1:n_traits){
    h <- sim.history(trees[[i]], Q, message = FALSE)
    #histories[[j]] <- h
    tip_states_m[,j] <- as.numeric(unname(h$states))-1
    h2[[j]] <- h
  }
  tip_states[[i]] <- tip_states_m
  histories[[i]] <- h2
}

number_of_state_changes <- list()
for (j in 1:n_traits){
  number_of_state_changes[[j]] <- sum(sapply(histories[[1]][[j]]$maps, function(x) length(x)-1))
}
sum(unlist(number_of_state_changes)) / n_traits

## Add observation error
cat("Adding observation error. \n")
betas <- c(0.0, 0.05, 0.10, 0.15)
n_beta <- length(betas)

foo <- function(tip_states, beta1){
  tip_states_with_error <- tip_states
  for (i in 1:nrow(tip_states)){
    for (j in 1:ncol(tip_states)){
      r <- runif(1,0,1)
      if (r < beta1){
        #cat(".")
        tip_states_with_error[i,j] <- sample.int(2,1)-1
      }
    }
  }
  return(tip_states_with_error)
}

## Write to a nexus file
cat("Writing data to nexus files. \n")
for (q in 1:n_trees){
  for (b in 1:n_beta){
    for (i in 1:n_traits){
      l1 <- list()
      l2 <- list()
      tip_states_with_error <- foo(tip_states[[q]], betas[b])
      for (j in 1:n_tips){
        splab <- trees[[q]]$tip.label[j]
        states <- tip_states[[q]][j,]
        states_with_error <- tip_states_with_error[j,]
        
        l1[splab] <- list(states)
        l2[splab] <- list(states_with_error)
      }
      ape::write.nexus.data(l1, file = paste0("data/tree", q, ".nex"), format = "standard")
      ape::write.nexus.data(l2, file = paste0("data/tree", q, "_beta", b, ".nex"), format = "standard")
    } 
  } 
}

## Problem: the "symbols" are "0123456789", should be "01"
cat("Fixing nexus metadata. \n")
fpaths <- Sys.glob("data/*.nex")
for (i in seq_along(fpaths)){
  fpath <- fpaths[i]
  
  tx  <- readLines(fpath)
  tx2  <- gsub(pattern = "0123456789", replace = "01", x = tx)
  writeLines(tx2, con = fpath)
}
