library(tidyverse)

# Analyse and Explore dataset

data()

?starwars

dim(starwars)

str(starwars) #structure of df


glimpse(starwars)

names(starwars)  # names of columns (variables)
colnames(starwars) # names of columns (variables)
length(starwars)
class(starwars$hair_color) # type of variable

unique(starwars$hair_color) # unique observations in variable hair_color

# R coding method
View(sort(table(starwars$hair_color), decreasing=TRUE)) # little table showing how many times we have unique observation in variable hair_color

#Same as above using tidyverse below

#Tidyverse method
starwars %>%  
  select(hair_color) %>% 
  count(hair_color) %>% 
  arrange(desc(n)) %>% 
  drop_na() %>% 
  view()


barplot(sort(table(starwars$hair_color), decreasing = TRUE))


#Missing value analysis

View(starwars[is.na(starwars$hair_color), ]) #show where it is true that hair_color is missing(NA)


# Numerical vairiable analysis
class(starwars$height)

length(starwars$height)


summary(starwars$height)
boxplot(starwars$height)

hist(starwars$height)











































