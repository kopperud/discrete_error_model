library(ggplot2)
library(tibble)


#df$absdiff <- abs(df[["tree1_beta1_witherror_run_1.trees"]] - df[["tree1_beta1_witherror_run_2.trees"]])
#df$mean <- (df[["tree1_beta1_witherror_run_1.trees"]] + df[["tree1_beta1_witherror_run_2.trees"]]) / 2

ess <- 625

## fast version
f2 <- function(p, B){
    is <- seq(0, ess)
    
    pis <- dbinom(is, ess, p)
    #ess <- 625
    #A <- matrix(is, nrow = ess+1, ncol = ess+1)
    #B <- abs(A - t(A))
    #B matrix is same for all p, so no need to compute each time
    
    C <- tcrossprod(pis)

    res <- (1/ess) * sum(B * C)
    return(res)
}

## calculate quantile of split frequencies
## quadratic spacing
sq_seq <- function(from = 1, to = 100, length.out = 6){
    (seq(sqrt(from), sqrt(to), length.out = length.out))^2
}

x1 <- sq_seq(0.0, 0.5, length.out = 50)
x2 <- 1.0 - x1 ## mirror on right side
x <- unique(c(x1, x2))

is <- seq(0.0, ess)
A <- matrix(is, nrow = ess+1, ncol = ess+1)
B <- abs(A - t(A)) ## B is a Toeplitz matrix

expected_sf <- sapply(x, function(p) f2(p, B))
expected_sf_df <- tibble(
                     x = x, 
                     expected_sf = expected_sf,
                     ymin = 0)

## figure out if the splits "pass" or "fail the convergence test
f3 <- approxfun(x, expected_sf, method = "linear", 0, 0)


tree_index <- 1

for (beta_index in 1:4){
    this_name <- paste0("tree", tree_index, "_beta", beta_index)
    fname <- paste0("output/", this_name, "_splits.csv")
    df <- read.table(fname, sep = ",", header = T)


    firstname <- paste0("output.", this_name, "_witherror_run_1.trees")
    secondname <- paste0("output.", this_name, "_witherror_run_2.trees")

    df$absdiff <- abs(df[[firstname]] - df[[secondname]])
    df$mean <- (df[[firstname]] + df[[secondname]]) / 2


    pass_criterion <- df$absdiff <= f3(df$mean) 
    df$pass_criterion <- ifelse(pass_criterion, "pass", "fail")


    p <- ggplot(df, aes(x = mean, y = absdiff)) +
        geom_point(aes(color = pass_criterion)) +
        theme_classic() +
        geom_ribbon(mapping = aes(y = NULL, x = x, ymin = ymin, ymax = expected_sf), data = expected_sf_df, alpha = 0.3)




    filename <- paste0("figures/tree", tree_index, "_beta", beta_index, "_splits.pdf")

    ggsave(filename, p, width = 300, height = 200, units = "mm")
}


