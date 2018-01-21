library(tidyverse)

df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10), 
  d = rnorm(10)
)

# 21.5 The map functions --------------------------------------------------

map_dbl(df, mean)
map_dbl(df, mean) %>% str()
str(df)
map(df, mean)
map(df, mean) %>% str()
