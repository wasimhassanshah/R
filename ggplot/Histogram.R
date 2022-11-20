
  library(tidyverse)
df <- read.csv("titanic.csv", stringsAsFactors = F)

df<- as.tibble(df) ()

# Factors are data structures in R that store categorical data

# Designating variables as factors, that will be useful when building
#boxplots and other graphs that make use of dicrete (categorical ) variables

df$Survived<-as.factor(df$Survived)
df$Pclass<- as.factor(df$Pclass)
df$Sex <- as.factor(df$Sex)
df$Embarked<- as.facotr(df$Embarked)
df     

# Main 3 layers fr plotting are data, Asethetic and geometry

hist <- ggplot(data=df, aes (x= Age))

#Each bin show us the frequency of observation
#Setting bins 
#alpha is for transparency where 1 is solid and 0 is transparent

# Adding layers with + sign

hist + geom_histogram(binwidth=5, color = "darkslategray", fill ="darkslategray4", alpha = 0.5)+
ggtitle("Age Distribution of the Titanic")+
  labs(y="Number of Passengers", x= "Age") +
  theme_minimal()



# Histogram Advance


library(ggplot2)
df_real_estate <- read.csv("histogram_data.csv", header =TRUE, sep=",")
hist<- ggplot(df_real_estate, aes(x= Price)) +
  geom_histogram(bins = 8, fill ="#108A99", color = "white")+
  theme_classic()+
  ggtitle("Distribution oof Real Estate Price")+
  xlab("Price in (000' $)")+
  ylab("Number of properties")+
  theme(plot.title = element_text(size=16, face = "bold"))# For varying label size
        

hist













