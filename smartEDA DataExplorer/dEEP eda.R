# DEEP EDA

library(tidyverse)
library(DataExplorer)

plot_bar(diamonds)

plot_bar(diamonds, by= "cut")

# From Smart EDA library
#The plot below nearly “scrims” the hypothesis that education level is strongly associated with the job. Namely, the more educated we get, the more likely we’ll end up working with information (e.g. with data ;) and the less likely we’ll end up working in a factory.
library(SmartEDA)
library(ISLR
ExpCatViz(
  Wage %>%
    select(education, jobclass),
  target = "education")





#ggstatsplot}
#Fortunately, the ggbarstats() function from {ggstatsplot} package does all the above in one line of code and even goes one step further. Namely:
  
 # it counts and calculates percentages for every category,
#it visualizes the “frequency table” in the form of stacked bars and
#provides numerous statistical details (including p-value) in addition to visualization, 

library(ggstatsplot)     # visualization with statistical details
ggbarstats(
  data  = Wage, 
  x     = jobclass, 
  y     = education, 
  label = "both")

# Explore numeric variables with descriptive statistics



# {dlookr}
## Descriptive statistics is usually needed for either a whole numeric variable, or for a numeric variable separated in groups of some categorical variable, like control & treatment. Three functions from {dlookr} package, namely describe(), univar_numeric() and diagnose_numeric() do totally nail it. 

library(dlookr)
library(flextable)        # beautifying tables
dlookr::describe(iris) %>% flextable()

#And if you don’t need such a monstrous table, but only want to have the median() instead of 17 quantiles, use univar_numeric() function.

iris %>% 
  group_by(Species) %>% 
  univar_numeric() %>% 
  knitr::kable()

# diagnose_numeric() function reports the usual 5-number-summary (which is actually a box-plot in a table form) and the number of zeros, negative values and outliers.


iris %>% 
  diagnose_numeric() %>% 
  flextable()

# SmartEDA}
# {SmartEDA} with its ExpNumStat() function provides, in my opinion, the richest and the most comprehensive descriptive statistics table. Moreover we can choose to describe the whole variables, grouped variables, or even both at the same time. If we call the argument “by =” with a big letter A, we’ll get statistics for every numeric variable in the dataset. The big G delivers descriptive stats per GROUP, but we’ll need to specify a group in the next argument “gr =”. Using GA, would give you both

ExpNumStat(iris, by="A", Outlier=TRUE, Qnt = c(.25, .75), round = 2) %>% flextable()


ExpNumStat(iris, by="G", gp="Species", Outlier=TRUE, Qnt = c(.25, .75), round = 2) %>% flextable()


ExpNumStat(iris, by="GA", gp="Species", Outlier=TRUE, Qnt = c(.25, .75), round = 2) %>% flextable()


# {summarytools}
# For instance, dfSummary() function from {summarytools} package provides some basic descriptive stats for numeric and counts with proportions for categorical variables


library(summarytools)
dfSummary(diamonds)


 # First of all, tbl_summary() function from {gtsummary} package summarizes all categorical variables by counts and percentages, while all numeric variables by median and IQR. The argument by = inside of tbl_summary() specifies a grouping variable. The add_p() function then conducts statistical tests with all variables and provides p-values. For numeric variables it uses the non-parametric Wilcoxon rank sum test for comparing two groups and the non-parametric Kruskal-Wallis rank sum test for more then two groups. Categorical variables are checked with Fisher’s exact test, if number of observations in any of the groups is below 5, or with Pearson’s Chi-squared test for more data.


library(gtsummary)
mtcars %>% 
  select(mpg, hp, am, gear, cyl) %>% 
  tbl_summary(by = am) %>% 
  add_p()


Wage %>%
  select(age, wage, education, jobclass) %>% 
  tbl_summary(by = education) %>% 
  add_p()

# {moments}
# SKEWNESS

# guidelines for the measure of skewness are following:
  
 # if skewness is less than -1 or greater than 1, the distribution is highly skewed,
# if skewness is between -1 and -0.5 or between 0.5 and 1, the distribution is moderately skewed and
# if skewness is between -0.5 and 0.5, the distribution is approximately symmetric.
library(moments)
skewness(airquality$Ozone, na.rm = T)   


skewness(airquality$Wind, na.rm = T)  

agostino.test(airquality$Ozone)


anscombe.test(airquality$Ozone)




 # Check the normality of distribution

plot_qq(iris)

plot_qq(iris, by = "Species")


library(ggpubr)
ggqqplot(iris, "Sepal.Length", facet.by = "Species")


# {dlookr} Shapiro-Wilk normality tests

normality(airquality) %>%
  mutate_if(is.numeric, ~round(., 3)) %>% 
  flextable()

diamonds %>%
  group_by(cut, color, clarity) %>%
  normality()

bla <- Wage %>%
  filter(education == "1. < HS Grad") %>% 
  select(age)

normality(bla) %>% flextable()
plot_density(bla)


agostino.test(bla$age)
anscombe.test(bla$age)

ggqqplot(bla$age)



# Explore categorical and numeric variables with Box-Plots


# Box-plots help us to explore a combination of numeric and categorical variables. Put near each other, box-plots show whether distribution of several groups differ.



ggbetweenstats(
  data = iris, 
  x    = Species, 
  y    = Sepal.Length, 
  type = "np")


# {SmartEDA}
#The only useful thing here, compared to function provided above, is plotting of the whole variable near the the same variables splitted into groups.



ExpNumViz(iris, target = "Species", Page = c(2,2))



# Explore correlations




correlate(airquality, Ozone)
plot_correlate(airquality, method = "kendall")




diamonds %>%
  filter(cut %in% c("Premium", "Ideal")) %>% 
  group_by(cut) %>%
  plot_correlate()


# {ggstatsplot}
#nd that’s exactly what ggcorrmat() function from {ggstatsplot} package does! Namely, it displays:
  
#  correlation coefficients,
#a colored heatmap showing positive or negative correlations, and, finally shows
#whether a particular correlation is significant or not, where not-significant correlations are simply crossed out.




ggcorrmat(data = iris)
y

ggcorrmat(
  data   = iris,
  type   = "np",
  output = "dataframe"
) %>% 
  mutate_if(is.numeric, ~round(., 2)) %>% 
  flextable()



ggscatterstats(
  data = airquality,
  x = Ozone,
  y = Temp,
  type = "np" # try the "robust" correlation too! It might be even better here
  #, marginal.type = "boxplot"
)

y



#{PerformanceAnalytics}
#Another effective way to conduct multiple correlation analysis is supported by the chart.Correlation() function from {PerformanceAnalytics} package. It displays not only

##correlation coefficients, but also
#histograms for every particular numeric variable, and
#scatterplots for every combination of numeric variables.
#Besides, significance stars are particularly helpful, because they describe the strength of correlation.
#Here we can of coarse also specify the method, we measure the correlation by.

library(PerformanceAnalytics)
chart.Correlation(iris %>% select(-Species), method = "kendall") 


library(fastStat)
iris %>% select_if(is.numeric) %>% cor_sig_star(method = "kendall")



#  {dlookr} - linear models
# The compare_numeric()* function from {dlookr} package examines the relationship between numerical variables with the help of (Pearson’s) correlation and simple linear models

bla <- compare_numeric(iris) 

bla$linear %>% 
  mutate_if(is.numeric, ~round(.,2)) %>% 
  flextable()

plot(bla)


# Exploratory modelling
# however, how can we explore whether linear model makes any sense? Well, I think the easiest way is to plot the data with {ggplot2} package and use geom_smooth() function which always fits the data no matter what shape. Such exploration may point out the necessity to use non-linear models, like GAM or LOESS:
  

ggplot(airquality, aes(Solar.R, Temp))+
  geom_point()+
  geom_smooth()+
  facet_wrap(~Month)


# Explore outliers

library(performance)
plot(check_outliers(airquality$Wind, method = "zscore"))


# {dlookr}
# diagnose_outlier() function from {dlookr} not only counts outliers in every variable using interquartile range method, but also gets their percentage
diagnose_outlier(diamonds) %>% flextable()



# Besides, {dlookr} can visualize the distribution of data with and without outliers, and, thank to collaboration with {dplyr}, we could choose to visualize only variables with over 5% of values being outliers:

airquality %>% 
  dplyr::select(Ozone, Wind) %>% 
  plot_outlier()


# # Visualize variables with a ratio of outliers greater than 5%
diamonds %>%
  plot_outlier(diamonds %>%
                 diagnose_outlier() %>%
                 filter(outliers_ratio > 5) %>%
                 select(variables) %>%
                 pull())


# Impute outliers
# Similarly to imputate_na() function, {dlookr} package provides the imputate_outlier() function too, which allows us to impute outliers with several methods: mean, median, mode and cupping. The last one, “capping”, is the fanciest, and it imputes the upper outliers with 95th percentile, and the bottom outliers with 5th percentile. Wrapping a simple plot() command around our result, would give us the opportunity to check the quality of imputation.

bla <- imputate_outlier(diamonds, carat, method = "capping")
plot(bla)












