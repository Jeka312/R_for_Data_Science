library(tidyverse)
library(forcats)

# 15.2 Creating factors ====
x1 <- c("Dec", "Apr", "Jan", "Mar")
x2 <- c("Dec", "Apr", "Jam", "Mar")
month_levels <- c(
  "Jan", "Feb", "Mar", "Apr", "May", "Jun", 
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
)
y1 <- factor(x1, levels = month_levels)
y1
sort(y1)
y2 <-  factor(x2, levels = month_levels)
y2
y2 <- parse_factor(x2, levels = month_levels)
factor(x1) #levels taken in alphabetical order

# Sometimes you’d prefer that the order of the levels match the order of the
# first appearance in the data. You can do that when creating the factor by
# setting levels to unique(x), or after the fact, with fct_inorder():
f1 <- factor(x1, levels = unique(x1))
f1
f2 <- x1 %>% factor() %>% fct_inorder()
f2
levels(f2)

# 15.3 General Social Survey ====
gss_cat
?gss_cat
gss_cat
gss_cat %>% 
  count(race)
ggplot(gss_cat, aes(race)) +
  geom_bar()
ggplot(gss_cat, aes(race)) +
  geom_bar() +
  scale_x_discrete(drop = FALSE)
levels(gss_cat$race)

# 15.3.1 Exercises
# 1
gss_cat %>% 
  count(rincome)
ggplot(gss_cat, aes(rincome)) +
  geom_bar() +
  coord_flip()
# The breaks are not even.

# 2
gss_cat %>% 
  count(relig)
gss_cat %>% 
  count(partyid)
ggplot(gss_cat, aes(partyid)) +
  geom_bar() +
  coord_flip()
# 3
q3 <- gss_cat %>% 
  select(relig, denom)
q3
ggplot(q3, aes(x = relig, y = denom)) +
  geom_point()
table(q3$relig, q3$denom)

# 15.4 Modifying factor order ====
relig <- gss_cat %>%
  group_by(relig) %>%
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )

relig
ggplot(relig, aes(tvhours, relig)) + geom_point()

# It is difficult to interpret this plot because there’s no overall pattern. We
# can improve it by reordering the levels of relig using fct_reorder().
# fct_reorder() takes three arguments:

# f, the factor whose levels you want to modify.
# x, a numeric vector that you want to use to reorder the levels.
# Optionally, fun, a function that’s used if there are multiple values of x for
# each value of f. The default value is median.

ggplot(relig, aes(tvhours, fct_reorder(relig, tvhours))) +
  geom_point()

# As you start making more complicated transformations, I’d recommend moving
# them out of aes() and into a separate mutate() step. For example, you could
# rewrite the plot above as:

relig %>%
  mutate(relig = fct_reorder(relig, tvhours)) %>%
  ggplot(aes(tvhours, relig)) +
  geom_point()
?fct_reorder

rincome <- gss_cat %>%
  group_by(rincome) %>%
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )

ggplot(rincome, aes(age, fct_reorder(rincome, age))) + geom_point()

# However, it does make sense to pull “Not applicable” to the front with the
# other special levels. You can use fct_relevel(). It takes a factor, f, and
# then any number of levels that you want to move to the front of the line.

ggplot(rincome, aes(age, fct_relevel(rincome, "Not applicable"))) +
  geom_point()

# Another type of reordering is useful when you are colouring the lines on a
# plot. fct_reorder2() reorders the factor by the y values associated with the
# largest x values. This makes the plot easier to read because the line colours
# line up with the legend.
by_age <- gss_cat %>%
  filter(!is.na(age)) %>%
  group_by(age, marital) %>%
  count() %>%
  mutate(prop = n / sum(n))

ggplot(by_age, aes(age, prop, colour = marital)) +
  geom_line(na.rm = TRUE)

ggplot(by_age, aes(age, prop, colour = fct_reorder2(marital, age, prop))) +
  geom_line() +
  labs(colour = "marital")

# Finally, for bar plots, you can use fct_infreq() to order levels in increasing
# frequency: this is the simplest type of reordering because it doesn’t need any
# extra variables. You may want to combine with fct_rev().

gss_cat %>%
  mutate(marital = marital %>% fct_infreq() %>% fct_rev()) %>%
  ggplot(aes(marital)) +
  geom_bar()
?fct_infreq
f <- factor(c("b", "b", "a", "c", "c", "c"))
f
fct_inorder(f)
fct_infreq(f)
?fct_rev
fct_rev(f)

# 15.4.1 Exercises
# 1
hist(gss_cat$tvhours)
hist(log(gss_cat$tvhours))
summary(gss_cat$tvhours)
# 2
levels(gss_cat$marital)
levels(gss_cat$race)
levels(gss_cat$rincome)

# 15.5 Modifying factor levels ====
gss_cat %>% count(partyid)
gss_cat %>%
  mutate(partyid = fct_recode(partyid,
                              "Republican, strong"    = "Strong republican",
                              "Republican, weak"      = "Not str republican",
                              "Independent, near rep" = "Ind,near rep",
                              "Independent, near dem" = "Ind,near dem",
                              "Democrat, weak"        = "Not str democrat",
                              "Democrat, strong"      = "Strong democrat"
  )) %>%
  count(partyid)

#To combine groups, you can assign multiple old levels to the same new level:
gss_cat %>%
  mutate(partyid = fct_recode(partyid,
                              "Republican, strong"    = "Strong republican",
                              "Republican, weak"      = "Not str republican",
                              "Independent, near rep" = "Ind,near rep",
                              "Independent, near dem" = "Ind,near dem",
                              "Democrat, weak"        = "Not str democrat",
                              "Democrat, strong"      = "Strong democrat",
                              "Other"                 = "No answer",
                              "Other"                 = "Don't know",
                              "Other"                 = "Other party"
  )) %>%
  count(partyid)
# If you want to collapse a lot of levels, fct_collapse() is a useful variant of
# fct_recode(). For each new variable, you can provide a vector of old levels:

gss_cat %>%
  mutate(partyid = fct_collapse(partyid,
                                other = c("No answer", "Don't know", "Other party"),
                                rep = c("Strong republican", "Not str republican"),
                                ind = c("Ind,near rep", "Independent", "Ind,near dem"),
                                dem = c("Not str democrat", "Strong democrat")
  )) %>%
  count(partyid)
# Sometimes you just want to lump together all the small groups to make a plot
# or table simpler. That’s the job of fct_lump():
gss_cat %>%
  mutate(relig = fct_lump(relig)) %>%
  count(relig)
levels(gss_cat$relig)

# The default behaviour is to progressively lump together the smallest groups,
# ensuring that the aggregate is still the smallest group. In this case it’s not
# very helpful: it is true that the majority of Americans in this survey are
# Protestant, but we’ve probably over collapsed.

# Instead, we can use the n parameter to specify how many groups (excluding
# other) we want to keep:
gss_cat %>%
  mutate(relig = fct_lump(relig, n = 10)) %>%
  count(relig, sort = TRUE) %>%
  print(n = Inf)

# 15.5.1 Exercises 
# 1 How have the proportions of people identifying as Democrat,
# Republican, and Independent changed over time?
gss_cat
gss_cat %>% 
  select(year, partyid) %>% 
  group_by(year) %>% 
  count(partyid) %>% 
  ggplot(aes(year, fill = partyid)) +
  geom_bar(position = 'dodge') 
  
levels(gss_cat$partyid)
q2 <- gss_cat %>%
  select(year, partyid) %>% 
  mutate(partyid = fct_collapse(partyid,
                                other = c("No answer", "Don't know", "Other party"),
                                rep = c("Strong republican", "Not str republican"),
                                ind = c("Ind,near rep", "Independent", "Ind,near dem"),
                                dem = c("Not str democrat", "Strong democrat")
  )) %>% 
  group_by(year) 
q2
ggplot(q2, aes(as.factor(year), fill = partyid)) +
  geom_bar(position = 'dodge')



# 2 How could you collapse rincome into a small set of categories?
levels(gss_cat$rincome)
gss_cat %>% select(rincome) %>% 
  mutate(income_group = fct_collapse(rincome,
                                     other = c("No answer", "Don't know", "Refused",
                                               "Not applicable")))
gss_cat %>% 
  select(rincome) %>% 
  mutate(income_group = fct_lump(rincome)) %>% 
  count(income_group)
  