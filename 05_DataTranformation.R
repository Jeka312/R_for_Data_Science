library(tidyverse)
library(nycflights13)
?flights
head(flights)
table(flights$carrier)

# 5.2 Filter
filter(flights, month == 1, day == 1)
df <- tibble(x = c(1, NA, 3))
df

# 5.2.4 Exercises
# 1
filter(flights, arr_delay >= 120)
filter(flights, dest == 'IAH' | dest == 'HOU')
filter(flights, carrier %in% c("UA", "AA", "DL"))
filter(flights, month %in% c(7,8,9))
filter(flights, arr_delay > 120 & dep_delay == 0)
filter(flights, dep_delay >= 60 & (dep_delay - arr_delay <=30))
filter(flights, dep_time <= 600)
# 2
?between
filter(flights, between(month, 7, 9))
table(is.na(flights$dep_time))
# 3
is.na(flights)
filter(flights, is.na(dep_time))
# 4
NA * 0

# 5.3.1 Exercises
# 1
arrange(flights, desc(is.na(dep_time)))
arrange(flights, desc(dep_time))
# 2
arrange(flights, desc(dep_delay))
arrange(flights, arr_time)
# 3
arrange(flights, air_time)
# 4
arrange(flights, distance)
arrange(flights, desc(distance))

# 5.4.1 Exercises
# 1
select(flights, c(dep_time, dep_delay, arr_time, arr_delay))
# 2
select(flights, arr_time, arr_time)
# 3
?one_of

# 5.5 Mutate
View(flights)
flights_sml <- select(flights,
                      year:day,
                      ends_with("delay"),
                      distance,
                      air_time)
flights_sml
mutate(flights_sml,
       gain = arr_delay - dep_delay,
       speed = distance / air_time * 60)
x <- 1:10
x
lag(x)
x != lag(x)
x - lag(x)
x
cumsum(x)
cummean(x)
y <- c(1, 2, 2, NA, 3, 4)
min_rank(y)
min_rank(c(1, 2, 2, 4, 5))
min_rank(c(1, 2, 2, 6, 5))

# 5.5.2 Exercises
flights_ex1 <- select(flights, ends_with('time'))
mutate(flights_ex1, 
          dep_hour = dep_time %/% 100,
          dep_min = dep_time %% 100)
mutate(flights_ex1,
       delta_time = arr_time - dep_time)
# 3
flights
# 4 Find the 10 most delayed flights using a ranking function. 
# How do you want to handle ties? Carefully read the documentation for min_rank().
arrange(flights, desc(min_rank(dep_delay)))
# 5
1:3 + 1:10
1:3 + 1:9

# 5.6 Summarise
summarise(flights, delay = mean(dep_delay, na.rm = T))
by_dest <- group_by(flights, dest)
delay <- summarise(by_dest,
                   count = n(),
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE)
)
delay <- filter(delay, count > 20, dest != "HNL")

# It looks like delays increase with distance up to ~750 miles 
# and then decrease. Maybe as flights get longer there's more 
# ability to make up delays in the air?
ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)
not_cancelled <- flights %>%
  filter(!is.na(dep_delay), !is.na(arr_delay))

# 5.6.3 Counts
delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay)
  )

ggplot(data = delays, mapping = aes(x = delay)) + 
  geom_freqpoly(binwidth = 10)

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )

ggplot(data = delays, mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)

delays %>% 
  filter(n > 25) %>% 
  ggplot(mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)
not_cancelled %>%
  count(tailnum)
not_cancelled %>%
  count(tailnum, wt = distance)

# 5.6.7 Exercises  
# 2 Come up with another approach that will give you the same
# output as not_cancelled %>% count(dest) and not_cancelled %>% count(tailnum,
# wt = distance) (without using count()).
not_cancelled %>%
  count(dest)
not_cancelled %>%
  group_by(dest) %>%
  summarise(n = n())

not_cancelled %>%
  count(tailnum, wt = distance)
not_cancelled %>%
  group_by(tailnum) %>%
  summarise(n = sum(distance))
# 4
flights %>%
  group_by(year, month, day) %>%
  filter(is.na(dep_time)) %>%
  summarise(n = n())
flights %>%
  group_by(year, month, day) %>%
  filter(is.na(dep_time)) %>%
  count(dep_time)
flights %>%
  group_by(year, month, day) %>%
  summarise(cancelled = sum(is.na(dep_time)),
            n = n(),
            mean_dep_delay = mean(dep_delay, na.rm = T),
            prop_cancelled = cancelled/n) %>% 
  ggplot(mapping = aes(x = prop_cancelled, y = mean_dep_delay)) +
  geom_point(alpha = 0.3)

# Which carrier has the worst delays
flights %>% 
  group_by(carrier) %>% 
  summarise(av_delays = mean(dep_delay, na.rm = T)) %>% 
  arrange(desc(av_delays))
flights %>% 
  group_by(carrier, dest) %>% 
  summarise(n())

# 6 For each plane, count the number of flights before the first delay of greater than 1 hour.
flights %>% 
  select(tailnum, dep_delay) %>% 
  filter(dep_delay > 0 & dep_delay <= 60) %>% 
  group_by(tailnum) %>% 
  count(sort = T)

# 5.7.1 Exercises
# 1
# 2
flights %>% 
  group_by(tailnum) %>% 
  mutate(prop_late = mean(dep_delay > 0, na.rm = T)) %>% 
  select(year:day, tailnum, prop_late) %>% 
  arrange(desc(prop_late))

# 3
flights %>% 
  group_by(dest) %>% 
  summarise(sum_delays = sum(dep_delay, na.rm = T)) %>% 
  arrange(desc(sum_delays))
