
#package we're going to use
install.packages("tidyverse")
library(tidyverse)

#data we're going to use
mpg
#create a scatter plot by ggplot
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))
#template for ggplot
ggplot(data = <DATA>) + 
  <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))
#to map a third aesthetic to a variable except x axis and y axis, through color
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))
#size aesthetic
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = class))
#alpha controls transparency
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))
#shape controls the shape
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))

#If you don't wnat a third mapping to a third variable, but still want to set a non-black color, just set it manually
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")
#This is a wrong example- don't put the "+" at the start of the next line
ggplot(data = mpg) 
+ geom_point(mapping = aes(x = displ, y = hwy))



#facet a data when ploting using facet_wrap(), nrow=2 means to display the facets in 2 rows. 
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)
#facet a data by 2 variables
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)


#uses of different geoms

#point
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))
#smooth line
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy))
#to set a third aesthetic inside smooth line-linetype
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

#we can use group argument for geom functions with single geometric objects,and it doesn't have legend
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))

#actually the group function is automatically done when you map an asthetic to a discrete variable
ggplot(data = mpg) +
  geom_smooth(
    mapping = aes(x = displ, y = hwy, color = drv),
    show.legend = FALSE
  )

# use of multiple geoms
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy))
#globle mapping in the ggplot sentence
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()
#apply different asthetics in differet layers, but keep global mapping
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth()
#we can also override the global data in spcific layer
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)

#create a bar chart.Many geoms like bar chart create new values to plot. In this example, it's "count", the y axis.
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut))
#The calcualtion is done by stat. Each this kind of geom has it's own defaul stat.
#They can be used interchangeably
ggplot(data = diamonds) + 
  stat_count(mapping = aes(x = cut))

#we can also change the defalt stat. In this example, "identity" means the raw y values.
demo <- tribble(
  ~cut,         ~freq,
  "Fair",       1610,
  "Good",       4906,
  "Very Good",  12082,
  "Premium",    13791,
  "Ideal",      21551
)

ggplot(data = demo) +
  geom_bar(mapping = aes(x = cut, y = freq), stat = "identity")

#or you can change this way
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))

#use of stat_summary
ggplot(data = diamonds) + 
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.ymin = min,
    fun.ymax = max,
    fun.y = median
  )

#use of "color" and "fill" 
#color controls the border color while fill controls the inside color 
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, colour = cut))
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut))

#fill can also be mapped to a variable
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity))




















