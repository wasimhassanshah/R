#esquisse pkg for interactive drag drop plots ggplot

library(tidyverse)
library(esquisse)

data()
cars<-mtcars


airqualitydf <-
  airquality


# go to Addins and then to ggplot builder
library(ggplot2)

ggplot(airqualitydf) +
 aes(x = Solar.R, y = Ozone, fill = Day) +
 geom_point(shape = "circle", size = 2.45, 
 colour = "#112446") +
 geom_smooth(span = 0.75) +
 scale_fill_gradient() +
 theme_minimal()











