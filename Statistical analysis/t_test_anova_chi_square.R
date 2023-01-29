library(tidyverse)

#T test

my_data <-starwars %>% 
  select(sex, height) %>% 
  filter(sex %in% c("male", "female")) %>% 
  drop_na(height)

# P value less than 0.05 # Reject null hypothesis (that means are equal)


# Null Hypothesis : Both the genders has the same height

# Qs is the avg heigh of males in the star wars universe more than the average height of females


# height ~ sex : aggregating height by sex, putting males heights in one bucket and females heights in another

t.test(height ~ sex, data= my_data)

# Result mean female height = 169.267, mean male height = 179.105
# With p = 0.1181m which is not statistically significant, means the difference in height we are seeing given the sample size is just by chance and it is not statistically significant difference



#T test in pipe operator
starwars %>% 
  select(sex, height) %>% 
  filter(sex %in% c("male", "female")) %>% 
  drop_na(height) %>% 
  t.test(height ~ sex, data= .)
 



# ANOVA Test

# Null hypothesis is the avg weight of all 4 categories in rem column is same

my_data2 <- msleep %>% 
  select(vore, sleep_rem) %>% 
  drop_na()



mod1 <- aov(sleep_rem ~ vore, data = my_data2)

summary(mod1)

# p value is less than 0.05 so we reject the null hypothesis



# Chi squared goodness of fit test

library(forecast)

View(gss_cat)


# Chi square test: Is there any difference in the proportion  of people who never married, divorced or married
# Null hypothesis: there is no difference , they all are the same (equal)
my_data3 <- gss_cat %>% 
  select(marital) %>% 
  filter(marital %in% c("Married",
                        "Never married",
                        "Divorced")) %>% 
  mutate(marital = fct_drop((marital))) # removing unnecessary factors# Putting all 3 chosen categories in one column marital


my_table <-table(my_data3) # creating table of all three categories, counting them and putting them in table

View(my_table)

chisq.test(my_table)
 # P value ver small ( p-value < 2.2e-16), so we will say it is extremely unlikely that if we did have equal proportions of these three categories,
# that we reject null hypothesis























