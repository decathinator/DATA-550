#! TO DO:
#!   add call to here::i_am
here::i_am("code/03_make_output3.R")

#! TO DO: 
#!   read random_numbers2 from output2 directory
random_numbers2 <- readRDS(
  file = here::here("output2/random_numbers2.rds")
)

set.seed(3)
more_random_numbers <- rnorm(100)
random_numbers3 <- random_numbers2 + more_random_numbers

#! TO DO: 
#!   save random_numbers3 in output3 directory
saveRDS(
  random_numbers3,
  file = here::here("output3/random_numbers3.rds")
)