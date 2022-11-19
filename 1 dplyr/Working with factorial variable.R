#Working with factors and categorical variables. Use forcats in R programming to change factor levels
library(tidyverse)
library(forcats)
library(patchwork)


View(gss_cat)

glimpse(gss_cat)


unique(gss_cat$race)

#Aove code with pipe operator

gss_cat %>% 
  pull(race) %>% # pull race variable out as a vector from gss_cat with unique function
  unique()

 # droping factor from variable race

gss_cat %>% 
  mutate(race = fct_drop(race)) %>% 
  pull(race) %>% 
  levels()

# Order a factor levels by the value with fct_reorder
# of another numeric variable

gss_cat %>%
  drop_na(tvhours) %>% 
  group_by(relig) %>% 
  summarise(mean_tv = mean(tvhours)) %>% # Creating new variable mean_tv
  mutate(relig = fct_reorder(relig, mean_tv)) %>% # Reordering relig variable by increasing mean to get logic in graph
  ggplot(aes(mean_tv, relig)) +
  geom_point(size =4)



# Reverse factor levels to get low value at bottom with rev_fact()

gss_cat %>% 
  drop_na(age) %>% 
  filter(rincome != "Not applicable") %>% 
  group_by(rincome) %>% 
  summarise (mean_age = mean(age)) %>% 
  mutate(rincome = fct_rev(rincome)) %>%  # Changing a variable by reversing it from small to big value
  ggplot(aes(mean_age, rincome)) +
  geom_point(size = 4)



# Order factor levels by frequency of the value of that variable with fct_infreq


# For top to smallest value
gss_cat %>% 
  mutate(marital = fct_infreq(marital )) %>%  # Order the variable as per increasing frequency
  count (marital )



# For smallest to top value


gss_cat %>% 
  mutate(marital = fct_infreq(marital )) %>%  # Order the variable as per increasing frequency
  mutate(marital = fct_rev(marital)) %>% 
  ggplot(aes(marital)) +
  geom_bar(fill = "steelblue", alpha = 0.5) +
  theme_bw()





# Graph
gss_cat %>% 
  mutate(marital = fct_infreq(marital )) %>%  # Order the variable as per increasing frequency
  ggplot(aes(marital)) +
  geom_bar(fill = "steelblue", alpha = 0.5) +
  theme_bw()


# Recoding factors with fct_collapse
gss_cat %>% 
  mutate(partyid = fct_recode(partyid,
                              "Republican, strong" = "Strong republican",
                              "Repulican, weak"    = "Not str republican",
                               "Independent, near rep" = " Ind, near rep"))


count(partyid)


gss_cat %>% 
  mutate(partyid = fct_collapse(partyid,
                                other = c("No answer", "Don't know", "Other party "),
                                rep = c("Strong republican", "Not str republican"),
                                ind = c("Ind, near rep", "Independent", "Ind, near dem" ),
                                dem = c("Not str democrat", "Strong democrat")))

count(partyid)



# More from Youtube video  R programming 101






















