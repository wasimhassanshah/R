
# MissRanger pkg to impute missing value in the whole dataset

library(dlookr)
library(tidyverse)
# Pareto chart shows proportion of missing values in each variable
plot_na_pareto(airquality)

# Only na True to show missing values columns only
plot_na_pareto(airquality, only_na = T)

# na intersec visulizes combination of missing values across columns

plot_na_intersect(airquality)
# X axis shows number of columns missing values
#Count of missing values showed on top of the bars
# Y axis hows combination of missing and their frequencies 
# For example 2 shows 2 na in both of ozone and solar variable 


# To visualize which two rows have  missing na in both columns

 

library(visdat)      # for visualizing NAs
library(plotly)      # for interactive visualization
vis_miss(airquality) %>% ggplotly()

# Missing value imputation with dlookr with two methods 

# producing more missing in dataset

library(missRanger)
set.seed(111)
airquality_NA <- generateNA(airquality) %>% 
  mutate(Month = factor(Month))


plot_na_intersect(airquality_NA)


plot_na_pareto(airquality_NA) # now every variable has 10 % of observation missing

# 3 methods of imputation
# impute_na function 4 arguments 1 te dataset,2 variable with na
# e variable which predict na , 4 method to predict na
# We use the method which does not change the distribution to much or too weirdly

# impute with mean
imputate_na(airquality_NA, Ozone, Temp, method="mean") %>% 
  plot()
# Mean imputaton produce weird spike in middle of plot which doesnot make any sense






# Machine learning method imputation : RPART : Recursive Partitioning and Regression Trees.
# AND mice: Multivariate Imputation by Chained Equations 
# impute with rpart

imputate_na(airquality_NA, Ozone, Temp, method="rpart") %>% 
  plot()
# rpart produce food result









#impute with mice

imputate_na(airquality_NA, Ozone, Temp, method="mice", seed =111) %>% 
  plot()
# mice also produce food result


#Choosing MICE method for predicting na values for each variable 

# Predicting categorical variable Month

imputate_na(airquality_NA, Month, Temp, method="mice", seed =111) %>% 
  plot()


# Using Missranger [kg for prediction missing values
#Missranger predicts multiple variable at the same time by using all other variables in the dataset as predictors
# THis method combines Random Forest imputation with the MICE method using predictive mean matching
library(missRanger)
airquality_imputet <- missRanger(
  airquality,
  formula = .~., # point on left side will find all the variables with missing values
  #and filled them up and the point on the right side use all the predictors in the 
  #dataset even those with missing values
  num.trees= 1000,
  verbose = 2,
  seed = 3,
  returnOOB = T
)

#MissRanger iterate imputation for every missing values for multiple times until
#the average prediction error stops to improve this allows realistic imputation which avoids strange values
## Miss RAnger is written in C+ and is quicker and can be used for BigData




# numeric imputation  
# red points are imputed values and black are original values 
# graph shows imputed values are very close to original values this shows accuracy of MissRanger
ggplot()+
  geom_point(data = airquality_imputet, aes(Ozone, Solar.R), 
             color = "red")+
  geom_point(data = airquality_NA, aes(Ozone, Solar.R))+
  theme_minimal()


ggplot()+
  geom_point(data = airquality_imputet, aes(Wind, Temp), 
             color = "red")+
  geom_point(data = airquality_NA, aes(Wind, Temp))+
  theme_minimal()




#Multivariate imputation of categorical variables
# caterogical imputation
ggplot()+
  geom_bar(data = airquality_NA, aes(Month), width = 0.3)+
  geom_bar(data = airquality_imputet, aes(Month), fill = "red",
           position = position_nudge(x = 0.25), width = 0.3)+
  
  theme_minimal()



