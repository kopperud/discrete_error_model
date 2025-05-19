library(ggplot2)
library(tibble)

tree_index <- 1

for (beta_index in 1:4){
    fname <- paste0("output/tree", tree_index, "_beta", beta_index, "_witherror.log")
    df <- read.table(fname, header = T)

    x <- seq(0.0, 1.0, length.out = 500)

    ## pdf of beta distribution
    y <- dbeta(x, 1, 50)

    df_prior <- tibble(
                       x = x,
                       y = y,
                       )


    p <- ggplot(df, aes(x = observation_error)) +
        #geom_histogram(aes(x = observation_error, y = ..density..), bins = 30)+
        geom_density(aes(x = observation_error, y = after_stat(density)), color = "gray", fill = "red", alpha = 0.3)+
        theme_classic() +
        geom_line(data = df_prior, aes(x = x, y = y), linewidth = 1.5) +
        xlim(c(0.0, 0.20)) +
        facet_grid(rows = vars(Replicate_ID))


    filename <- paste0("figures/tree", tree_index, "_beta", beta_index, "_observation_error.pdf")

    ggsave(filename, p, width = 300, height = 200, units = "mm")
}


