library(tidyverse)
library(psych)
college<-read.csv("regression-example.csv")

describe(college)

linmode <- lm(GPA ~ SAT, data = college)

#lm func where SAT is predicotr, GPA is response

ggplot(college, aes(SAT, GPA)) +
  geom_point() +
  theme_light() +
  labs (x= "SAT Scores",
        y= "GPA upon graduation",
        title = "SAT and GPA") +
  stat_smooth(method ="lm", se = FALSE)

#summary of the result of linmodel
summary(linmode)
