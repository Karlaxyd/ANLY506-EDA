library(tidyverse)
#look at the distribution of the data: use bar chart for catagorial vriables
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))
#or we can count it manually
diamonds %>% 
  count(cut)
#for continuous variables, use histogram
ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.5)
#or
diamonds %>% 
  count(cut_width(carat, 0.5))

#narrow the bin width to get more insight of zoomed part
smaller <- diamonds %>% 
  filter(carat < 3)

ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.1)

#if we need to see multiple histograms in the same plot, use lines instead to see more clear
ggplot(data = smaller, mapping = aes(x = carat, colour = cut)) +
  geom_freqpoly(binwidth = 0.1)

#focus on some typical values
#go on narrow down to see pattern
ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.01)

#look at unusual values 
ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5)
#zoom in
ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))

#deal with missing values
#drop the row that has strange values
diamonds2 <- diamonds %>% 
  filter(between(y, 3, 20))
#replace strange values with NA
diamonds2 <- diamonds %>% 
  mutate(y = ifelse(y < 3 | y > 20, NA, y))
#missing values can not be plotted, but they are in the warnings
ggplot(data = diamonds2, mapping = aes(x = x, y = y)) + 
  geom_point()
#use this code to avoid warnings- na.rm = TRUE
ggplot(data = diamonds2, mapping = aes(x = x, y = y)) + 
  geom_point(na.rm = TRUE)

#sometimes NA has it's meaning, and you want to see that in the plot, use is.na
nycflights13::flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  ggplot(mapping = aes(sched_dep_time)) + 
  geom_freqpoly(mapping = aes(colour = cancelled), binwidth = 1/4)

#I did not put much code in this chapter because most useful codes are distributed in other chapters.






