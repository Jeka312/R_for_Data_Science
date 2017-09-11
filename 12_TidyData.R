library(tidyverse)

table1
table2
table3
table4a
table4b

# 12.2.1 Exercises
table2
table2 %>% 
  group_by(country, year) %>% 
  summarise(cases = sum(count[type == 'cases']),
            population = sum(count[type == 'population'])) %>% 
  mutate(rate = 1000*cases/population)

table4a
table4b
rate <- tibble(
  country = table4a$country,
  `1999` = 1000*table4a$`1999`/table4b$`1999`,
  `2000` = 1000*table4a$`2000`/table4b$`2000`
)
rate

table2
table2 %>% 
  filter(type == 'cases') %>% 
  ggplot(aes(year, count)) +
  geom_line(aes(group = country), colour = 'grey50') +
  geom_point(aes(colour = country))

ggplot(table2[table2$type == 'cases',], aes(year, count)) +
  geom_line(aes(group = country), colour = 'grey50') +
  geom_point(aes(colour = country))

# 12.3 Spreading and gathering
# 12.3.1 Gathering
table4a
table4a %>% 
  gather(`1999`, `2000`, key = 'year', value = 'cases')
# or:
gather(table4a, `1999`, `2000`, key = 'year', value = 'cases')

tidy4a <- table4a %>% 
  gather(`1999`, `2000`, key = "year", value = "cases")
tidy4b <- table4b %>% 
  gather(`1999`, `2000`, key = "year", value = "population")
left_join(tidy4a, tidy4b) # will learn about this later

# 12.3.2 Spreading
table2 # "An observation is a country in a year"
spread(table2, key = type, value = count)

# 12.3.3 Exercises
# 1
stocks <- tibble(
  year   = c(2015, 2015, 2016, 2016),
  half  = c(   1,    2,     1,    2),
  return = c(1.88, 0.59, 0.92, 0.17)
)
stocks
stocks %>% 
  spread(year, return) %>% 
  gather("year", "return", `2015`:`2016`)
stocks %>% 
  spread(year, return, convert = T) %>% 
  gather("year", "return", `2015`:`2016`, convert = T)

# 2
table4a %>% 
  gather(1999, 2000, key = "year", value = "cases")
table4a
table4a %>% 
  gather(`1999`, `2000`, key = "year", value = "cases")

# 3
people <- tribble(
  ~name,             ~key,    ~value,
  #-----------------|--------|------
  "Phillip Woods",   "age",       45,
  "Phillip Woods",   "height",   186,
  "Phillip Woods",   "age",       50,
  "Jessica Cordero", "age",       37,
  "Jessica Cordero", "height",   156
)
people
people %>% 
  spread(key = key, value = value)
people2 <- add_column(people,
                      measurement = c(1,1,2,1,1))
people2
people2 %>% 
  spread(key, value)

# 4
preg <- tribble(
  ~pregnant, ~male, ~female,
  "yes",     NA,    10,
  "no",      20,    12
)
preg
preg %>% 
  gather(male, female, key = 'gender', value = 'count')

# 12.4.1 Separate
table3 %>% 
  separate(rate, into = c("cases", "population"))
table3 %>% 
  separate(rate, into = c("cases", "population"), convert = T)
table3 %>% 
  separate(year, into = c("century", "year"), sep = 2)

# 12.4.2 Unite
table5
table5 %>% 
  unite(new, century, year)
table5 %>% 
  unite(new, century, year, sep = "")

# 12.4.3 Exercises
# 1
?separate
tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"))
tibble(x = c("a,b,c", "d,e,f,g", "h,i,j"))
tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"), extra = "merge")


tibble(x = c("a,b,c", "d,e", "f,g,i")) %>% 
  separate(x, c("one", "two", "three"))
tibble(x = c("a,b,c", "d,e", "f,g,i")) %>% 
  separate(x, c("one", "two", "three"), fill = "left")

# 2
tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"), extra = "merge")
tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"), 
           remove = F, extra = "merge")

# 12.5 Missing values
stocks <- tibble(
  year   = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr    = c(   1,    2,    3,    4,    2,    3,    4),
  return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)
stocks
stocks %>% 
  spread(year, return)
stocks %>% 
  spread(year, return) %>% 
  gather(year, return, `2015`:`2016`, na.rm = T)
stocks2 <- stocks %>% 
  spread(year, return)
stocks2
gather(stocks2, year, return, `2015`, `2016`, na.rm = T)

stocks %>% 
  complete(year, qtr)
?complete

treatment <- tribble(
  ~ person,           ~ treatment, ~response,
  "Derrick Whitmore", 1,           7,
  NA,                 2,           10,
  NA,                 3,           9,
  "Katherine Burke",  1,           4
)
treatment
treatment %>% 
  fill(person)

# 12.5.1 Exercises
df <- data_frame(
  group = c(1:2, 1),
  item_id = c(1:2, 2),
  item_name = c("a", "b", "b"),
  value1 = 1:3,
  value2 = 4:6
)
df
df %>% complete(group, nesting(item_id, item_name))
df %>% complete(group, nesting(item_id, item_name), fill = list(value1 = 0))

# 12.6
who
who1 <- who %>% 
  gather(new_sp_m014:newrel_f65, key = 'key', value = 'cases', na.rm = T)
who1
who1 %>% 
  count(key)
who2 <- who1 %>% 
  mutate(key = stringr::str_replace(key, "newrel", "new_rel"))
who2
who3 <- who2 %>% 
  separate(key, c("new", "type", "sexage"), sep = '_')
who3
who3 %>% 
  count(new)
who4 <- who3 %>% 
  select(-new, -iso2, -iso3)
who4
who5 <- who4 %>% 
  separate(sexage, c("sex", "age"), sep = 1)
who5

who %>%
  gather(code, value, new_sp_m014:newrel_f65, na.rm = TRUE) %>% 
  mutate(code = stringr::str_replace(code, "newrel", "new_rel")) %>%
  separate(code, c("new", "var", "sexage")) %>% 
  select(-new, -iso2, -iso3) %>% 
  separate(sexage, c("sex", "age"), sep = 1)

# 12.6.1 Exercises
# 1
who
# 2
who %>%
  gather(code, value, new_sp_m014:newrel_f65, na.rm = TRUE) %>% 
  separate(code, c("new", "var", "sexage")) %>% 
  select(-new, -iso2, -iso3) %>% 
  separate(sexage, c("sex", "age"), sep = 1)

# 3
who1 <- who %>% 
  unite(newcol, country, iso2, iso3, remove = F) %>% 
  count(newcol)
summary(who1$n)
table(who1$n)
who2 <- who %>% 
  unite(newcol, country, iso2, iso3, remove = F) %>% 
  count(country)
table(who2$n)
identical(who1$n, who2$n)
print(who1, n = Inf)

# 4
who
who1 <- who %>% 
  gather(code, value, new_sp_m014:newrel_f65, na.rm = T) %>% 
  mutate(code = stringr::str_replace(code, "newrel", "new_rel"))
who1  
who2 <- who1 %>% 
  separate(code, into = c("new", "var", "sexage"))
who2
who3 <- who2 %>% 
  separate(sexage, c("sex", "age"), sep = 1)
who3
who4 <- who3 %>% 
  select(-new, -iso2, -iso3)
who4
who5 <- who4 %>% 
  group_by(country, year, sex) %>% 
  summarise(total_cases = sum(value))
who5
#check your work:
who4 %>% 
  filter(country == "Afghanistan", 
         year == 1997,
         sex == "m")
unique(who5$country)
who5 %>% 
  filter(country == "Afghanistan") %>% 
  ggplot(aes(x = year, y = total_cases)) +
  geom_line(aes(group = sex)) +
  geom_point(aes(colour = sex))

