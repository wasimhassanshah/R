library(tidyverse)



# If_else vs case_when


USpops <- USpops %>% 
  mutate(
    Region = ifelse(State %in% Northeast, "Northeast",
                    ifelse(State %in% South, "South",
                           ifelse(State %in% Midwest, "Midwest",
                                  ifelse(State%in% West, "West", "Other"))))
  )



# Above using case_when

USpops <- df
mutate(
  Division = case_when(
    State %in% Notheast ~ "Northeast",
    State %in% South ~ "South",
    State %in% Midwest ~ "Midwest",
    State %in% Wesr ~ "West",
    TRUE ~ "Other"
  )
)
















