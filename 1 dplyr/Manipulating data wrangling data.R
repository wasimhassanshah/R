library(tidyverse)

glimpse(msleep)
View(msleep)


# Rename a Variable\

msleep %>% 
  rename("conserv" = "conservation") # new name is conserv
View(msleep)

## Changing variable Type

class(msleep$vore)

msleep$vore <- as.factor(msleep$vore)
glimpse(msleep)



# Doing above operation using mutate

msleep %>% 
  mutate(vore = as.character(vore)) %>% 
  glimpse()


# Select a variable to work with

names(msleep) # names of variables

msleep %>% 
  select(2:4,
         awake,
         starts_with("sleep"),
          contains("wt")) %>%
           names() 
          
                     


# Filter and arrange Data
unique(msleep$order)


msleep %>% 
  filter((order == "Carnivora" | 
            order == "Primates") &
           sleep_total > 8) %>% 
  select(name, order, sleep_total) %>% 
  arrange(-sleep_total) # minus means arrange exact opposite of sleep_total
  View

  
# Same above operation using %in%
  
  msleep %>% 
    filter(order %in% c("Carnivora", "Primates") &
             sleep_total > 8) %>% 
    select(name, order, sleep_total) %>% 
    arrange(order)  # arrange ccategorical alphabatical order
  View
  
  
# Change observations with mutate
  
msleep %>% 
  mutate(brainwt = brainwt * 1000) %>% 
  View

 # creating new variable
msleep %>% 
  mutate(brainwt_in_grams = brainwt * 1000) %>% 
  View


# Conditional change using if else

# Logical vector based on a condition

msleep$brainwt>0.1 # Logical vector 


size_of_brain <- msleep %>% 
  select(name, brainwt) %>% 
  drop_na(brainwt) %>% 
  mutate(brain_size = if_else(brainwt >0.01, # Creating new var called brain_size with the condition of brainwt
                              "large",
                              "small"))

size_of_brain


# Recode data and rename a variable

# Change observations of large and small into 1 and 2

size_of_brain %>% 
  mutate(brain_size = recode(brain_size,
                             "large" = 1,
                             "small" = 2))


# Reshape the data from wide to long or long to wide


library(gapminder) # dataset of gapminder


View(gapminder)

data <- select(gapminder, country, year, lifeExp)


# names_from is making columns from variable year
#values_from is making rows from variable lifeExp

wide_data <- data %>% 
  pivot_wider(names_from = year, values_from = lifeExp)

View(wide_data)


long_data <- wide_data %>% 
  pivot_longer(2:13,  # which columns u want to work with
               names_to = "year", # all names or  years' columns are going to be in new variable call year
               values_to = "lifeExp") # all values are going to move to new variable called lifeExp

View(long_data)















