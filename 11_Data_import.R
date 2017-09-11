library(tidyverse)

# 11.2 Getting started
# read.csv()
# read_csv()

read_csv('a,b,c
         1,2,3
         4,5,6')
read_csv('1,2,3\n4,5,6', col_names = F)
read_csv('1,2,3\n4,5,6', col_names = c('x', 'y', 'z'))
read_csv('1,2,3\n4,5,.', na = '.')

# 11.2.2 Exercises
# 1
read_delim('a|b|c
           1|2|3', delim = '|')
# 4
read_delim("x,y\n1,'a,b'", delim = ",", quote = "\'")
# 5
read_csv("a,b\n1,2,3\n4,5,6")

read_csv("a,b,c\n1,2\n1,2,3,4")

read_csv("a,b\n\"1")

read_csv("a,b\n1,2\na,b")
read_csv("a;b\n1;3")

# 11.3 Parsing a vector
parse_integer(c("1", "231", ".", "456"), na = ".")
# x <- parse_integer(c("123", "345", "abc", "123.45"))
x
problems(x)

# 11.3.1 Numbers
parse_double("1.23")
parse_double("1,23", locale = locale(decimal_mark = ","))

parse_number("$100")
parse_number("20%")
parse_number("It cost $123.45")

# Used in America
parse_number("$123,456,789")

# Used in many parts of Europe
parse_number("123.456.789", locale = locale(grouping_mark = "."))

# Used in Switzerland
parse_number("123'456'789", locale = locale(grouping_mark = "'"))

# 11.3.2
charToRaw("Hadley")

x1 <- "El Ni\xf1o was particularly bad this year"
x2 <- "\x82\xb1\x82\xf1\x82\xc9\x82\xbf\x82\xcd"
parse_character(x1, locale = locale(encoding = "Latin1"))
parse_character(x2, locale = locale(encoding = "Shift-JIS"))

guess_encoding(charToRaw(x1))
guess_encoding(charToRaw(x2))

# 11.3.3 Factors
fruit <- c("apple", "banana")
parse_factor(c("apple", "banana", "bananana"), levels = fruit)

# 11.3.4 Dates, date-times and times
parse_datetime("2010-10-01T2010")
parse_datetime("20101010")
# https://en.wikipedia.org/wiki/ISO_8601

parse_date("2010-10-10")
library(hms)
parse_time("01:10 am")
parse_time("20:10:01")

parse_date("01/02/15", "%m/%d/%y")
parse_date("01/02/15", "%d/%m/%y")
parse_date("01/02/15", "%y/%m/%d")

parse_date("1 janvier 2015", "%d %B %Y", locale = locale("fr"))

# 11.3.5 Exercises
#1
?locale
#2
parse_number("1,234.56")
#parse_number("1,234.56", locale = locale(grouping_mark = ".", decimal_mark = "."))
parse_number("1,234.56", locale = locale(decimal_mark = ","))
parse_number("1.234,56", locale = locale(decimal_mark = ","))
# 3

# 7
d1 <- "January 1, 2010"
parse_date(d1, "%B %d, %Y")

d2 <- "2015-Mar-07"
parse_date(d2, "%Y-%b-%d")

d3 <- "06-Jun-2017"
parse_date(d3, "%d-%b-%Y")

d4 <- c("August 19 (2015)", "July 1 (2015)")
parse_date(d4, "%B %d (%Y)")

d5 <- "12/30/14" # Dec 30, 2014
parse_date(d5, "%m/%d/%y")

t1 <- "1705"
parse_time(t1, "%H%M")

t2 <- "11:15:10.12 PM"
parse_time(t2, "%H:%M:%OS %p")

# 11.4 Parsing a file
guess_parser("2010-10-01")
guess_parser("15:01")
guess_parser(c("TRUE", "FALSE"))
guess_parser(c("1", "5", "9"))
guess_parser(c("12,352,561"))
str(parse_guess("2010-10-10"))
parse_guess("2010-10-10")

challenge <- read_csv(readr_example("challenge.csv"))
challenge
problems(challenge)

challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols(
    x = col_integer(),
    y = col_character()
  )
)
challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols(
    x = col_double(),
    y = col_character()
  )
)
challenge
tail(challenge)
challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols(
    x = col_double(),
    y = col_date()
  )
)
challenge
tail(challenge)

# 11.4.3 Other strategies
challenge2 <- read_csv(readr_example("challenge.csv"), guess_max = 1001)
challenge2

challenge2 <- read_csv(readr_example("challenge.csv"), 
                       col_types = cols(.default = col_character())
)
challenge2
challenge3 <- type_convert(challenge2)
challenge3

# 11.5 Writing to files
challenge
write_csv(challenge, "challenge.csv")
write_csv(challenge, "challenge-2.csv")
read_csv("challenge-2.csv")
tail(challenge)

write_rds(challenge, "challenge.rds")
read_rds("challenge.rds")

library(feather)
write_feather(challenge, "challenge.feather")
read_feather("challenge.feather")