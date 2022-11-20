
df_used_cars <- read.csv("bar_chart_data.csv")
df_used_cars

library(ggplot2)

bar_chart <-ggplot(df_used_cars, aes(x= Brand, y = Cars.Listings)) +
  geom_bar(stat= "identity", width = 0.8, color = "navy", fill = "navy" ) + # stat parameter to plot bar char
  ggtitle("Cars Listing by Brand") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust =1)) +
  labs(x = NULL, y = "Number of Listings")
  
bar_chart

