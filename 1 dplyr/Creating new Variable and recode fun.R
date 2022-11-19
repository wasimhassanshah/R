library(tidyverse)
starwars

#Creating new variable with new dataset

sw <- starwars %>% 
  select(name, height, mass, gender) %>% 
  rename(weight = mass ) %>% 
  na.omit() %>% 
  mutate ( height = height/100) %>% 
  filter(gender %in% c("masculine", "feminine")) %>% 
  mutate(gender = recode(gender, # recoding male as m and female as f
                         male = "m",
                         female = "f")) %>% 
  mutate(size = height > 1 & weight > 75, # creating new variable
         size = if_else( size == TRUE, "big", "small"))

  
  