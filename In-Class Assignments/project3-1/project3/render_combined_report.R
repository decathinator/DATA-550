here::i_am(
  #! TO DO: add appropriate location
)

library(rmarkdown)

render(
  "combined_report.Rmd",
  knit_root_dir = here::here()
)