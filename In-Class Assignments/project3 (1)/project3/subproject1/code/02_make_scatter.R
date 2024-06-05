here::i_am(
#! TO DO: add appropriate location
  "subproject1/code/02_make_scatter.R"
)

data <- readRDS(
  file = #! TO DO: add appropriate file path to data_clean.rds
    "data/data_clean.rds"
)

library(ggplot2)

scatterplot <- 
  ggplot(data, aes(x = shield_glycans, y = ab_resistance)) +
    geom_point() +
    geom_smooth(method = lm) +
    theme_bw()

ggsave(
  #! TO DO: add appropriate file path to subproject1/output
  here::here("subproject1/output/scatter.png"),
  plot = scatterplot,
  device = "png"
)


