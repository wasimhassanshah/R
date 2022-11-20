# Tidyr
library(tidyverse)

# pivot_longer(), pivot_wider(), separate, unite, fill, complete


table4a %>% 
  pivot_longer(cols = c('1999', '2000'), names_to ="year",
               values_to = "cases") %>% 
  arrange(country, year)


# gather do the same thing

table4a %>% 
  gather('1999', '2000', key ="year", value = "cases") %>% 
  arrange(country, year)

# pivot wider
table2
 

table2 %>% 
  pivot_wider(names_from = "type", values_from = "count")



# Spread do the same thing

table2 %>% 
  spread(key = "type", value = "count")



# Separate to divide variable into two variables


table3

table3 %>% 
  separate(rate, into = c("cases", "population"), sep = "/", convert = TRUE) 
                          # by default sep look for 1st non alpha numeric character 




# Unite to merge to variables into one

table5


table5 %>% 
  unite(new, century, year) # new is new variable




table5 %>% 
  unite(new, century, year, sep ="", remove = FALSE) # new is new variable
# remove False menas do not remove original variables century and year


 










