library(tidyverse)
library(stringr)

# 14.2 STRING BASICS
string1 <- "This is a string"
string2 <- 'If I want to include a "quote" inside a string, I use single quotes'

double_quote <- "\"" # or '"'
single_quote <- '\'' # or "'"

x <- c("\"", "\\")
x
writeLines(x)
?'"'
x <- "\u00b5"
x

# 12.2.1 String length
str_length(c("a", "R for data science", NA))
# str_

# 12.2.2 Combining strings
str_c("x", "y")
str_c("x", "y", "z")
str_c("x", "y", sep = ", ")
x <- c("abc", NA)
x
str_c("|-", x, "-|")
str_c("|-", str_replace_na(x), "-|")
str_c("prefix-", c("a", "b", "c"), "-suffix")
# Objects of length 0 are silently dropped. This is particularly useful in
# conjunction with if:
name <- "Hadley"
time_of_day <- "morning"
bithday <- F

str_c(
  "Good ", time_of_day, " ", name,
  if (bithday) " and HAPPY BIRTHDAY",
  "."
)
# To collapse a vector of strings into a single string, use collapse:
str_c(c("x", "y", "z"), collapse = ", ")
str_c(c("x", "y", "z"), sep = ", ")
str_c(c("x", "y", "z"))

# 14.2.3 Subsetting strings
x <- c("Apple", "Banana", "Pear")
str_sub(x, 1, 3)
# negative number count backwards from end
str_sub(x, -3, -1)
# Note that str_sub() won’t fail if the string is too short: it will just return
# as much as possible:
str_sub("a", 1, 5)
str_sub(x, 1, 1) <- str_to_lower(str_sub(x, 1, 1))
x
?str_sub

# 14.2.4 Locales
# Turkish has two i's: with and without a dot, and it
# has a different rule for capitalising them:
str_to_upper(c("i", "ı"))
str_to_upper(c("i", "ı"), locale = "tr")

x <- c("apple", "eggplant", "banana")
str_sort(x, locale = "en")  # English
str_sort(x, locale = "haw") # Hawaiian

# 12.2.5 Exercises
# 1
?paste
(nth <- paste0(1:12, c("st", "nd", "rd", rep("th", 9))))
paste(1:12, c("st", "nd", "rd", rep("th", 9)))
paste0(nth, collapse = ", ")
# 3
?str_length
str_length(x)
?str_sub
str_sub(x, str_length(x)/2, str_length(x)/2)
# 4
?str_wrap
thanks_path <- file.path(R.home("doc"), "THANKS")
thanks <- str_c(readLines(thanks_path), collapse = "\n")
thanks <- word(thanks, 1, 3, fixed("\n\n"))
thanks
cat(str_wrap(thanks), "\n")
str_wrap(thanks)
cat(str_wrap(thanks, width = 40), "\n")
# 5
?str_trim
str_trim("  String with trailing and leading white space\t")
str_trim("\n\nString with trailing and leading white space\n\n")
?str_pad
rbind(
  str_pad("hadley", 30, "left"),
  str_pad("hadley", 30, "right"),
  str_pad("hadley", 30, "both")
)
# 6
x <- c("a", "b", "c")
str_c(x, ", ")
str_c(x, collapse = ", ")
str_c("a", collapse = ", ")
str_c(c("a", "b"), collapse = ", ")
ex6 <- function(x) {
  l <- length(x)
  first_part <- str_c(x[-l], collapse = ", ")
  second_part <- str_c(c(first_part, x[l]), collapse =" and ")
  print(second_part)
}
ex6(x)
ex6(c("a"))
ex6(c("a", "b"))
ex6("")
ex6(c("a", "b", "c", "d", "e"))

# 14.3 MATHCING PATTERNS WITH REGULAR EXPRESSIONS ====
# 14.3.1 Basic matches
x <- c("apple", "banana", "pear")
str_view(x, "an")
str_view(x, ".a.")

# To create the regular expression, we need \\
dot <- "\\."
# But the expression itself only contains one:
writeLines(dot)
# And this tells R to look for an explicit .
str_view(c("abc", "a.c", "bef"), "a\\.c")
# If \ is used as an escape character in regular expressions, how do you match a
# literal \? Well you need to escape it, creating the regular expression \\. To
# create that regular expression, you need to use a string, which also needs to
# escape \. That means to match a literal \ you need to write "\\\\" — you need
# four backslashes to match one!
x <- "a\\b"
writeLines(x)
x
str_view(x, "\\\\")
# 14.3.1.1 Exercises
# 1
q <- c("something\\", "something\\else")
writeLines(q)
# y <- "\"
#writeLines(y)
""
#"
#y <- "\\"
#writeLines(y)
#str_view(q, y)
#y <- "\\\"
#"
str_view(q, "\\\\")

# 2
q <- c("something\"'\\somethingelse")
writeLines(q)
y <- "\"'\\\\"
writeLines(y)
str_view(q, y)
str_view(q, "\"'\\\\")

# 3
# exp <- "\..\..\.."
# exp <- "\\..\\..\\.."
# str_view(q, exp)
q2 <- "This is a string. This is another. This is a third...this is a fourth. This.i.s. a fifth"
# str_view(q2, exp)
# writeLines(exp)

# 14.3.2 Anchors
x <- c("apple", "banana", "pear")
str_view(x, "^a")
str_view(x, "a$")
# To force a regular expression to only match a complete string, anchor it with
# both ^ and $:
x <- c("apple pie", "apple", "apple cake")
str_view(x, "apple")
str_view(x, "^apple$")
# 14.3.2.1 Exercises
# 1
q <- "some text$^$some more"
q
writeLines(q)
str_view(q, "\\$\\^\\$")

# 2
stringr::words
str_view(words, "^y", match = T)
?str_view
str_view(words, "x$", match = T)
# 3
str_view(words, "^...$", match = T)
str_view(c("abc", "def", "fgh"), "[aeiou]")
# 4
str_view(words, "^.......", match = T)

# 14.3.3 Character classes and alternatives
# \d: matches any digit.
# \s: matches any whitespace (e.g. space, tab, newline).
# [abc]: matches a, b, or c.
# [^abc]: matches anything except a, b, or c.

# Remember, to create a regular expression containing \d or \s, you’ll need to
# escape the \ for the string, so you’ll type "\\d" or "\\s".
str_view(c("grey", "gray"), "gr(e|a)y")
# 14.3.3.1 Exercises
# 1
str_view(words, "^[aeiou]", match = T)
str_view(words, "^[^aeiou]+$", match = T)
q <- c("cat", "ball", "wlcv")
str_view(q, "^[^aeiou]+$")
str_view(words, "[^e]ed$", match = T)
str_view(words, "ing$|ise$", match = T)
# 2
str_view(words, "ie", match = T)
str_view(words, "ei", match = T)
# 3
str_view(words, "q.", match = T)
# 4
str_view(words, ".our|ise", match = T)
q <- c("07984-266064", "610-374-7637")
str_view(q, "^\\d\\d\\d\\d\\d-\\d+")

# 14.3.4 Repetition
# ?: 0 or 1
# +: 1 or more
# *: 0 or more
x <- "1888 is the longest year in Roman numerals: MDCCCLXXXVIII"
str_view(x, "CC?")
str_view(x, "CC+")
str_view(x, "C[LX]+")
# You can also specify the number of matches precisely:
# {n}: exactly n
# {n,}: n or more
# {,m}: at most m
# {n,m}: between n and m
str_view(x, "C{2}")
str_view(x, "C{2,}")
str_view(x, "C{2,3}")

# By default these matches are “greedy”: they will match the longest string
# possible. You can make them “lazy”, matching the shortest string possible by
# putting a ? after them. This is an advanced feature of regular expressions,
# but it’s useful to know that it exists:
str_view(x, "C{2,3}?")
str_view(x, "C[LX]+")
str_view(x, "C[LX]+?")
# 14.3.4.1 Exercises
# 1
# ? = {0,1}; + = {1,Inf}; * = {0,Inf}
str_view(x, "C[LX]{1,100}")
?regex
# 2
str_view(x, "^.*?")
two <- "\\{.+\\}"
writeLines(two)
q <- c("word", "Another{word}")
str_view(q, two)
q <- c("1234-12-12", "123-456-789")
str_view(q, "\\d{4}-\\d{2}-\\d{2}")
q <- c("\\\\2", "\\\\\\\\4")
str_view(q, "\\\\{4}")
q
writeLines(q)
# 3
str_view(words, "^[^aeiou]{3}", match = T)
str_view(words, "[aeiou]{3,}", match = T)
q <- c("aeiouandsomeothercrap", "aeShouldn'twork")
str_view(q, "[aeiou]{3,}")
str_view(words, "([aeiou][^aeiou]){2,}", match = T)
# 4
writeLines("(A|B|C)\1")
q <- c("ABEK", "AOSK", "OE", "AB", "AA")
str_view(q, "(AB|OE|SK)")
str_view(q, "(A|B|C)\1")

# 14.3.5
# Earlier, you learned about parentheses as a way to disambiguate complex
# expressions. They also define “groups” that you can refer to with
# backreferences, like \1, \2 etc. For example, the following regular expression
# finds all fruits that have a repeated pair of letters.
str_view(fruit, "(..)\\1", match = T)

# 14.3.5.1 Exercises
# 1
str_view(fruit, "(.)\1\1", match = T)
q <- c("apple", "saab", "aaaaa", "abba", "abab", "acada", "abcdecba")
str_view(q, "(.)\\1\\1")
str_view(q, "(.)(.)\\2\\1")
str_view(q, "(..)\\1")
str_view(q, "(.).\\1.\\1")
str_view(q, "(.)(.)(.).*\\3\\2\\1")
# 2
one <- "^(.).*\\1$"
q <- c("apple", "otto", "fortutuevv", "church", "eleven")
str_view(q, one)
two <- ".*(..).*\\1.*"
str_view(q, two)
three <- ".*(.).*\\1.*\\1.*"
str_view(q, three)

# 14.4 TOOLS ======================== 
# 14.4 TOOLS To determine if a character
# vector matches a pattern, use str_detect(). It returns a logical vector the
# same length as the input:
x <- c("apple", "banana", "pear")
str_detect(x, "e")
# How many common words start with t?
sum(str_detect(words, "^t"))
# What proportion of common words end with a vowel?
mean(str_detect(words, "[aeiou]$"))

#When you have complex logical conditions (e.g. match a or b but not c unless d)
#it’s often easier to combine multiple str_detect() calls with logical
#operators, rather than trying to create a single regular expression. For
#example, here are two ways to find all words that don’t contain any vowels:
# Find all words containing at least one vowel, and negate
no_vowels_1 <- !str_detect(words, "[aeiou]")
# Find all words consisting only of consonants (non-vowels)
no_vowels_2 <- str_detect(words, "^[^aeiou]+$")
identical(no_vowels_1, no_vowels_2)
# If your regular expression gets overly complicated, try breaking it up into
# smaller pieces, giving each piece a name, and then combining the pieces with
# logical operations.

# A common use of str_detect() is to select the elements that match a pattern.
# You can do this with logical subsetting, or the convenient str_subset()
# wrapper:
words[str_detect(words, "x$")]
str_subset(words, "x$")
# Typically, however, your strings will be one column of a data frame, and
# you’ll want to use filter instead:
df <- tibble(
  word = words,
  i = seq_along(word)
)
df
df %>% 
  filter(str_detect(words, "x$"))

x <- c("apple", "banana", "pear")
str_count(x, "a")
# On average, how many vowels per word?
mean(str_count(words, "[aeiou]"))

# It’s natural to use str_count() with mutate():
df %>% 
  mutate(
    vowels = str_count(word, "[aeiou]"),
    consonants = str_count(word, "[^aeiou]")
  )

# Note that matches never overlap. For example, in "abababa", how many times
# will the pattern "aba" match? Regular expressions say two, not three:
str_count("abababa", "aba")
str_view_all("abababa", "aba")
str_view("abababa", "aba")

# 14.4.2 Exercises 
# 1 For each of the following challenges, try solving it by
# using both a single regular expression, and a combination of multiple
# str_detect() calls.
# Find all words that start or end with x.
words[str_detect(words, "^x|x$")]
str_view(words, "^x", match = T)
q <- c("xa", "xx", "ax", "aa")
str_view(q, "^x|x$")
words[str_detect(words, "^x")|
        str_detect(words, "x$")]
# Find all words that start with a vowel and end with a consonant.
words[str_detect(words, "^[aeiou].*[^aeiou]$")]
words[str_detect(words, "^[aeiou]") &
        str_detect(words, "[^aeiou]$")]
# Are there any words that contain at least one of each different vowel?
words[str_detect(words, "a&e&i&o&u")]
q <- c("abb", "abe", "abebi", "abebibo", "abebibobu")
str_detect(q, "(?=.*a)(?=.*e)(?=.*i)(?=.*o)(?=.*u)")
words[
  str_detect(words, "a") &
    str_detect(words, "e") &
    str_detect(words, "i") &
    str_detect(words, "o") &
    str_detect(words, "u")
]
q[
  str_detect(q, "a") &
    str_detect(q, "e") &
    str_detect(q, "i") &
    str_detect(q, "o") &
    str_detect(q, "u")
]

# What word has the highest number of vowels? What word has the highest
# proportion of vowels? (Hint: what is the denominator?)
str_count(q, "[aeiou]")
str_count(words, "[aeiou]")
max(str_count(words, "[aeiou]"))
words[max(str_count(words, "[aeiou]"))]

str_length(words)
words[max(str_count(words, "[aeiou]")/str_length(words))]

# 14.4.3 Extract Matches
length(sentences)
head(sentences)
# Imagine we want to find all sentences that contain a colour. We first create a
# vector of colour names, and then turn it into a single regular expression:
colours <- c("red", "orange", "yellow", "green", "blue", "purple")
colour_match <- str_c(colours, collapse = "|")
colour_match
has_colour <- str_subset(sentences, colour_match)
matches <- str_extract(has_colour, colour_match)
matches

more <- sentences[str_count(sentences, colour_match) > 1]
str_view_all(more, colour_match)
str_extract(more, colour_match)
str_extract_all(more, colour_match)

# If you use simplify = TRUE, str_extract_all() will return a matrix with short
# matches expanded to the same length as the longest:
str_extract_all(more, colour_match, simplify = T)
x <- c("a", "ab", "abc")
str_extract_all(x, "[a -z]", simplify = T)

# 14.4.3.1 Exercises
# 1
colours <- c("red", "orange", "yellow", "green", "blue", "purple")
colours_fixed <- str_c("[^a-z]", colours)
colour_match_fixed <- str_c(colours_fixed, collapse = "|")
str_view_all(more, colour_match_fixed)

# 2
str_extract(sentences, "^[A-Z][a-z]* ")
str_extract_all(sentences, " [a-z]*ing ") #STUCK ON THIS ONE
sentences[644]

str_extract_all(sentences, " [a-z]+s( |\\.)")
sentences[689]

# 14.4.4 Grouped matches
noun <- "(a|the) ([^ ]+)"
has_noun <- sentences %>% 
  str_subset(noun) %>% 
  head(20)
has_noun %>% 
  str_extract(noun)
has_noun %>% 
  str_match(noun)
# If your data is in a tibble, it’s often easier to use tidyr::extract(). It
# works like str_match() but requires you to name the matches, which are then
# placed in new columns:
tibble(sentence = sentences) %>% 
  tidyr::extract(
    sentence, c("article", "noun"), "(a|the) ([^ ]+)", 
    remove = F
  )

# 14.4.4.1 Exercises
?tidyr::extract
numbers <- c(
  "one", 
  "two",
  "three", 
  "four",
  "five",
  "six",
  "seven",
  "eight",
  "nine",
  "ten"
)
numbers_or <- str_c(numbers, collapse = "|")
numbers_words <- str_c("(", numbers_or, ") ([^ ]+)")
has_numbers <- sentences %>% 
  str_subset(numbers_words) %>% 
  head(20)
has_numbers %>% 
  str_extract(numbers_words)
has_numbers %>% 
  str_match(numbers_words)
tibble(sentence = sentences) %>% 
  tidyr::extract(
    sentence, c("number", "noun"), regex = numbers_words,
    remove = F)

contractions <- "([^ ]+)'([^ ])"
str_view(sentences, contractions, match = T)
has_contractions <- sentences %>% 
  str_subset(contractions)
has_contractions %>% 
  str_extract(contractions)
has_contractions %>% 
  str_match(contractions)
?str_match
tibble(sentence = sentences) %>% 
  tidyr::extract(
    sentence, c("pre", "post"), contractions,
    remove = F
  )
?tidyr::extract

# 14.4.5 Replacing matches
x <- c("apple", "pear", "banana")
str_replace(x, "[aeiou]", "-")
str_replace_all(x, "[aeiou]", "-")
# With str_replace_all() you can perform multiple replacements by supplying a
# named vector:
x <- c("1 house", "2 cars", "3 people")
str_replace_all(x, c("1" = "one", "2" = "two", "3" = "three"))
# Instead of replacing with a fixed string you can use backreferences to insert
# components of the match. In the following code, I flip the order of the second
# and third words.
sentences %>% 
  str_replace("([^ ]+) ([^ ]+) ([^ ]+)", "\\1 \\3 \\2") %>% 
  head(5)
# 14.4.5.1 Exercises
# 1
q <- c("a/b", "this/that")
q
str_replace_all(q, "/", "\\")
writeLines(str_replace_all(q, "/", "\\"))
str_replace_all(q, "/", "\\\\")
writeLines(str_replace_all(q, "/", "\\\\"))
writeLines(q)
writeLines("a\b")

str_view(q, "/")
?str_rep
grep("/", q)
gsub("/", "\\\\", q)
# 2 #CAN'T GET THIS ONE!!!!
q <- c("ABab", "THIS IS A STRING")
str_replace_all(q, "[A-Z]", "x")
str_replace_all(q, "[A-Z]", "[a-z]")
writeLines(str_replace_all(q, "[A-Z]", letters))

caps <- str_c(LETTERS, collapse = "")
caps <- str_c("([", caps, "])")

lower <- str_c(letters, collapse = "")
lower <- str_c("[", lower, "]")
str_replace_all(q, caps, lower)
str_replace_all(q, caps, "-")

upper_comma <- str_c("c(", str_c(LETTERS, collapse = ", "), ")")
lower_comma <- str_c("c(", str_c(letters, collapse = ", "), ")")
str_replace_all(q, upper_comma, lower_comma)

upper_three <- str_c("[", str_c("(", LETTERS, ")", collapse = ""), "]", collapse = "")
lower_trhee <- str_c("[", str_c("(", letters, ")", collapse = ""), "]", collapse = "")
str_replace_all(q, upper_three, lower_trhee)

str_to_lower(q)
str_replace_all(q, "([A-Z])", str_to_lower("\\1"))
tolower(q)
# 3
str_replace_all(words, c("(^[^ ])(.*)([^ ]$)"), c("\\3\\2\\1"))
switched <- str_replace_all(words, "(^[^ ])(.*)([^ ]$)", "\\3\\2\\1")
switched
switched[switched %in% words]

# 14.4.6 Splitting
sentences %>% 
  head(5) %>% 
  str_split(" ")
# Because each component might contain a different number of pieces, this
# returns a list. If you’re working with a length-1 vector, the easiest thing is
# to just extract the first element of the list:
"a|b|c|d" %>% 
  str_split("\\|") %>% 
  .[[1]]
# Otherwise, like the other stringr functions that return a list, you can use
# simplify = TRUE to return a matrix:
sentences %>% 
  head(5) %>% 
  str_split(" ", simplify = T)
q
q %>% .[[1]]
# You can also request a maximum number of pieces:
fields <- c("Name: Hadley", "Country: NZ", "Age: 35")
fields %>% 
  str_split(": ", n = 2, simplify = T)
# Instead of splitting up strings by patterns, you can also split up by
# character, line, sentence and word boundary()s:
x <- "This is a sentence. This is another sentence."
str_view_all(x, boundary("word"))
str_split(x, " ")[[1]]
str_split(x, " ")
str_split(x, boundary("word"))[[1]]

# 14.4.6.1 Exercises
# 1
x <- "apples, pears, and bananas"
str_split(x, boundary("word"))
# 3
str_split(x, "")
?str_split

# 14.4.7 Find matches
str_locate(x, "a.")
str_locate_all(x, "a.")

# 14.5 OTHER TYPES OF PATTERNS ========== 
# When you use a pattern that’s a
# string, it’s automatically wrapped into a call to regex():
# The regular call:
str_view(fruit, "nana")
# Is shorthand for
str_view(fruit, regex("nana"))

# You can use the other arguments of regex() to control details of the match: 

# ignore_case = TRUE allows characters to match either their uppercase or
# lowercase forms. This always uses the current locale.
bananas <- c("banana", "Banana", "BANANA")
str_view(bananas, "banana")
str_view(bananas, regex("banana", ignore_case = T))

# multiline = TRUE allows ^ and $ to match the start and end of each line rather
# than the start and end of the complete string.
x <- "Line 1\nLine 2\nLine 3"
x
writeLines(x)
str_extract_all(x, "^Line")[[1]]
str_extract_all(x, regex("^Line", multiline = T))[[1]]

# comments = TRUE allows you to use comments and white space to make complex
# regular expressions more understandable. Spaces are ignored, as is everything
# after #. To match a literal space, you’ll need to escape it: "\\ ".
phone <- regex("
  \\(?     # optional opening parens
  (\\d{3}) # area code
  [)- ]?   # optional closing parens, dash, or space
  (\\d{3}) # another three numbers
  [ -]?    # optional space or dash
  (\\d{3}) # three more numbers
  ", comments = TRUE
)
phone
str_match("514-791-8141", phone)

# dotall = TRUE allows . to match everything, including \n.

# There are three other functions you can use instead of regex():

# fixed(): matches exactly the specified sequence of bytes. It ignores all
# special regular expressions and operates at a very low level. This allows you
# to avoid complex escaping and can be much faster than regular expressions. The
# following microbenchmark shows that it’s about 3x faster for a simple example.
library(microbenchmark)
microbenchmark::microbenchmark(
  fixed = str_detect(sentences, fixed("the")),
  regex = str_detect(sentences, "the"),
  times = 20
)
# Beware using fixed() with non-English data. It is problematic because there
# are often multiple ways of representing the same character. For example, there
# are two ways to define “á”: either as a single character or as an “a” plus an
# accent:
a1 <- "\u00e1"
a2 <- "a\u0301"
c(a1, a2)
a1 == a2

# doesn’t find a match. Instead, you can use coll(), defined next, to respect
# They render identically, but because they’re defined differently, fixed()
# human character comparison rules:
str_detect(a1, fixed(a2))
str_detect(a1, coll(a2))

# coll(): compare strings using standard collation rules. This is useful for
# doing case insensitive matching. Note that coll() takes a locale parameter
# that controls which rules are used for comparing characters. Unfortunately
# different parts of the world use different rules!

# That means you also need to be aware of the difference
# when doing case insensitive matches:
i <- c("I", "İ", "i", "ı")
i
str_subset(i, coll("i", ignore_case = T))
str_subset(i, coll("i", ignore_case = T, locale = "tr"))

# Both fixed() and regex() have ignore_case arguments, but they do not allow you
# to pick the locale: they always use the default locale. You can see what that
# is with the following code; more on stringi later.
stringi::stri_locale_info()

# The downside of coll() is speed; because the rules for recognising which
# characters are the same are complicated, coll() is relatively slow compared to
# regex() and fixed().

# As you saw with str_split() you can use boundary() to match boundaries. You
# can also use it with the other functions:
x <- "This is a sentence."
str_view_all(x, boundary("word"))
str_extract_all(x, boundary("word"))

# 14.5.1 Exercises
# 1
q <- c("This is \\a string.", "This is \\another")
q
writeLines(q)
str_view_all(q, regex("\\\\"))
str_view_all(q, fixed("\\"))

str_view(q, "is")
str_locate_all(q, "\\\\")
str_detect(q, "\\\\")
# 2
test <- sentences %>% 
  str_to_lower() %>% 
  str_extract_all(boundary("word")) %>% 
  unlist()  
test_tibble <- tibble(
  Word = test
)
test_tibble %>% 
  group_by(Word) %>% 
  count() %>% 
  arrange(desc(n)) %>% 
  print(n = 5)

# 14.6 OTHER USES OF REGULAR EXPRESSIONS ====
# There are two useful function in base R that also use regular expressions:

# apropos() searches all objects available from the global environment. This is
# useful if you can’t quite remember the name of the function.
apropos("replace")

# dir() lists all the files in a directory. The pattern argument takes a regular
# expression and only returns file names that match the pattern. For example,
# you can find all the R Markdown files in the current directory with:
head(dir(pattern = "\\.Rmd$"))

# 14.7 stringi ===== 
# stringr is built on top of the stringi package. stringr is
# useful when you’re learning because it exposes a minimal set of functions,
# which have been carefully picked to handle the most common string manipulation
# functions. stringi, on the other hand, is designed to be comprehensive. It
# contains almost every function you might ever need: stringi has 234 functions
# to stringr’s 42.

# If you find yourself struggling to do something in stringr, it’s worth taking
# a look at stringi. The packages work very similarly, so you should be able to
# translate your stringr knowledge in a natural way. The main difference is the
# prefix: str_ vs. stri_.

# 14.7.1 Exercises
# 1
library(stringi)
stri_count_words(sentences)
stri_duplicated_any(sentences)
stri_duplicated(sentences)
sentences
stri_duplicated(sentences[692])
q <- c("the", "world", "is", "the")
stri_duplicated(q)
stri_duplicated_any(q)
stri_rand_strings(10, 5)
# 2
?stri_sort()
