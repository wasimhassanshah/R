library(tidyverse)
library(flextable)
library(dlookr)

# Diagnose
diagnose(airquality) %>%  flextable()

# Diagnose categorical variable
diagnose_category(diamonds) %>% flextable()

#diagnose numerical variables

diagnose_numeric(airquality) %>% flextable()

diagnose_outlier(diamonds) %>%  flextable()
# with_mean mean of the vaible with outlier
# withouy_mean mean of the vaible without outlier
# depth is not influenced by outliers as with and withou mean is same
# Whereas price is highly influenced by outliers as difference bw withmean and without mean is high


#dlookr can visualize data with and without outlier

#if we dont specify any colummns plotoutlier will plot each numeric variable drom our dataset
plot_outlier(airquality)

#Visualizing missing values proportion of each variable

plot_na_pareto(airquality)



# hclust to show how missing values are  and whtere there is any overlapping bw them

plot_na_hclust(airquality)

#plot na intersect visualises the combination of missing values across columns

plot_na_intersect(airquality)

#diagnose_report() function, which combines most of
#what we just learned (but not all!) into one PDF or HTML document in seconds.



diagnose_web_report(airquality, ) # pdf or html

#Explore

describe(iris) %>%  flextable()


# Normality check
iris %>% 
  group_by(Species) %>% 
  normality() %>% 
  flextable()

# plot_normality() function visualizes the normality of numeric data and two most common transformations of data, namely log transformation & square root, in case the normality assumption wasn’t met

airquality %>%
  plot_normality(Ozone)




# Correlation
# In order to quickly check the relationship between numeric variables we can use correlate() function. If we don’t specify any target variables, Pearson’s correlation between ALL variables will be calculated pairwisely



correlate(airquality, Ozone) %>%  flextable()


# But plot_correlate() function is even more useful, because it visualizes these relationships. We can of cours
#determine the method of calculations, be it a default “pearson”, or a non-parametric “kendall” or “spearman” correlation. The shape of each subplot shows the strength of the correlation, while the color shows the direction, where blue is positive and red is negative correlation.


plot_correlate(iris, method = "kendall")

# Here again, by using some {dplyr} code, we can quickly check as many correlations as we want.

diamonds %>%
  filter(cut %in% c("Premium", "Ideal")) %>% 
  group_by(cut) %>%
  plot_correlate(method = "spearman")


# Reporting
airquality %>%
  eda_web_report(
    target        = Temp, 
    output_format = "html", 
    output_file   = "EDA_airquality.html")

 # Imputing

bla <- imputate_na(airquality, xvar = Ozone, yvar = Temp, method = "mean")
summary(bla)

# “knn” : K-nearest neighbors
blap <- imputate_na(airquality, Ozone, Temp, method = "knn")
plot(blap)


# Categorical Imputation






d <- diamonds %>% 
  sample_n(1000) 

d[sample(seq(NROW(d)), 50), "cut"] <- NA

d2 <- imputate_na(d, cut, price, method = "mice", seed = 999)
plot(d2)



d %>% 
  mutate(new_cut = d2) %>% 
  select(cut, new_cut) %>% 
  plot_na_pareto()




#  IMPUTATION OF OUTLIERS


bla <- imputate_outlier(diamonds, carat, method = "mean")
plot(bla)

bla <- imputate_outlier(diamonds, carat, method = "median")
plot(bla)

bla <- imputate_outlier(diamonds, carat, method = "mode")
plot(bla)

bla <- imputate_outlier(diamonds, carat, method = "capping")
plot(bla)


# Standardization and Resolving Skewness
# transform() function performs both Standardization and Resolving Skewness.

bla <- transform(airquality$Solar.R)


plot(bla)


find_skewness(mtcars, index = F)

# Transforming hp column 

transform(mtcars$hp, method = "log+1") %>% 
  plot(ylim=c(0,10))


#Reporting
# Similarly to diagnosis and exploratory reporting, we can produce a transformation report using a single intuitive command.
transformation_report(airquality, target = Temp)

transformation_report(airquality, output_file = "Transformation_airquality.pdf")








