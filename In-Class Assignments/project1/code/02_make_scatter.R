here::i_am("code/02_make_scatter.R")

data <- readRDS(
  file = here::here("derived_data/data_clean.rds")
)

library(ggplot2)

scatterplot <- 
  ggplot(data, aes(x = shield_glycans, y = ab_resistance)) +
    geom_point() +
    geom_smooth(method = lm) +
    theme_bw()

ggsave(
  here::here("figures/scatterplot.png"),
  plot = scatterplot,
  device = "png"
)


