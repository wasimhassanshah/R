library(tidyverse)

summary(msleep)

msleep %>% 
  select(sleep_total, brainwt) %>% 
  summary()
  

# Create a summary table
# For each category of "vore"
# Show the min, max and difference
# and average "sleep_total
# and arrange data by the average


msleep %>% 
  drop_na(vore) %>% 
  group_by(vore) %>% 
  summarise(Lower = min(sleep_total),
            Average = mean(sleep_total),
            Upper = max(sleep_total),
            Difference =
              max(sleep_total)- min(sleep_total)) %>% 
  arrange(Average) %>% 
  View()
  


# Creating Contingency Table

library(MASS)
attach(Cars93) # it means there is no need of calling dataframe (Cars93 here) again and again to operate on it
#instead now you can directly call a variable of that dataframe without naming fataframe again and again


glimpse(Cars93)

 table(Origin) # Origin column of Cars93 df without specifying df bcz we already attached it

table(AirBags, Origin)

#Add Margins

addmargins (table(AirBags, Origin), 1) # adding Airbags and Origin column wise with 1

addmargins (table(AirBags, Origin), 2) # adding Airbags and Origin row wise wise with 2


addmargins (table(AirBags, Origin)) # both rows and columns wise sum

# Getting proportion

table(AirBags, Origin)
prop.table(table(AirBags, Origin), 1) * 100

round(prop.table(table(AirBags, Origin)) * 100) # Rounding values

# same operation using pipe operator

Cars93 %>% 
  group_by(Origin, AirBags) %>% 
  summarise(number = n()) %>% 
  pivot_wider(names_from = Origin, # make origin colum names as new variables
              values_from = number) # And in it Put values from numbe columns
                                    # For Air Bags














