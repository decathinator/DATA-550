here::i_am("code/03_models.R")

data <- readRDS(
  file = here::here("derived_data/data_clean.rds")
)

library(gtsummary)

mod <- glm(
  ab_resistance ~ shield_glycans + region + env_length,
  data = data
)

primary_regression_table <- 
  tbl_regression(mod) |>
    add_global_p()

binary_mod <- glm(
  I(ab_resistance > 1) ~ shield_glycans + region + env_length,
  data = data,
  family = binomial()
)

secondary_regression_table <- 
  tbl_regression(binary_mod, exponentiate = TRUE) |>
    add_global_p()

both_models <- list(
  primary = mod,
  secondary = binary_mod
)
saveRDS(
  both_models,
  file = here::here("tables/both_models.rds")
)

both_regression_tables <- list(
  primary = primary_regression_table,
  secondary = secondary_regression_table
)
saveRDS(
  both_regression_tables,
  file = here::here("tables/both_regression_tables.rds")
)

