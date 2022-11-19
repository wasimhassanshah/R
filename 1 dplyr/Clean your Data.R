library(tidyverse)
View(starwars)

# Variable types

glimpse(starwars)

class(starwars$gender
      )

unique(starwars$gender)

# Converting Ordinal categorical varibale as factors is good practice


starwars$gender <- as.factor(starwars$gender)

class(starwars$gender)


levels(starwars$gender)

# Changing the order of Ordinal categorical variable as we like it


starwars$gender <- factor((starwars$gender),
                          levels= c("masculine",
                                    "feminine"))

levels(starwars$gender)

# Selecting Variables

names(starwars) # names of variables


starwars %>% 
  select(name, height, ends_with("color")) %>% 
  names()

# Filtering observation

unique(starwars$hair_color)

starwars %>% 
  select(name, height, ends_with("color")) %>% 
  filter(hair_color %in% c("blond", "brown") & # either  blond or brown with height < 180
                   height <180 )



# Missing Data

mean(starwars$height, na.rm = TRUE) # na.rm TRUE means removing all na


# Removing all na from following columns though not good practice
starwars %>% 
  select(name, gender, hair_color, height) %>% 
  na.omit()

# to get every single observation which is not complete or having na values

starwars %>% 
  select(name, gender, hair_color, height) %>% 
  filter(!complete.cases(.))


 # Remoing height na values
starwars %>% 
  select(name, gender, hair_color, height) %>% 
  filter(!complete.cases(.)) %>% 
  drop_na(height) %>% 
  View()

 # Replacing NA in hair_color with none
# bcz droids have no har so no hair color

starwars %>% 
  select(name, gender, hair_color, height) %>% 
  filter(!complete.cases(.)) %>% 
  mutate(hair_color = replace_na(hair_color, "none"))



# Duplicates

Names <- c("Peter", "John", "Andrew", "Peter")
Age <- c(22,33,44,22)

friends <- data.frame(Names, Age)

duplicated(friends) # Logical verctor to check is there are duplicated in df

friends[!duplicated(friends),] # Showing rows/ observations with no duplicates

# or same thing with distinct

friends %>%  distinct() # Showing rows/ observations with no duplicates
          

# recoding Variables


starwars %>%  select(name, gender)


starwars %>% 
  select(name, gender) %>% 
  mutate (gender= recode(gender,
                         "masculine" = "m",
                         "feminine" = "f"))























