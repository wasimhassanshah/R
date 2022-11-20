library(tidyverse)
library(DataExplorer)

introduce(airquality) %>% t()
plot_intro(diamonds)

plot_missing(airquality) +
  theme_bw() +
  ggtitle("Percentage of missing values")
 
#For plotting Categorical variables with price (continouou variable)

plot_bar(diamonds, with = "price" )


#For plotting Categorical variables with cut (discrete variable)

plot_bar(diamonds, by = "cut" )

#Plot correlation matrix

plot_correlation(iris, type="continuous")
#max categires to show top 5 most related vars
plot_correlation(iris, type="continuous", maxcat = 5)

plot_correlation(na.omit(airquality), type ="c")

# Distibution of numeric variable is usually explored by the means of histogram, density plots,
#quantile-quantile(QQ)plots and scatter plots

plot_histogram(airquality)

plot_density(airquality)

plot_qq(airquality)

# DataExplorer pkg alows to produce qqplot for every category of discrete variable
# As it will allows to check the normality of each variable for t test and ANOVA tests



plot_qq(iris, by= "Species", ncol =2 , ggtheme = theme_bw())




# Box plot shows where the most of the data is , namely inside of box, and which variable has many outliers
# They also used for the comparison of distribution of several groups and categories bcz they visualize
# range, spread and center of every group
# They are also hepful developing new hypotheses


plot_boxplot(airquality, by= "Month")

# Scatter plots

plot_scatterplot(iris, by= "Petal.Length")


#Principal Components

plot_prcomp(diamonds)













