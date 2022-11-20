library(ggplot2)
library(tidyverse)
hdi <- read.csv("hdi-cpi.csv", stringsAsFactors = FALSE  )
hdi <- as_tibble(hdi)
hdi

sc <- ggplot(hdi)

sc<- ggplot(hdi, aes(CPI.2015, HDI.2015))
sc


# In geometry layer is where the shape we want our data points take
# Adding geometry layer to sc object containing ggplot call

sc+geom_point()

# Facet layer
sc + geom_point(aes(color = Region), size = 3) + facet_grid(Region ~.)+
  stat_smooth() 

# Geometry layer
sc + geom_point(aes(color = Region), size = 3) + facet_grid(Region ~.)+
  stat_smooth() + coord_cartesian(xlim = c(0.75, 1))

# To see Countires on upper quartile (0.75) of the CPI index 

#(THis shows most of the countries with least recorder corruption instance are from Wester Europe Group)



# Theme Layer
sc + geom_point(aes(color = Region), size = 3)+ 
  stat_smooth() +theme_minimal() 





