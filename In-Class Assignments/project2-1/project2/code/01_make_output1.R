#! TO DO:
#!   add call to here::i_am
here::i_am("code/01_make_output1.R")

set.seed(1)
random_numbers1 <- rnorm(100)

#! TO DO: 
#!   save random_numbers1 in output1 directory
saveRDS(
  random_numbers1,
  file = here::here("output1/random_numbers1.rds")
)