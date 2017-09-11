# 10 Tibbles

library(tidyverse)
# 10.2 Creating tibbles
as_tibble(iris)
tibble(
  x = 1:5, 
  y = 1, 
  z = x ^ 2 + y
)
tb <- tibble(
  `:)` = "smile", 
  ` ` = "space",
  `2000` = "number"
)
tb
tribble(
  ~x, ~y, ~z,
  #--|--|----
  "a", 2, 3.6,
  "b", 1, 8.5
)

# 10.3 Tibbles vs. data.frame
tibble(
  a = lubridate::now() + runif(1e3) * 86400,
  b = lubridate::today() + runif(1e3) * 30,
  c = 1:1e3,
  d = runif(1e3),
  e = sample(letters, 1e3, replace = TRUE)
)

nycflights13::flights %>% 
  print(n = 10, width = Inf)
nycflights13::flights %>% 
  View()

# 10.3.2 Subsetting
df <- tibble(
  x = runif(5),
  y = rnorm(5)
)
df
df$x
df[['x']]
df[[1]]
df[1]
df[1,1]
df[2,1]
df[[2, 1]]
typeof(df[[2,1]])
is.atomic(df[[2,1]])
is.list(df[[2,1]])

df %>% .$x
df %>% .[[1]]
is.list(df)
attributes(df)

# Exercises
# 1
is.tibble(mtcars)
is.data.frame(mtcars)

# 2
df <- data.frame(abc = 1, xyz = 'a')
df
tb <- as_tibble(df)
tb
tb2 <- tibble(
  abc = 1,
  xyz = 'a'
)
tb2
str(df)
df$x
tb2$x

df[,'xyz']
tb2[,'xyz']
is.atomic(df[, 'xyz'])
is.atomic(tb2[, 'xyz'])

df[, c('abc', 'xyz')]
typeof(df[, c('abc', 'xyz')])
tb2[, c('abc', 'xyz')]

# 3
tb <- as_tibble(mtcars)
tb
var <- 'mpg'
tb[[var]]
tb[var]
df <-  mtcars
df[var]
df[[var]]
attributes(tb)
attr(tb, "row.names")

# 4
annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)
annoying

annoying$`1`

ggplot(annoying) +
  geom_point(aes(x = `1`, y = `2`))

annoying2 <- cbind(annoying, `3` = annoying$`2`/annoying$`1`)
annoying2 # is now a dataframe
annoying3 <- add_column(annoying, `3` = annoying$`2`/annoying$`1`)
annoying3

names(annoying3) <- c('one', 'two', 'three')
annoying3
attributes(annoying3)
attributes(annoying2)

# 5
?enframe
enframe(1:3)
enframe(c(a = 5, b = 7))
enframe(c(a = 5, b = 7), name = 'one', value = 'two')
attributes(enframe(c(a = 5, b = 7), name = 'one', value = 'two'))

# 6
nycflights13::flights %>% 
  print(width = Inf)
nycflights13::flights
