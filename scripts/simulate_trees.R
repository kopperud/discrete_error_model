library(TESS)
library(ape)

set.seed(123)
n_trees <- 10
trees <- tess.sim.taxa(n_trees, 25, 50.0, 0.4, 0.2)

treeheight <- function(tree) max(node.depth.edgelength(tree))
sapply(trees, treeheight)

for (i in 1:n_trees){
    fpath <- paste0("data/tree", i, ".tre")
    write.tree(trees[[i]], fpath)
}

