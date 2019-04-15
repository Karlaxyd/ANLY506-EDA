##Pirate 8.7 exercise

#1. Combine the data into a single dataframe.

pirates <- data.frame(name = c("Astrid", "Lea","Sarina", "Remon", "Letizia", "Babice", "Jonas", "Wendy", "Niveditha", "Gioia"),
                      sex = c("F", "F", "F", "M","F","F","M","F","F","F"),
                      age = c(30, 25, 25, 29, 22, 22, 35, 19, 32, 21),
                      superhero = c("Batman", "Superman", "Batman", "Spiderman", "Batman", "Antman", "Batman", "Superman", "Maggott", "Superman"),
                      tattoos = c(11, 15, 12, 5, 65, 3, 9, 13, 900, 0),
                      stringsAsFactors=FALSE)

#2. What is the median age of the 10 pirates?

median(pirates$age)

#3. What was the mean age of female and male pirates separately?

fpirates <- subset(pirates, sex == "F")
mpirates <- subset(pirates, sex == "M")
mean(fpirates$age)
mean(mpirates$age)

fpirates <- pirates[pirates$sex == "F"]
mpirates <- pirates[pirates$sex == "M"]
mean(fpirates$age)
mean(mpirates$age)

mean(pirates$age[pirates$sex == "M"])
mean(pirates$age[pirates$sex == "F"])

with(pirates, mean(age[sex == "M"]))
with(pirates, mean(age[sex == "F"]))

#4. What was the most number of tattoos owned by a male pirate?

with(pirates, max(tattoos[sex == "M"]))

#5. What percent of pirates under the age of 32 were female?

with(subset(pirates, age < 32), mean(sex == "F"))

#6. What percent of female pirates are under the age of 32?

with(subset(pirates, sex == "F"), mean(age < 32))

#7. Add a new column to the dataframe called tattoos.per.year which shows how many tattoos each pirate has for each year in their life.

pirates$tattoos.per.year <- with(pirates, tattoos / age)

#8. Which pirate had the most number of tattoos per year?

install.packages("nnet")
library("nnet")
with(pirates, name[which.is.max(tattoos.per.year)])

with(pirates, name[tattoos.per.year == max(tattoos.per.year)])

#9. What are the names of the female pirates whose favorite superhero is Superman?

with(subset(pirates, sex == "F"), name[superhero == "Superman"])

#10. What was the median number of tattoos of pirates over the age of 20 whose favorite superhero is Spiderman?

with(subset(pirates, age > 20 & superhero == "Spiderman"), median(tattoos))