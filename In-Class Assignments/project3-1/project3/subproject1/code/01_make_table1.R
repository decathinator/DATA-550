here::i_am(
#! TO DO: add appropriate location
)

data <- readRDS(
  file = #! TO DO: add appropriate file path to data_clean.rds
)

library(gtsummary)

table_one <- data |>
  select("region", "env_length", "ab_resistance", "number_glycans") |>
  tbl_summary(by = number_glycans) |>
  modify_spanning_header(c("stat_1", "stat_2") ~ "**PNGs in Glycan Shield**") |>
  add_overall() |>
  add_p()

saveRDS(
  table_one,
  file = #! TO DO: add appropriate file path to subproject1/output
)