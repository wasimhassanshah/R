library(tidyverse)

df <- read.csv("hdi-cpi.csv")
df
sp <- ggplot(df, aes(CPI.2015, HDI.2015))
sp+ geom_point(aes(color= Region), shape =21,
               fill= "white", size = 3, stroke = 2) +
         theme_light()+
labs (x= "Corruption Perception Index 2015",
      y= "Human Develpoment Index, 2015",
      title= "Corruption and Human Development") +
  stat_smooth() + # SE is TRUE now means   give me standard error area +
stat_density2d() # density function to nsee the relative frequency distribution of the observations

