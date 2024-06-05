#! TO DO:
#!   add call to here::i_am
here::i_am("code/04_render_report.R")

rmarkdown::render(
  here::here("report.Rmd"),
  knit_root_dir = here::here()
)