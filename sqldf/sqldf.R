library("sqldf")
library("tidyverse")
library("fueleconomy")

colnames(airquality)
View(airquality)

sqldf("
      SELECT * FROM airquality WHERE Month= 5
      ")

sqldf("
      SELECT Month, COUNT(Month) as Total FROM airquality GROUP BY Month
      
      ")

colnames(starwars)
View(starwars)

starwars$name <- as.factor(starwars$name)

class(starwars$name)

starwars %>% 
  drop_na(name) %>% 
  View()

sqldf("
      SELECT *,
      CASE
      WHEN lower(name) = 'C-3PO' THEN 1
      ELSE 0
      END as friend
      FROM starwars
      ORDER BY friend DESC, haircolor
      
      
      ")


# Using fueleconmy

data(vehicles)
colnames(vehicles)

# dplyr vs sqldf functionalities 
vehicles %>%  summarise(n_distinct(make))

sqldf("SELECT COUNT(DISTINCT make) FROM vehicles")

# Above and Below Both give same result


vehicles %>%  filter(year == 2014) %>%  summarise(n())

sqldf("SELECT COUNT(*) FROM vehicles WHERE year= 2014")




vehicles %>%  filter(year ==2014 & class == "Compact Cars") %>% 
  summarise(mean(cty))

sqldf("SELECT AVG(cty) FROM vehicles WHERE year = 2014 AND class='Compact Cars'")


table1 <- vehicles %>%  filter(year ==2014 & class == "Midsize Cars") %>% 
  group_by(make) %>% 
  summarise(count=n(), average = mean(cty)) %>% 
  arrange(desc(average))



table2<- sqldf( "SELECT make, COUNT(), AVG(cty) FROM vehicles WHERE year = 2014 AND class = 'Midsize Cars'
       Group BY make ORDER BY Avg(cty) DESC")

View(table1)
View(table2)

