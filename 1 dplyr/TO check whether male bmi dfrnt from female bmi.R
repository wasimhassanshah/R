library(tidyverse)
data()
View(starwars)

# To check whtere male bmi different from female bmi
# %>% shift + control + M to print pipe operator
starwars %>% 
  select(gender, mass, height, species) %>% 
  filter(species == "Human") %>% 
  na.omit() %>%  # to omit missing row
  mutate(height = height/ 100) %>%  # conveting height from cm to m
 mutate(BMI = mass/ height^2) %>% 
  group_by(gender) %>% 
  summarise(Average_BMI = mean(BMI))
