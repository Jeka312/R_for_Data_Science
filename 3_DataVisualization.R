library(tidyverse)
ggplot2::mpg

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg)
dim(mtcars)
?mpg
ggplot(mpg) + geom_point(mapping = aes(x = hwy, y = cyl))
ggplot(mpg) + geom_point(mapping = aes(x = class, y = drv))
mpg
str(mpg)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, colour = displ < 5))
?geom_point

# 3.5 Facets
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 2)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ cyl)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, col = drv)) +
  facet_grid(. ~ cyl)

# 3.5.1 Exercises
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ displ)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)


# ======================
# 3.6 Geometric objects
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv, colour = drv)) +
  geom_point(mapping = aes(x = displ, y = hwy, colour = drv))

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth()

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)

# 3.6 Exercises
?geom_area
?geom_line
?geom_histogram

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point(show.legend = F) + 
  geom_smooth(se = FALSE)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

ggplot() + 
  geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy))

# Question 6
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth(se = F)
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth(se = F, mapping = aes(group = drv))
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, colour = drv)) +
  geom_point() + 
  geom_smooth(se = F)
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(colour = drv)) + 
  geom_smooth(se = F)
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(colour = drv)) + 
  geom_smooth(mapping = aes(linetype = drv), se = F)
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(fill = drv), shape = 21, size = 5, colour = 'white', stroke = 3) 
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(colour = 'white', size = 5) +
  geom_point(mapping = aes(colour = drv), size = 3) 

# 3.7 Statistical Transformations
?geom_bar
?stat_bin
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))
ggplot(data = diamonds) +
  stat_count(mapping = aes(x = cut))

# 3.7.1 Exercises
# 1
?stat_summary
ggplot(data = diamonds) + 
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.ymin = min,
    fun.ymax = max,
    fun.y = median
  )

ggplot(data = diamonds) + 
  geom_pointrange(mapping = aes(x = cut, y = depth),
                  stat = 'summary',
                  fun.ymin = min,
                  fun.ymax = max,
                  fun.y = median)
# 2
?geom_col
# 3
?geom_area #stat_identity
?stat_identity
?geom_line
# 4 
?stat_smooth
# 5
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = ..prop..))
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = color, y = ..prop..))
# http://stackoverflow.com/questions/39878813/r-ggplot-geom-bar-meaning-of-aesgroup-1

# 3.8 Positional adjustments
?position_dodge

# 3.8.1 Exercises
# 1
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_point()
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_point(position = 'jitter')
# 2
?geom_jitter
?geom_count
# 4
?geom_boxplot
ggplot(data = mpg, mapping = aes(x = as.factor(cyl), y = displ, fill = drv)) + 
  geom_boxplot()
mpg[mpg$cyl == 4,]

# 3.9 Coordinate systems
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot()
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot() +
  coord_flip()

nz <- map_data("nz")

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black")

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black") +
  coord_quickmap()
?map_data

bar <- ggplot(data = diamonds) + 
  geom_bar(
    mapping = aes(x = cut, fill = cut), 
    show.legend = FALSE,
    width = 1
  ) + 
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)

bar + coord_flip()
bar + coord_polar()

# 3.9.1 Exercises
# 1
?geom_bar
ggplot(data = diamonds, mapping = aes(x = cut, fill = cut)) +
  geom_bar()
ggplot(data = diamonds, mapping = aes(x = cut, fill = cut)) +
  geom_bar(width = 1) +
  coord_polar()
# 2
?labs()
# 3
?coord_quickmap

# 4
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() + 
  geom_abline() +
  coord_fixed()
?coord_fixed
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() + 
  geom_abline()
?geom_point

# 3.10 The layered grammar of graphics
# ggplot(data = <DATA>) + 
#   <GEOM_FUNCTION>(
#     mapping = aes(<MAPPINGS>),
#     stat = <STAT>, 
#     position = <POSITION>
#   ) +
#   <COORDINATE_FUNCTION> +
#   <FACET_FUNCTION>
  

