library(readr)
gapminder <- read_csv("Dropbox/HARRISBURG UNIVERSITY/ANLY506/gapminder.csv")
View(gapminder)

# Firstly, after viewing the data, my first question is
# how do life expectancy at birth, population and income level change over time for each region? Do they change in the same pattern?
# Because we can not just compare gross income over time, here I divide gross income by population to get per capita income. And I add it as a new column.

gapminder$pci1000 <- gapminder$income/gapminder$population*1000
gapminder
select(gapminder, region, Year, life, population, pci1000)
gapminder
# It is too complex to see changes for each country at the first, so I group the data by region to get an overview of each region.
by_region <- group_by(gapminder, region, Year)

gapminder_by_region <- summarise(by_region, life = mean(life, na.rm = TRUE), popupation = mean(population, na.rm = TRUE), pci1000 = mean(pci1000, na.rm = TRUE))

gapminder_by_region
# Then let's see the life expectancy at birth change over time for each region.
ggplot(data = gapminder_by_region) +
  geom_line(mapping = aes(x = Year, y = life, color = region), show.legend = FALSE) +
  facet_wrap(~region, nrow = 2)
# It seems that they tend to have the same decline trend in between 1900 ~ 1950. To see this trend more clearly, let's zoom in this period, and put them in the same plot to see if they overlap.

gapminder_by_region_zoom <- gapminder_by_region %>%
  filter(Year >1900 & Year <1950)

ggplot(data = gapminder_by_region_zoom) +
  geom_line(mapping = aes(x = Year, y = life, color = region), size = 0.5)
# Yes, from the plot we can see that, there was a big life expectancy decline before 1920 all over the world. And also there was a second decline before 1950, but America and Middle East & North Africa area did not experience this decline. 
# The two big decline was exactly at the time of world war I and world war II. Especially America was not in the second war, which provides a good evidence of the guess.
# So, there comes my assumption: did the world wars have the same effect on other variables of the data?
# For the polulation information, the data was colected every 10 years before 1950, so NAs in the columns means no data. I just simply remove NAs to draw histograms.
ggplot(data = gapminder_by_region, mapping = aes(x = Year, y = popupation, color = region)) +
  geom_col(na.rm = TRUE, show.legend = FALSE) +
  facet_wrap(~region, nrow = 2)

# The plots indicate that polulation is rising steadily for all the regions. Not sure if population was affected by the two world wars because the data was not colected every year during those two periods. We can not see any clue from what we have, though.
# Among the increase of regions, South Asia did have a rapid increase while Europe & Central Asia area only had a slightly increase.

#For per capita income, I still choose coxcomb chart to show change over time, becaue it's not allowed in this assignment to make the same plot for differnt vairables.
ggplot(data = gapminder_by_region, mapping = aes(x = Year, y = pci1000, color = region)) +
  geom_col(na.rm = TRUE, show.legend = FALSE) +
  facet_wrap(~region, nrow = 2) +
  coord_polar()
# Wow! This is a surprising result. Per capita income plots show totally different patterns of change from population and life expectancy. 
# PCI changes are affected multiple reasons, not only the world wars or populations.
# Now I've seen the trends in life, population, and income. Obviously they change in different patterns. 
# However, I still want to explore some potential relationship between the variables. 
# So my further question would be, do people with more income tend to have a longer life expectency?

gapminder_2015 <- gapminder[gapminder$Year==2015,]
by_region_2015 <- group_by(gapminder_2015, region, Year)
by_region_2015
ggplot(data = by_region_2015,mapping = aes(x = life , y = pci1000, color = region)) +
  geom_point(show.legend = FALSE) +
  facet_wrap(~region, nrow=2)

# From the plot above, we can see that higher points tend to distribute on the right side of the plots, which menas there is a tendency that people with more income have longer life expectency.
