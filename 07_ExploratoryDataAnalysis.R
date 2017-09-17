library(tidyverse)
library(nycflights13)

# 7.3 Variation
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut))
diamonds %>% 
  count(cut)
ggplot(data = diamonds) + 
  geom_histogram(mapping = aes(x = carat), binwidth = 0.5)
diamonds %>% 
  count(cut_width(x = carat, 0.5))
ggplot(data = diamonds) +
  geom_freqpoly(mapping = aes(x = carat, colour = cut), binwidth = 0.1)
?geom_freqpoly

# 7.3.4 Exercises
# 1
ggplot(data = diamonds) + 
  geom_histogram(mapping = aes(x = z), binwidth = 0.5)
diamonds %>% 
  filter(x > 3) %>% 
  ggplot() +
  geom_histogram(mapping = aes(x = x), binwidth = 0.5)
diamonds %>% 
  filter(z < 2 | z > 10)  %>% 
  arrange(z)
# 2
ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = price), binwidth = 50)
diamonds %>% 
  filter(price < 2000) %>% 
  ggplot() +
  geom_histogram(mapping = aes(x = price), binwidth = 10)
# 3
range(diamonds$carat)
ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.5)
diamonds %>% 
  filter(carat > 0.9 & carat < 1.1) %>% 
  ggplot() +
  geom_histogram(mapping = aes(x = carat))
# 4
ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat))
ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat)) +
  coord_cartesian(ylim = c(0, 1000))
ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat)) + 
  ylim(0,1000)
ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.5)
ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.5) +
  coord_cartesian(xlim = c(0, 1.0))

# 7.4 Missing values
diamonds2 <- diamonds %>% 
  mutate(y = ifelse(y < 3 | y > 20, NA, y))
ggplot(data = flights) +
  geom_histogram(mapping = aes(x = dep_time))
table(is.na(flights$dep_time))
ggplot(data = flights) +
  geom_bar(mapping = aes(x = dep_time), na.rm = T)
sum(flights$dep_time)
?geom_histogram
?geom_bar

# 7.5 Covariance
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()
ggplot(data = mpg, mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy)) +
  geom_boxplot()
ggplot(data = mpg, mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy)) +
  geom_boxplot() +
  coord_flip()

# 7.5.1.1 Exercises
# 1
nycflights13::flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  ggplot(mapping = aes(sched_dep_time)) + 
  geom_freqpoly(mapping = aes(colour = cancelled), binwidth = 1/4)
nycflights13::flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  ggplot(mapping = aes(x = sched_dep_time, y = ..density..)) + 
  geom_freqpoly(mapping = aes(colour = cancelled), binwidth = 1)
# 2
names(diamonds)
ggplot(data = diamonds) +
  geom_point(mapping = aes(x = carat, y = price), alpha = 0.2)
ggplot(data = diamonds) +
  geom_boxplot(mapping = aes(x = color, y = price))
ggplot(data = diamonds) +
  geom_boxplot(mapping = aes(x = reorder(clarity, price, FUN = median), y = price))
ggplot(data = diamonds) +
  geom_point(mapping = aes(x = table, y = price), alpha = 0.1)
str(diamonds)
range(diamonds$table)
ggplot(data = diamonds) +
  geom_boxplot(mapping = aes(x = cut, y = carat))
# 3
library(ggstance)
??ggstance
ggplot(data = diamonds) +
  geom_boxplot(mapping = aes(x = color, y = price)) +
  coord_flip()
ggplot(data = diamonds) +
  geom_boxploth(mapping = aes(x = price, y = color))
# 4
# library(lvplot)
# ggplot(data = diamonds) +
#   geom_lv(mapping = aes(x = cut, y = price))

# 5
ggplot(data = diamonds) +
  geom_boxplot(mapping = aes(x = color, y = price))
ggplot(data = diamonds) +
  geom_violin(mapping = aes(x = color, y = price))
ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = price)) +
  facet_wrap(~color)
ggplot(data = diamonds) +
  geom_freqpoly(mapping = aes(x = price, y = ..density.., color = color), binwidth = 500)
# 6
library(ggbeeswarm)
R.Version()
?`ggbeeswarm-package`
ggplot(data = diamonds, mapping = aes(x = color, y = price)) +
  geom_point() +
  geom_jitter()
ggplot(data = diamonds, mapping = aes(x = color, y = price)) +
  geom_quasirandom()

# 7.5.2 Two categorical variables !!!!!This is awesome!!!!!!
ggplot(data = diamonds) +
  geom_count(mapping = aes(x = cut, y = color))
diamonds %>% 
  count(cut, color)
diamonds %>% 
  count(cut, color) %>% 
  ggplot(mapping = aes(x = color, y = cut)) +
  geom_tile(mapping = aes(fill = n)) 
?fill
# 7.5.2.1 Exercises
# 1
diamonds %>% 
  count(cut, color) %>% 
  ggplot(mapping = aes(x = color, y = cut)) +
  geom_tile(mapping = aes(fill = n)) +
  scale_fill_continuous(low = 'black', high = 'white')
# 2
flights %>% 
  group_by(month, dest) %>% 
  summarise(Av_delay = mean(dep_delay, na.rm = T)) %>% 
  ggplot(mapping = aes(x = month, y = dest)) +
  geom_point(mapping = aes(fill = Av_delay)) +
  geom_jitter()

flights %>% 
  group_by(month, dest) %>% 
  summarise(Av_delay = mean(dep_delay, na.rm = T)) %>% 
  ggplot() +
  geom_boxplot(mapping = aes(x = as.factor(month), y = Av_delay))
flights %>% 
  group_by(month, dest) %>% 
  summarise(Av_delay = mean(dep_delay, na.rm = T)) %>% 
  ggplot() +
  geom_line(mapping = aes(x = month, y = Av_delay))
flights %>% 
  group_by(month, dest) %>% 
  summarise(Av_delay = mean(dep_delay, na.rm = T)) %>% 
  filter(Av_delay > 20) %>% 
  ggplot() +
  geom_tile(mapping = aes(x = dest, y = month, fill = Av_delay))

# 7.5.3 Two Continuous variables
smaller <- diamonds %>% 
  filter(carat < 3)
ggplot(data = smaller) +
  geom_bin2d(mapping = aes(x = carat, y = price))
library(hexbin)
ggplot(data = smaller) +
  geom_hex(mapping = aes(x = carat, y = price))
ggplot(data = smaller, mapping = aes(x = carat, y = price)) +
  geom_boxplot(mapping = aes(group = cut_width(carat, 0.1)))
ggplot(data = smaller, mapping = aes(x = carat, y = price)) +
  geom_boxplot(mapping = aes(group = cut_number(carat, 20)))

# 7.5.3.1 Exercises
# 1
ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_freqpoly(mapping = aes(group = cut_width(carat, 0.1)))
# 2
ggplot(data = smaller, mapping = aes(x = price, y = carat)) +
  geom_boxplot(mapping = aes(group = cut_number(price, 20)))
# 4 STUCK HERE
# ggplot(data = smaller, mapping = aes(x = cut, y = price)) +
#   geom_boxplot() +
#   facet_wrap(group = cut_number(carat, 3), nrow = 1, ncol = 3)
ggplot(data = smaller, mapping = aes(x = price, group = cut_number(carat, 3))) +
  geom_freqpoly(mapping = aes(colour = cut)) +
  facet_wrap(~group)
ggplot(data = smaller, mapping = aes(x = price, y = ..density..)) +
  geom_freqpoly(mapping = aes(color = cut_number(carat, 3))) +
  facet_wrap(~ cut)
ggplot(data = smaller, mapping = aes(x = carat, y = price)) +
  geom_hex(mapping = aes(fill = cut))
ggplot(data = smaller, mapping = aes(x = carat, y = price)) +
  geom_point(mapping = aes(color = cut), alpha = 0.3)
ggplot(data = smaller, mapping = aes(x = carat, y = price)) +
  geom_point(alpha = 0.2) +
  facet_wrap(~ cut)

# 7.6 Patterns and models
ggplot(data = diamonds) +
  geom_point(mapping = aes(x = carat, y = price))
library(modelr)
mod <- lm(log(price) ~ log(carat), data = diamonds)

diamonds2 <- diamonds %>% 
  add_residuals(mod) %>% 
  mutate(resid = exp(resid))

ggplot(data = diamonds2) + 
  geom_point(mapping = aes(x = carat, y = resid))
ggplot(data = diamonds2) +
  geom_boxplot(mapping = aes(x = cut, y = resid))
