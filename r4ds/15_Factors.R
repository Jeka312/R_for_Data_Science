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

# 15.3
gss_cat
?gss_cat
