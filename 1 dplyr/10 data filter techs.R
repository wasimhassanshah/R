library(tidyverse)
View(msleep)

 
my_data <-msleep %>%
  select(name, order, bodywt, sleep_total) %>%
  filter(order == "Primates" | bodywt > 20)

my_data <- msleep %>%
  select(name,  sleep_total) %>%
  filter(name == "Cow" |
         name == "Dog"|
         name == "Horse")

# Or result same through Concatination with %n% : read as: where name any whre within this concatination
 
my_data <- msleep %>%
  select(name,  sleep_total) %>%
  filter(name %in% c( "Cow" , "Dog", "Horse"))

# between 16 ,(and) 18 here , is and

my_data <- msleep %>%
  select(name,  sleep_total) %>%
  filter(between(sleep_total, 16, 18))


# near

my_data <- msleep %>%
  select(name,  sleep_total) %>%
  filter(near(sleep_total, 17, tol=0.5))
# tol shows close with 0.5

# is na

my_data <- msleep %>%
  select(name, conservation, sleep_total) %>%
  filter(is.na(conservation))
# where conservation is missing


# is not na (! sign)
my_data <- msleep %>%
  select(name, conservation, sleep_total) %>%
  filter(!is.na(conservation))
# where conservation is not missing


