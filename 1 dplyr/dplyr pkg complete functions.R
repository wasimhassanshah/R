library(tidyverse)
library(nycflights13)

# dplyr
# filter(), arrange , select, rename, mutate and extensions,
# group_by, summarize, left_join


# filter()
flights <- flights
airlines <- airlines

flightsFiltered  <- flights %>% 
  filter(month ==1 | month ==2, day == 1)


# arrange(), TO sort the data frame

flightsArranged <- flightsFiltered %>% 
  arrange(year, month, day, desc(dep_delay))


 
# select


 # :: indicated use select function of dplyr function
# :: using is necesary bcz many functions with same name belongs to varous libraies
flightsSelected <- flightsArranged %>%
  dplyr::select(-(hour:time_hour)) # not selecting columns from hour to time_hour

 
# rename


dplyr::rename("airtime" = "air_time", "destination" = "dest")
flightsSelected


# mutate to create new variables

flightsMutated <- flightsSelected %>% 
  mutate (gain = dep_delay - arr_delay,
          hours = air_time/ 60,
          gain_per_hour = gain/hours)


View(flightsMutated)

class("year")
class("month")
class("day")

# `{r Extensions of "mutate"}
# Converting multiple columns type with mutate at
flights2a <- flightsMutated %>%
  mutate_at(.vars = c("year", "month", "day"), .funs = as.factor)


class(flights2a$year)
class(flights2a$month)
class(flights2a$day)
# Transmute drop all other columns except the ones u created


# Converting multiple columns type with mutate across
flights2b <- flightsMutated %>%
  mutate(across(.cols = c("year", "month", "day"), .fns = as.factor))

# Converting all variables data type
flights3a <- flightsMutated %>%
  mutate_all(.funs = as.factor)

flights3b <- flightsMutated %>%
  mutate(across(.cols = everything(), .fns = as.factor))
# Check that these return the same result
identical(flights2a, flights2b)
identical(flights3a, flights3b)




# Goup By creates grouped dataset
# Groupby mostly used with summarise fn

meanDelays <- flightsMutated %>% 
  group_by(carrier) %>% 
  dplyr::summarize(meanDelay = mean(dep_delay, na.rm = TRUE)) %>% 
                     arrange(desc(meanDelay))
meanDelays



# Another common function used with `summarize()` is the count function `n()`
# Alternatively the function `tally()` can be used - this is a wrapper for `summarize(n = n())`. 

carrierCounts <- flightsMutated %>%
  group_by(carrier) %>%
  dplyr::summarize(n = n()) %>%   # Equivalent: tally()
  arrange(desc(n))
carrierCounts

# with tally( same result)

carrierCounts <- flightsMutated %>%
  group_by(carrier) %>%
  tally() %>%   # Equivalent: tally()
  arrange(desc(n))
carrierCounts


# Join

#Lastly we will see a join function.  
#We will use `left_join()` here, but note there are many other types: `inner_join`, `right_join`, `full_join`, `semi_join`, and `anti_join`.


airlineNames <- meanDelays %>%
  left_join(airlines, by = c("carrier" = "carrier")) %>%
  dplyr::select(name, carrier, meanDelay)
airlineNames











