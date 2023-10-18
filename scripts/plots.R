library(tibble)

fpaths <- Sys.glob("output/*.log")
summaries <- !grepl("_run", fpaths)
fpaths[summaries]

l <- list()
for (i in 1:4){
  l[[i]] <- tibble(read.table(paste0("output/tree", 1, "_beta", i, ".log"), header = TRUE))
}


y <- sapply(l, function(x) mean(x$tree_length))
x <- c(0.0, 0.05, 0.10, 0.15)
df <- tibble(x, y)

library(ggplot2)
p <- ggplot(df, aes(x = x, y = y)) + 
  geom_point() +
  geom_line() +
  theme_classic() +
  labs(x = "observation error (beta)", y = "tree length") +
  geom_hline(yintercept=4.6, color = "red") +
  ylim(c(0, 8))

ggsave("figures/inference_without_error_model.pdf", p, width = 100, height = 80, units = "mm")
