library(tidyverse)
data()
?starwars
# dimensions of dat
dim(starwars)

str(starwars) # To see data types of df

glimpse(starwars) # To see data types of df in cleaner way

View(starwars) #To see df in seperate tab

head(starwars) # first 6 rows

tail(starwars) # last 6 rows

# To see particular variable
starwars$name

attach(starwars) # to not again call starwars again and again

names(starwars) # names of variables/ columns

length(starwars) # number of variables

# Categorical Variable EDA 
class(hair_color) # type of variable
length(hair_color) # number of observation in variable
unique(hair_color) # all of the unique values in variable
# NA means data is missing, None means here has no color or there is no hair
# unknowns means we dont know what hair color is

table(hair_color) # How many observation each color has

# sorting table from biggest to small
sort(table(hair_color), decreasing = TRUE)

# Viewing it
View(sort(table(hair_color), decreasing = TRUE)) 

# above code with pipe operator, much easier way

starwars %>% 
  select(hair_color) %>% 
  count(hair_color) %>% 
  arrange(desc(n)) %>% 
  View()
  

#ploting it 

barplot(sort(table(hair_color), decreasing = TRUE))

# Missing value in hair_color column

starwars[ is.na(hair_color), ] # checking those rows having hair_color na  and show those rows



View(starwars[ is.na(hair_color), ])



# Numerical Variable EDA

class(height)
length(height)
summary(height)
boxplot(height)
hist(height)


