here::i_am("code/00_clean_data.R")
absolute_path_to_data <- here::here("raw_data", "vrc01_data.csv")
data <- read.csv(absolute_path_to_data, header = TRUE)

library(labelled)
library(gtsummary)

var_label(data) <- list(
  id = "ID",
  ab_resistance = "Antibody resistance",
  shield_glycans = "Shield glycans",
  region = "Region",
  env_length = "Length of Env protein"
)

data$number_glycans <- ifelse(data$shield_glycans < 4, "< 4", ">= 4")

saveRDS(
  data, 
  file = here::here("derived_data/data_clean.rds")
)
