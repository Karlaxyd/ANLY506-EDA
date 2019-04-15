#We will use tidyverse to tidy up our data.
library(tidyverse)

#	There are three interrelated rules which make a dataset tidy:
#Each variable must have its own column.
#Each observation must have its own row.
#Each value must have its own cell.
#Examples in this session. They are underlying the same data, but in different formats. They're in contrast to a tidy data set-table1.
table1
table2
table3
table4a
table4b

#Now let's see how things are simple using a tidy data set- table1.
#To compute rate per 10,000 using table1 
table1 %>% 
  mutate(rate = cases / population * 10000)
#Compute cases per year using table1
table1 %>% 
count(year, wt = cases)

#Cases change over time
library(ggplot2)
ggplot(table1, aes(year, cases)) + 
  geom_line(aes(group = country), colour = "grey50") + 
  geom_point(aes(colour = country))


##12.2.1 Exercises

#1. Using prose, describe how the variables and observations are organised in each of the sample tables.

#table1: In table1, except for the "country" and "year" variable, the columns "cases" and "population" contain the values for those variables.
#table2:In table2, except for the "country" and "year" variable, the column "count" contains the values of variables "cases" and "population" in separate rows.
#table3: In table3, except for the "country" and "year" variable, the column "rate" provides the values of both "cases" and "population" in a string formatted like "cases / population".
#table4:Table 4 is split into two tables, one table for each variable.

#2. Compute the rate for table2, and table4a + table4b. You will need to perform four operations:
#Extract the number of TB cases per country per year.
#Extract the matching population per country per year.
#Divide cases by population, and multiply by 10000.
#Store back in the appropriate place.
#Which representation is easiest to work with? Which is hardest? Why?

#Basically, this is the same calculation as the above example, except that this time we're using non-tidy data sets.
#In table 2, case count information and population information are mixed in the table, so we need to separate them into 2 different tables, in order to calculate the rate.
library(tidyverse)
table2
t2_cases <- filter(table2, type == "cases") %>%
  rename(cases = count) %>%
  arrange(country, year)
t2_population <- filter(table2, type == "population") %>%
  rename(population = count) %>%
  arrange(country, year)


#Then we create a new column providing rate information, in a new table.
t2_cases_per_cap <- tibble(
  year = t2_cases$year,
  country = t2_cases$country,
  cases = t2_cases$cases,
  population = t2_population$population
) %>%
  mutate(cases_per_cap = (cases / population) * 10000) %>%
  select(country, year, cases_per_cap)

t2_cases_per_cap <- t2_cases_per_cap %>%
  mutate(type = "cases_per_cap") %>%
  rename(count = cases_per_cap)

#This is to combine the new column with the origian table2.
bind_rows(table2, t2_cases_per_cap) %>%
  arrange(country, year, type, count)

#Table4a provides cases count information while table4b provides population information. This part of code is to calculate the rate through tabel4a and table4b.
table4c <-
  tibble(
    country = table4a$country,
    `1999` = table4a[["1999"]] / table4b[["1999"]] * 10000,
    `2000` = table4a[["2000"]] / table4b[["2000"]] * 10000
  )
table4c

#Which represebtation is easiest to work with? Apparently, table4a + table4b uses less codes than the table2 process. In the table2 case, we need to deal with the table first and then do the calculation.
#However, table2 would be much more easier if the colum 'type' can split in 2 columns-'cases' and 'population'. Under that circumstance, we only need one function, the mutate(), to complete the calculation.

#3. Recreate the plot showing change in cases over time using table2 instead of table1. What do you need to do first?
#For table1, the cases column and population column are split, while in table2, they are mixed. So to calculate the cases trend over time, we need to split them first.
table2 %>%
  filter(type == "cases") %>%
  ggplot(aes(year, count)) +
  geom_line(aes(group = country), colour = "grey50") +
  geom_point(aes(colour = country)) +
  scale_x_continuous(breaks = unique(table2$year)) +
  ylab("cases")


#Common problem1: columns are headed with other variable values, instead the name of its own.
table4a
#Use gather() to solve this problem.
#The first arguments are the wrong headers, the second argument is the name for that header values, and the third argument is the real name for the column values.
#gather() usese select() tyle notation
table4a %>% 
  gather(`1999`, `2000`, key = "year", value = "cases")
#Here, 1999 and 2000 are surrounded by backticks`, that's because column names must start with letters (syntactic). So we 

#Combine talbe4a and table4b into a sigle tibble.
tidy4a <- table4a %>% 
  gather(`1999`, `2000`, key = "year", value = "cases")
tidy4b <- table4b %>% 
  gather(`1999`, `2000`, key = "year", value = "population")
left_join(tidy4a, tidy4b)

#problem2: An observation is scattered across multiple rows.
table2
#Use spread() to solve this problem. 
#The first argument is key(the column that contains variable names), the second is the value.
table2 %>%
  spread(key = type, value = count)

##12.3.3 Exercises
#1. Why are gather() and spread() not perfectly symmetrical?
#Carefully consider the following example:
  stocks <- tibble(
    year   = c(2015, 2015, 2016, 2016),
    half  = c(   1,    2,     1,    2),
    return = c(1.88, 0.59, 0.92, 0.17)
  )
stocks %>% 
  spread(year, return) %>% 
  gather("year", "return", `2015`:`2016`)
#The reason that gather() and spread() are not perfectly symmetrical is because, after spread(), the year column turned into column names, which are characters. 
#Both spread() and gather() have a convert argument. What does it do?
#It is used to guess the data type of the key. 

#2. Why does this code fail?
table4a %>% 
  gather(1999, 2000, key = "year", value = "cases")
#> Error in inds_combine(.vars, ind_list): Position must be between 0 and n
#This code fails because 1999 and 2000 are non-syntactic names, R tries to read the 1999th and 2000th column. 
#The right way is either surround the number with backtick``, or provide them as strings "".

#3. Why does spreading this tibble fail? How could you add a new column to fix the problem?
people <- tribble(
  ~name,             ~key,    ~value,
  #-----------------|--------|------
  "Phillip Woods",   "age",       45,
  "Phillip Woods",   "height",   186,
  "Phillip Woods",   "age",       50,
  "Jessica Cordero", "age",       37,
  "Jessica Cordero", "height",   156
)
glimpse(people)
print(people)
spread(people, key, value)
#Error: Duplicate identifiers for rows (1, 3)
#The spread fails because row1 and row3 has duplicated identifiers. It might because these 2 people have the same name. W
#Add another column to specify different person with the same name. 
people %>%
  mutate(unique_id = c(1, 2, 2, 3, 3)) %>%
  select(unique_id, everything()) %>%
  spread(key, value)

#4. Tidy the simple tibble below. Do you need to spread or gather it? What are the variables?
preg <- tribble(
  ~pregnant, ~male, ~female,
  "yes",     NA,    10,
  "no",      20,    12
)
#This tibble needs to be gathered.
preg %>%
  gather(male, female, key = gender, value = count)
#Variables are pregment, gender and count.
#There's an NA value in the row of pregnant male. Since male can not be pregnent, I would simply remove this row to tidy up the data.
preg_tidy2 <- preg %>%
  gather(male, female, key = "sex", value = "count", na.rm = TRUE)
preg_tidy2
#A little step forward, turn the two-value variables into logical vectors.
preg_tidy3 <- preg_tidy2 %>%
  mutate(
    female = sex == "female",
    pregnant = pregnant == "yes"
  ) %>%
  select(female, pregnant, count)
preg_tidy3
#It saves memory and is easier to use.
filter(preg_tidy2, sex == "female", pregnant == "no")
filter(preg_tidy3, female, !pregnant)

#Problem 3: one column contains two or more variables.
table3
#Use separate() to solve this problem
table3 %>% 
  separate(rate, into = c("cases", "population"))
#By default, separate() will split values wherever it sees a non-alphanumeric character. However, if you want, you can specify the separater:
table3 %>% 
  separate(rate, into = c("cases", "population"), sep = "/")
#Use conver() to guess the data type
table3 %>% 
  separate(rate, into = c("cases", "population"), convert = TRUE)
#Use positions to split a column: pass a vector of integers to the sep argument.
#Positive number starts at the far-left, negtive number is the opposite.
table3 %>% 
  separate(year, into = c("century", "year"), sep = 2)

#Problem 4: when you want to combine multiple columns into one column(seldom used)
#Use the above separated data as an example
table5 %>% 
  unite(new, century, year)
#The combined values are separated by underscores. To avoid this defalt format, use sep argument
table5 %>% 
  unite(new, century, year, sep = "")

##12.4.3 Exercises
#1. What do the extra and fill arguments do in separate()? Experiment with the various options for the following two toy datasets.
tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"))


#The extra argument tells separate() what to do when there are unnormal more values than expected.
#It will automatically drop the redundant value, but to avoid the warning message, simply set it to "drop"
tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>%
  separate(x, c("one", "two", "three"), extra = "drop")
#If you don't want the value to be dropped, use "merge" to keep it. It'll appear together with it's neighbor.
tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>%
  separate(x, c("one", "two", "three"), extra = "merge")
#The fill argument tells separate() what to do when there are fewer values than expected.
#Similarly, separate() automatically fill it with NA, and with a warning message
tibble(x = c("a,b,c", "d,e", "f,g,i")) %>% 
  separate(x, c("one", "two", "three"))
#Use NA to fill the right side, without warning
tibble(x = c("a,b,c", "d,e", "f,g,i")) %>%
  separate(x, c("one", "two", "three"), fill = "right")
#Use NA to fill the left side, without warning
tibble(x = c("a,b,c", "d,e", "f,g,i")) %>%
  separate(x, c("one", "two", "three"), fill = "left")
#2. Both unite() and separate() have a remove argument. What does it do? Why would you set it to FALSE?
#remove is used to discard the input columns. It is TRUE by default. I would set it as FALSE if I want to keep the original columns.

#3. Compare and contrast separate() and extract(). Why are there three variations of separation (by position, by separator, and with groups), but only one unite?
#Both separate() and extract() are used to split one column.
#Example using separate() with separater
tibble(x = c("X_1", "X_2", "AA_1", "AA_2")) %>%
  separate(x, c("variable", "into"), sep = "_")
#Example using separate() with position
tibble(x = c("X1", "X2", "Y1", "Y2")) %>%
  separate(x, c("variable", "into"), sep = c(1))
#Example using extract() with separater
tibble(x = c("X_1", "X_2", "AA_1", "AA_2")) %>%
  extract(x, c("variable", "id"), regex = "([A-Z])_([0-9])")
#Example using extract() with position
tibble(x = c("X1", "X2", "Y1", "Y2")) %>%
  extract(x, c("variable", "id"), regex = "([A-Z])([0-9])")
#This example shows that extract can do more complecated separations which separate() can not.
tibble(x = c("X1", "X20", "AA11", "AA2")) %>%
  extract(x, c("variable", "id"), regex = "([A-Z]+)([0-9]+)")

#An example using extract() with group
df_extract <- data.frame(x = c(NA, "ap.b", "aa/d", "b.c", "d-ee"))
df_extract %>% extract(x, c("new", "old"), regex = "(.*)[:punct:](.*)")

#Meanwhile, unite() is used to combine colums. There's not much to talk except how do you want to combine them(what separater or no separater?)
tibble(variable = c("X", "X", "Y", "Y"), id = c(1, 2, 1, 2)) %>%
  unite(x, variable, id, sep = "_")

#Missing values can be explicit or implicit.
#Explicit means NA. Implicit means not present.
stocks <- tibble(
  year   = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr    = c(   1,    2,    3,    4,    2,    3,    4),
  return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)
#Make implicit missing values explicit
stocks %>% 
  spread(year, return)
#Make explicit values implicit
stocks %>% 
  spread(year, return) %>% 
  gather(year, return, `2015`:`2016`, na.rm = TRUE)
#Use complete() to make missing value explicit, again. It contains every unique combination.
stocks %>% 
  complete(year, qtr)


#When the table is especially used for data entry, missing values may indicate that the previous value should be carried forward.

treatment <- tribble(
  ~ person,           ~ treatment, ~response,
  "Derrick Whitmore", 1,           7,
  NA,                 2,           10,
  NA,                 3,           9,
  "Katherine Burke",  1,           4
)
#Use fill() to fulfill this action. The NAs will take the most recent non-missing values.
treatment %>% 
  fill(person)

##12.5.1 Exercise
#1. Compare and contrast the fill arguments to spread() and complete().
#fill in complete():A named list that for each variable supplies a single value to use instead of NA for missing combinations.
#fill in spread(): If set, missing values will be replaced with this value. Note that there are two types of missingness in the input: explicit missing values (i.e. NA), and implicit missings, rows that simply aren't present. Both types of missing value will be replaced by fill.

#2. What does the direction argument to fill() do?
#It decides the direction that the replacing value take, whether up or down.
#See this example.
treatment <- tribble(
  ~ person,           ~ treatment, ~response,
  "Derrick Whitmore", 1,           7,
  NA,                 2,           10,
  NA,                 3,           9,
  "Katherine Burke",  1,           4
)
fill(treatment, person, .direction = "up")
fill(treatment, person, .direction = "down")


##Case study
who
#gather the columns as "key" column, and set the values as "cases". Remove NA valuse to focus on the values that are present.
who1 <- who %>% 
  gather(new_sp_m014:newrel_f65, key = "key", value = "cases", na.rm = TRUE)
who1
#count the key column to get more insight of the column
who1 %>% 
  count(key)
#
who2 <- who1 %>% 
  mutate(key = stringr::str_replace(key, "newrel", "new_rel"))
who2
#split the key column by underscore
who3 <- who2 %>% 
  separate(key, c("new", "type", "sexage"), sep = "_")
who3
#It seems that the new column is redundant because all of the observations are new. Use count() to confirm this
who3 %>% 
  count(new)
#After the confirmation, we can safely remove redundant columns. The column iso2 and iso3 provide the sanme information as column country.
who4 <- who3 %>% 
  select(-new, -iso2, -iso3)
who4
#split sex and age by position
who5 <- who4 %>% 
  separate(sexage, c("sex", "age"), sep = 1)
who5
#The complex pipe version of all above actions
who %>%
  gather(key, value, new_sp_m014:newrel_f65, na.rm = TRUE) %>% 
  mutate(key = stringr::str_replace(key, "newrel", "new_rel")) %>%
  separate(key, c("new", "var", "sexage")) %>% 
  select(-new, -iso2, -iso3) %>% 
  separate(sexage, c("sex", "age"), sep = 1)

##Exercise 12.6.1
#1. In this case study I set na.rm = TRUE just to make it easier to check that we had the correct values. Is this reasonable? Think about how missing values are represented in this dataset. Are there implicit missing values? What’s the difference between an NA and zero?
#For our purpose, it's reasonable to use na.rm = TRUE. In other cases, it depends.
#Is there any 0 values is the table? If yes, that means NAs are used for no cases. If no, then NAs may mean 0 cases.
#If there are both explicit and implicit missing values, explicit NA would mean 0 cases and implicit missing valus would mena no cases.
#Next, let's do the above analysis.
#First, check to see if there are 0 values in the data.
who1 %>%
  filter(cases == 0) %>%
  nrow()
#There are 11080 zeros in the data. This indicate that 0 values are explicit. Then NAs mean missing data.
#Secound, check for explicit missing values 
gather(who, new_sp_m014:newrel_f65, key = "key", value = "cases") %>%
  group_by(country, year) %>%
  mutate(prop_missing = sum(is.na(cases)) / n()) %>%
  filter(prop_missing > 0, prop_missing < 1)
#check for implicit missing valaues: country-year combinations that do not appear inthe data
nrow(who)
who %>% 
  complete(country, year) %>%
  nrow()
#Therefore, there are both explicit and implicit missing vavlues.
#use anti_join to make better sense of the years
anti_join(complete(who, country, year), who, by = c("country", "year")) %>% 
  select(country, year) %>% 
  group_by(country) %>% 
  summarise(min_year = min(year), max_year = max(year))

#The missing combinaitons are for the years prior to the existence of the countries.
#To summarize:
#`0` is used to represent no cases of TB.
#Explicit missing values (`NA`s) are used to represent missing data for (`country`, `year`) combinations in which the country existed in that year.
#Implicit missing values are used to represent missing data because a country did not exist in that year.

#2. What happens if you neglect the mutate() step? (mutate(key = stringr::str_replace(key, "newrel", "new_rel")))
#There will be a warning message- too few values.
who3a <- who1 %>%
  separate(key, c("new", "type", "sexage"), sep = "_")
filter(who3a, new == "newrel") %>% head()
#3. I claimed that iso2 and iso3 were redundant with country. Confirm this claim.
#This is the answer from others, need to figure out how it works
#If `iso2` and `iso3` are redundant with `country`, then, within each country, 
#there should only be one distinct combination of `iso2` and `iso3` values, which is the case.
select(who3, country, iso2, iso3) %>%
  distinct() %>%
  group_by(country) %>%
  filter(n() > 1)
#This makes sense, since `iso2` and `iso3` contain the 2- and 3-letter country abbreviations for the country.


#4. For each country, year, and sex compute the total number of cases of TB. Make an informative visualisation of the data.
who5 %>%
  group_by(country, year, sex) %>%
  filter(year > 1995) %>%
  summarise(cases = sum(cases)) %>%
  unite(country_sex, country, sex, remove = FALSE) %>%
  ggplot(aes(x = year, y = cases, group = country_sex, colour = sex)) +
  geom_line()
