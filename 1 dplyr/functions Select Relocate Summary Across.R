library(tidyverse)


mpg
# Select

mpg %>%
  select(model, manufacturer, class, year)

mpg %>% 
  relocate(model, manufacturer, class, year)


# Moving manufacture after class column
mpg %>% 
relocate( manufacturer, .after=class)


# Moving manufacture before class column
mpg %>% 
  relocate( manufacturer, .before=class)


# Moving manufacture at offset (before) last columns
mpg %>% 
  relocate( manufacturer, .after=last_col(offset = 2))


# Relocating by data typre


# Where numeric put all numerical columns in front and all char columns in back
mpg%>%
  relocate(where(is.numeric))

#viceversa
mpg%>%
  relocate(where(is.character))


# Data

mpg %>% View()

# Summarise vs ACross

# Average CITY FUEL CONSUMPTION BY VEHICLE CLASS

mpg %>%
  group_by(class) %>%
  summarize( 
    across(cty, .fns = mean),
    .groups= "drop")


#.fs is dot function argument
# Avg and STD CITY FUEL CONSUMPTION BY VEHICLE CLASS

mpg %>%
  group_by(class) %>%
  summarise(
    across(cty, .fns = list(mean = mean, stdev = sd)), # adding list of functions now
    .groups= "drop"
    
  )

# For multiple columns for city and highway and renaming
mpg %>%
  group_by(class) %>%
  summarise(
    across(c(cty, hwy), 
           .fns = list(mean = mean, stdev = sd), # adding list of functions now
           .names= "{.fn} {.col} Consumption"),
    .groups= "drop"
    
  ) %>%
  rename_with(.fn = str_to_upper)

# Complex functions ~ is anonymous function

mpg %>%
  group_by(class) %>%
  summarise(
    across(c(cty, hwy), 
           .fns = list(
             "mean" = ~ mean(.x), #.x means all elements of column
             "Range low" = ~(mean(.x)- 2*sd(.x)),
             "Range high" = ~ (mean(.x) + 2*sd(.x))
             ), # adding 95% of confidence interval
           .names= "{.fn} {.col} Consumption"),
    .groups= "drop"
    
  ) %>%
  rename_with(.fn = str_to_upper)












