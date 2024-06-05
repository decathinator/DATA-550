here::i_am(
#! TO DO: add appropriate location
)

data <- readRDS(
  file = #! TO DO: add appropriate file path to data_clean.rds
)

library(ggplot2)

scatterplot <- 
  ggplot(data, aes(x = shield_glycans, y = ab_resistance)) +
    geom_point() +
    geom_smooth(method = lm) +
    theme_bw()

ggsave(
  #! TO DO: add appropriate file path to subproject1/output
  plot = scatterplot,
  device = "png"
)


