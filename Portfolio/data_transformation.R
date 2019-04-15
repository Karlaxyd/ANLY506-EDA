#use of dplyr package, one of the core members of tidyverse
library(nycflights13)
library(tidyverse)
#To use masked base R functions:stats::filter()
#We'll use this data 
flights
#This is a tibble, slightly tweaked data frame.

#5 key functions:
#Pick observations by their values (filter()).
#Reorder the rows (arrange()).
#Pick variables by their names (select()).
#Create new variables with functions of existing variables (mutate()).
#Collapse many values down to a single summary (summarise()).
#Plus: group_by() which changes the scope of each function from operating on the entire dataset to operating on it group-by-group.

#An example for filter()
filter(flights, month == 1, day == 1)

#The above code does not change input data, if you want to save it:
jan1 <- filter(flights, month == 1, day == 1)
#Do both print and save: use parentheses
(dec25 <- filter(flights, month == 12, day == 25))

#Don't use = instead of == when compare
filter(flights, month = 1)

#computer can not store infinite number of digits, so be careful with floating point numbers, use near() instead of ==
sqrt(2) ^ 2 == 2
1 / 49 * 49 == 1
near(sqrt(2) ^ 2,  2)
near(1 / 49 * 49, 1)

#Logical operators: "and/&" by default. | is “or”, and ! is “not”
#xor means "exclusive or", x or y, but x&y part exclusive

#Example
filter(flights, month == 11 | month == 12)
#a wrong way- 11 |12 means TRUE, which returns 1 in computer
filter(flights, month == 11 | 12)
#another way to express
nov_dec <- filter(flights, month %in% c(11, 12))

#make use of logical relationships. These 2 codes are basically the same 
#!(x & y) is the same as !x | !y, and !(x | y) is the same as !x & !y
filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter(flights, arr_delay <= 120, dep_delay <= 120)

#Be careful! Any operation involving NA will result in NA
NA > 5

#to check if a value is missing 
is.na(x)

#filter() doesn't include NAs, so if you want to include them
df <- tibble(x = c(1, NA, 3))
filter(df, x > 1)

filter(df, is.na(x) | x > 1)


##5.2.4 Exercises ##

#arrange() is used to change the order of the rows
#The first argument is the data, the following arguments are order-by references.
flights
arrange(flights, year, month, day)
#use desc() to order by descending order
arrange(flights, desc(dep_delay))
#When sorting, arrange() put missing values at the end
df <- tibble(x = c(5, 2, NA))
arrange(df, x)
#Even if you use desc(), NAs are still at the end.
arrange(df, desc(x))

##5.3.1 Exercises

#select() is used to narrow down the variables that we're interested in 
select(flights, year, month, day)
#":" can be used in this function
select(flights, year:day)
#"-" means except that varialbes
select(flights, -(year:day))

#select() and rename()
#select drops all the variables that are not mentioned
#rename keep all of the variables
rename(flights, tail_num = tailnum)
select(flights, tail_num = tailnum)

#everything() can be used in this circumstance to keep other variables
select(flights, time_hour, air_time, everything())

#starts_with("abc")
#ends_with("xyz")
#contains("ijk")
#matches("(.)\\1") see more in the chapter of "strings"
#num_range("x", 1:3)



##5.4.1 Exercise

#mutate() is used to add new columns which are the functions of existing columns
flights_sml <- select(flights, 
                      year:day, 
                      ends_with("delay"), 
                      distance, 
                      air_time
)
mutate(flights_sml,
       gain = dep_delay - arr_delay,
       speed = distance / air_time * 60
)

#just created columns can be refered to in the same sentence
mutate(flights_sml,
       gain = dep_delay - arr_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours
)

#transmute() is used to keep only the new variables
transmute(flights,
          gain = dep_delay - arr_delay,
          hours = air_time / 60,
          gain_per_hour = gain / hours
)






















