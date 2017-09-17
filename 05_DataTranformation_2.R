library(nycflights13)
library(tidyverse)



# 5.1.2 nycflights13 ------------------------------------------------------

flights

# 5.2 Filter rows with filter() -------------------------------------------

filter(flights, month == 1, day == 1)
jan1 <- filter(flights, month == 1, day == 1)

# 5.2.4 Exercises

#1
flights %>% 
  filter(arr_delay >= 120)
flights %>% 
  filter(dest %in% c("IAH", "HOU"))
flights %>% 
  filter(carrier %in% c("UA", "DL", "AA"))
flights %>% 
  filter(month %in% 7:9)
flights %>% 
  filter(arr_delay > 120 & dep_delay <= 0)
table(flights$dep_delay)
table(is.na(flights$dep_delay))
flights %>% 
  filter(dep_delay >= 60 & dep_delay - arr_delay > 30)
flights %>% 
  filter(dep_time <= 600 | dep_time == 2400)

#2
flights %>% 
  filter(month, between(month, 7, 9))
flights %>% 
  filter(between(dep_time, 0, 600))

#3
flights %>% 
  filter(is.na(dep_time))

# 5.3 Arrange rows with arrange() -----------------------------------------

arrange(flights, desc(arr_delay))

# 5.3.1 Exercises
#1
table(is.na(flights$dep_time))
arrange(flights, desc(is.na(arr_delay)), arr_delay)
#2
flights %>% 
  arrange(desc(dep_delay))
#3
flights %>% 
  arrange(air_time)
flights %>% 
  arrange(desc(distance))
flights %>% 
  arrange(distance)

# 5.4 Select columns with select() ----------------------------------------

rename(flights, tail_num = tailnum)
flights
select(flights, time_hour, air_time, everything())

# 5.4.1 Exercises
#1
flights %>% 
  select(dep_time, dep_delay, arr_time, arr_delay)
flights %>% 
  select(starts_with("dep"), starts_with("arr"))
#2
flights %>% 
  select(dep_time, dep_time)
#3
?one_of
vars <- c("year", "month", "day", "dep_delay", "arr_delay")
flights
flights %>% select(one_of(vars))
flights %>% select(vars)

# 5.5 Add new variables with mutate() -------------------------------------

flights_sml <- select(flights,
                      year:day,
                      ends_with("delay"),
                      distance,
                      air_time
                      )
flights_sml
mutate(flights_sml,
       gain = arr_delay - dep_delay,
       speed = distance / air_time * 60
       )
mutate(flights_sml,
       gain = arr_delay - dep_delay,
       hours = air_time / 60,
       gains_per_hour = gain / hours
       )
transmute(flights,
          gain = arr_delay - dep_delay,
          hours = air_time / 60,
          gains_per_hour = gain / hours)

# 5.5.1 Useful creation functions
transmute(flights,
          dep_time,
          hours = dep_time %/% 100,
          minute = dep_time %% 100)

x <- 1:10
x
lag(x)
lead(x)
?lead
x
cumsum(x)
cummean(x)
y <- c(1, 2, 2, NA, 3, 4)
y
min_rank(y)
min_rank(desc(y))
?min_rank
x <- c(5, 1, 3, 2, 2)
min_rank(x)
