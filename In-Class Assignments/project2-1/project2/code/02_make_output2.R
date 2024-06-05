#! TO DO:
#!   add call to here::i_am
here::i_am("code/02_make_output2.R")

#! TO DO: 
#!   read random_numbers1 from output1 directory
random_numbers1 <- readRDS(
  file = here::here("output1/random_numbers1.rds")
)

set.seed(2)
more_random_numbers <- rnorm(100)
random_numbers2 <- random_numbers1 + more_random_numbers

#! TO DO: 
#!   save random_numbers2 in output2 directory
saveRDS(
  random_numbers2,
  file = here::here("output2/random_numbers2.rds")
)