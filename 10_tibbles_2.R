library(tidyverse)


# 10.5 Exercises ----------------------------------------------------------
# 1
is.tibble(mtcars)
is.data.frame(mtcars)

# 2
df <- data.frame(abc = 1, xyz = "a")
df
dft <- tibble(abc = 1,
              xyz = "a")
dft
df$x
dft$x #no partial matching with tibbles

df[, "xyz"]
dft[, "xyz"]
typeof(df[, "xyz"])
typeof(dft[, "xyz"])
typeof(dft)

df[, c("abc", "xyz")]
dft[, c("abc", "xyz")]

# 3
var <- "mpg"
df <- mtcars
df[[var]]
dft <- as.tibble(df)
dft[[var]]

# 4
annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)

annoying$`1`
ggplot(annoying, aes(x = `1`, y = `2`)) +
  geom_point()

annoying <- annoying %>% 
  mutate(`3` = `2` / `1`)

annoying <- annoying %>% 
  rename(one = `1`,
         two = `2`,
         three = `3`)
annoying
glimpse(annoying)

# 5
tibble::enframe(1:3)

# 6
?print.tbl_df
