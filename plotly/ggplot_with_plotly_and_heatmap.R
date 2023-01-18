
library(tidyverse)


str(diamonds)

summary(diamonds
        )


ggplot(data = diamonds,
       aes(x = price)) +
  geom_histogram(bins = 100,
                 color = "black",
                 fill = "lightblue") + theme_bw()

plotly :: ggplotly(.Last.value)   #take Last graph value

table(diamonds$cut)
diamonds %>%  count(cut, sort= TRUE)

diamonds %>% 
  group_by(cut) %>% 
  summarize(min =min(price),
            median = median(price),
            mean = mean(price),
            max = max(price),
            n= n())


# Sampling

diamonds_NA <- diamonds

sample(x =1:nrow(diamonds_NA), size = 2500)




# Visualise heatmap

diamonds %>% 
  group_by(cut, clarity) %>% 
  summarize(mean = mean(price)) %>% 
  ggplot(aes(x = cut, y= clarity,
             fill = mean,
             label = round(mean, 0))) +
  geom_tile(color = "grey") +
  scale_fill_continuous(low = "orange",
                        high = "darkgreen",
                        name ="diamond\nprice") +
  geom_text(color = "white") +
  scale_y_discrete(limits = rev) +  # Y axis in decreasing quality
  scale_x_discrete(position = "top")  # X label at top

plotly :: ggplotly(.Last.value)  

































