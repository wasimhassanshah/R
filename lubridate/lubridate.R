library(tidyverse)
library(lubridate)
library(nycflights13)

day <- today()
str(day)


string1 <- "2020-09-22"
string2 <- "2020-09-22 17:00:00"
str(string1)
str(string2)


# converting into dat and POSICTct format
#as.date is base R function
#as_date is lubridate function
# "POSIXct" is the most common class in R for datetimes.   These store the number of seconds since an origin point of "1970-01-01 00:00:00 UTC", whereas the "Date" class stores the number of days since "1970-01-01".

date1 <- as.Date(string1)
date2 <- as_date(string1)
datetime1 <- as.POSIXct(string2)
datetime2 <- as_datetime(string2)
str(date1)
str(date2)
str(datetime1)
str(datetime2)

#The functions `as.Date()` and `as.POSIXct()` come from base R.  However, the `as_date()` and `as_datetime()` functions come from "lubridate".  However, `as_datetime()` is a little easier to write and remember than `as.POSIXct()`! 


# Now suppose you have dates in some different formats.  lubridate comes with helper functions like `ymd()`, `mdy()`, `dmy()` with extensions such as `ymd_h()`, `ymd_hm()`, and `ymd_hms()`, for the "year", "minute", "day", "hour", "minute", and "second" components.

# Converting every format in year-month-date format

dateFormat1 <- "20200922"
dateFormat2 <- "09-22-2020"
dateFormat3 <- "22/09/2020"
dateFormat4 <- "09-22-2020 17:00:00"
dateFormat5 <- "20200922 170000"
ymd(dateFormat1)
mdy(dateFormat2)
dmy(dateFormat3)
mdy_hms(dateFormat4)
ymd_hms(dateFormat5)




### Isolating components of the datetime ###

# Let's look at today's date.   There are number of functions such as `year()`, `month()`, `mday()` (day of the month), `hour()`, `minute()`, `second()`, as well as helper functions like `yday()` and `wday()`.


todayDate <- "2020-09-22 17:15:00"
year(todayDate)
month(todayDate)
mday(todayDate)
hour(todayDate)
minute(todayDate)
second(todayDate)
yday(todayDate) # Which day of the year
wday(todayDate) # Which day of the week
 
#With the functions `month()` and `wday()`, you can specify the argument `label = TRUE`.   Observe:

month(todayDate, label = TRUE)
wday(todayDate, label = TRUE)



# Let's illustrate the usefulness of these functions by loading the `flights` data and creating a couple visualizations.

data <- flights %>%
  dplyr::select(flight, carrier, time_hour)
data

# First, let's create a bar chart of the count of flights by month:

data %>%
  mutate(month = month(time_hour, label = TRUE)) %>%
  ggplot() +
  geom_bar(aes(x = month), fill = "navy", color = "gold")

# let's create a line plot for flights by hour of the day:


data %>%
  mutate(hour = hour(time_hour)) %>%
  group_by(hour) %>%
  tally() %>% # tally to count distinct hour
  ggplot() +
  geom_line(aes(x = hour, y = n)) +
  scale_x_continuous(breaks = seq(0, 24, 4))


### Time spans (durations, periods, intervals) ###


#* Durations measure the exact number of seconds that occur between two instants.
#* Periods measure the change in clock time that occurs between two instants.
#* Intervals are timespans representing a start and an end point.



startDate <- as_datetime("2020-03-01 00:00:00")
endDate <- as_datetime("2020-03-31 23:59:59")
difftime <- endDate - startDate
difftime


# Examples of the three classes}
as.duration(difftime)
as.period(difftime)
as.interval(startDate, endDate)




