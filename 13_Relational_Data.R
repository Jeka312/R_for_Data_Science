library(tidyverse)
library(nycflights13)

# 13.2 nycflights13
airlines
airports
planes
weather

# 13.3 Keys
planes %>% 
  count(tailnum) %>% 
  filter(n > 1)
weather %>% 
  count(year, month, day, hour, origin) %>% 
  filter(n > 1)

flights %>% 
  count(year, month, day, flight) %>% 
  filter(n > 1)
flights %>% 
  count(year, month, day, tailnum) %>% 
  filter(n > 1)

# 13.3.1 Exercises
# 1
flights %>% 
  mutate(Observation = row_number()) %>% 
  print(n = 10, width = Inf)
# 2
library(Lahman)
Lahman::Batting
as_tibble(Lahman::Batting)
Batting %>% 
  count(playerID, yearID, stint, teamID) %>% 
  filter(n > 1)
library(babynames)
babynames
babynames %>% 
  count(year, sex, name) %>% 
  filter(nn > 1)
library(nasaweather)
atmos
?atmos
atmos %>% 
  count(lat, long, year, month) %>% 
  filter(n > 1)
atmos %>% 
  count(lat, long, year, month) %>% 
  print(n = 36)
library(fueleconomy)
vehicles
vehicles %>% 
  count(id) %>% 
  filter(n > 1)
diamonds
diamonds %>% 
  count(depth, x, y, z) %>% 
  filter(n > 1)
diamonds %>% 
  count(carat, cut, color, clarity, depth) %>% 
  filter(n > 1)
diamonds %>% 
  count(x:z) %>% 
  filter(n > 1)
diamonds %>% 
  select(x:z) %>% 
  count(z) %>% 
  filter(n > 1)

# 13.4 Mutating joins
flights2 <- flights %>% 
  select(year:day, hour, origin, dest, tailnum, carrier)
flights2
flights2 %>% 
  select(-origin, -dest) %>% 
  left_join(airlines, by = 'carrier')
# same as:
flights2 %>% 
  select(-origin, -dest) %>% 
  mutate(name = airlines$name[match(carrier, airlines$carrier)])

# 13.4.1 Understanding joins
x <- tribble(
  ~key, ~val_x, 
  1, "x1",
  2, "x2", 
  3, "x3"
)
y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2", 
  4, "y3"
)
# 13.4.2 Inner join
# An inner join matches pairs of observations whenever their keys are equal
x %>% 
  inner_join(y, by = "key")
# The most important property of an inner join is that unmatched rows are not included in the result. 

# 13.4.3 Outer joins
# An inner join keeps observations that appear in both tables. 
# An outer join keeps observations that appear in at least one of the tables. 
# There are three types of outer joins:
# A left join keeps all observations in x.
# A right join keeps all observations in y.
# A full join keeps all observations in x and y.

#13.4.4 Duplicate keys
# One table has duplicate keys
x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3", 
  1, "x4"
)
y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2"
)
left_join(x, y, by = 'key')
# Both tables have duplicate keys. This is usually an error because in neither
# table do the keys uniquely identify an observation. When you join duplicated
# keys, you get all possible combinations, the Cartesian product:
x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  3, "x4"
)
y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  2, "y3",
  3, "y4"
)
left_join(x, y, by = "key")

# 13.4.5 Defining the key columns You can use other values for by to connect the
# tables in other ways: The default, by = NULL, uses all variables that appear
# in both tables, the so called natural join. For example, the flights and
# weather tables match on their common variables: year, month, day, hour and
# origin.
flights2 %>% 
  left_join(weather)
# A character vector, by = "x". This is like a natural join, but uses only some
# of the common variables. For example, flights and planes have year variables,
# but they mean different things so we only want to join by tailnum.
flights2 %>% 
  left_join(planes, by = "tailnum")
# A named character vector: by = c("a" = "b"). This will match variable a in
# table x to variable b in table y. The variables from x will be used in the
# output.
airports
flights2 %>% 
  left_join(airports, c("dest" = "faa"))
flights2 %>% 
  left_join(airports, c("origin" = "faa"))

# 13.4.6 Exercises 
# 1. Compute the average delay by destination, then join on the
# airports data frame so you can show the spatial distribution of delays. Here’s
# an easy way to draw a map of the United States:
airports %>%
  semi_join(flights, c("faa" = "dest")) %>%
  ggplot(aes(lon, lat)) +
  borders("state") +
  geom_point() +
  coord_quickmap()
print(flights, width = Inf)
flights3 <- flights %>% 
  select(year:day, dep_delay, dest) %>% 
  filter(!is.na(dep_delay)) %>% 
  left_join(airports, c("dest" = "faa")) %>% 
  group_by(dest) %>% 
  summarise(Av_Delay = mean(dep_delay, na.rm = T))

airports %>% 
  semi_join(flights, c("faa" = "dest")) %>% 
  inner_join(flights3, c("faa" = "dest")) %>% 
  ggplot(aes(lon, lat)) +
  borders("state") +
  geom_point(aes(colour = Av_Delay)) +
  coord_quickmap()
flights3 %>% 
  filter(is.na(Av_Delay))
flights %>% 
  filter(dest == "LGA")
flights3 %>% 
  filter(dest == "LGA")
airports %>% 
  filter(faa == "LGA")

# Add the location of the origina and destination to flights
flights %>% 
  select(year:day, origin, dest) %>% 
  left_join(airports, c("origin" = "faa")) %>% 
  left_join(airports, c("dest" = "faa"))

# 3. Is there a relationship between the age of a plane and its delays
planes
planes %>% 
  select(tailnum, year) %>% 
  left_join(flights, by = "tailnum") %>% 
  select(tailnum, year.x, dep_delay) %>% 
  group_by(year.x) %>% 
  summarise(av_delay = mean(dep_delay, na.rm = T)) %>% 
  ggplot(aes(x = year.x, y = av_delay)) +
  geom_point() +
  stat_smooth()

# 4 What weather conditions make it more likely to see a delay?
weather
flights4 <- flights %>% 
  select(year:day, hour, origin, dep_delay) %>% 
  filter(!is.na(dep_delay))
weather2 <- 
  weather %>% 
  inner_join(flights4)
weather2
summary(weather2$visib)
range(weather2$visib)
range(weather2$dep_delay)
range(flights4$dep_delay)

weather %>% 
  inner_join(flights4) %>% 
  ggplot(aes(visib, dep_delay)) + 
  geom_point()
weather %>% 
  inner_join(flights4) %>% 
  ggplot(aes(visib, dep_delay)) + 
  stat_summary()
weather %>% 
  inner_join(flights4) %>% 
  filter(!is.na(visib)) %>% 
  ggplot(aes(visib, dep_delay)) + 
  stat_summary_bin(
    fun.y = median,
    # fun.ymax = max,
    # fun.ymin = min,
    geom = "line"
  )

weather3 <- weather %>% 
  filter(!is.na(wind_gust | !is.na(wind_speed))) 
with(weather3, cor(wind_gust, wind_speed))


cor(weather$wind_gust, weather$wind_speed, na.rm = T)
range(weather$wind_speed)
x <- rnorm(100)
mean_se(x, 3)
range(weather2$visib)
range(weather2$dep_delay)
table(is.na(weather2$dep_delay))
table(is.na(weather2$visib))
?stat_summary
?mean_se
?geom_pointrange
d <- ggplot(mtcars, aes(cyl, mpg)) + geom_point()
d + stat_summary(fun.data = "mean_cl_boot", colour = "red", size = 2)

d + stat_summary(fun.y = "median", colour = "red", size = 2, geom = "point")
d + stat_summary(fun.y = "mean", colour = "red", size = 2, geom = "point")
d + aes(colour = factor(vs)) + stat_summary(fun.y = mean, geom="line")

d + stat_summary(fun.y = mean, fun.ymin = min, fun.ymax = max,
                 colour = "red")

# What happened on June 13 2013? Display the spatial pattern of delays, and then
# use Google to cross-reference with the weather.
flights5 <- flights %>% 
  filter(year == 2013, month == 6, day == 13) %>% 
  select(year:day, dep_delay, dest) %>% 
  filter(!is.na(dep_delay)) %>% 
  left_join(airports, c("dest" = "faa")) %>% 
  group_by(dest) %>% 
  summarise(av_delay = mean(dep_delay, na.rm = T))
  
airports %>% 
  semi_join(flights, c("faa" = "dest")) %>% 
  inner_join(flights5, c("faa" = "dest")) %>% 
  ggplot(aes(lon, lat)) +
  borders("state") +
  geom_point(aes(size = av_delay)) +
  coord_quickmap()

# 13.5 Filting joins
top_dest <- flights %>% 
  count(dest, sort = T) %>% 
  head(10)
top_dest
flights %>% 
  semi_join(top_dest)
flights %>% 
  anti_join(planes, by = "tailnum") %>% 
  count(tailnum, sort = T)

# 13.5.1 Exercises
# 1
flights %>% 
  anti_join(planes, by = "tailnum") %>% 
  print(width = Inf)
flights %>% 
  anti_join(planes, by = "tailnum") %>% 
  select(carrier) %>% 
  count(carrier)
flights %>% 
  anti_join(planes, by = "tailnum") %>% 
  count(dest)
# 2
highflights <- flights %>% 
  count(tailnum, sort = T) %>% 
  filter(n >= 100)
flights %>% 
  semi_join(highflights, by = "tailnum")
# 3
fueleconomy::common
?common
fueleconomy::vehicles %>% 
  semi_join(common, by = "model")
fueleconomy::vehicles %>% 
  inner_join(common, by = "model")
# 4
worst_days <- flights %>% 
  group_by(year, month, day) %>% 
  summarise(av_delay = mean(dep_delay, na = T)) %>% 
  ungroup() %>% 
  mutate(period = c(0:364)) 

combined_delays[1] = NA
for (i in 2:nrow(worst_days)) {
  combined_delays[i] = sum(worst_days$av_delay[i], 
                        worst_days$av_delay[i-1])
}
worst_days$combined_delay <- combined_delays
arrange(worst_days, desc(combined_delay))
worst_days %>% 
  filter(combined_delay == max(combined_delay, na.rm = T)) %>% 
  left_join(weather)
# This isn't really right, but I'm getting bored. Should get it all
# to work with dplyr without the for loop

# 5
anti_join(flights, airports, by = c("dest" = "faa"))
# These are the destination airports in flights that are not in the airports table

anti_join(airports, flights, by = c("faa" = "dest"))
# These rae the airports in the airports table that do not appear in the flights data

# 6
flights %>% 
  select(tailnum, carrier) %>% 
  group_by(tailnum) %>% 
  summarise(Number_carriers = length(unique(carrier))) %>% 
  filter(Number_carriers > 1)
flights %>% 
  group_by(tailnum) %>% 
  filter(tailnum == "N146PQ")

# 13.6 Join problems
airports %>% count(alt, lon) %>% filter(n > 1)

# 13.7 Set operations
df1 <- tribble(
  ~x, ~y, 
  1, 1,
  2, 1
)
df2 <- tribble(
  ~x, ~y,
  1, 1, 
  1, 2
)
df1
df2
intersect(df1, df2)
union(df1, df2)
setdiff(df1, df2)
setdiff(df2, df1)
