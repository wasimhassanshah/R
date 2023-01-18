library(tidyverse)
library(ggthemes)
library(lubridate)
library(stringr)
library(plotly)
avocado_data = read_csv("avocado.csv")

avocado_data %>% 
  ggplot(aes(x= Date, y = AveragePrice, color = region)) +
  geom_line(size =1.5, alpha = 0.8) + 
  labs(title = "Avg Avocado Price in th US Over Time",
       subtitle = "How do Avocado Prices differ by region",
       x= "Date",
       y="Avg Price",
       color= "Region") + theme_fivethirtyeight()




space_missions <- read_csv("Space_Corrected.csv") %>% 
  rename(Mission_Cost = Rocket) %>% 
  mutate(Datetime = as_datetime(as.POSIXct(Datum, format= "%a %b %d, %Y %H:%M UTC")))

graph_space_times<-space_missions %>% 
  mutate(Location = str_extract(Location, "(USA)|(Russia)")) %>% 
  filter(!is.na(Location)) %>% 
  count(Location, Day = wday(Datetime, label = TRUE), Month = month(Datetime, label = TRUE)) %>% # Lable + TRUE means getting actual name of the day not just its number, wday menas day of the week function from lubridate
 filter(!is.na(Day), !is.na(Month)) %>% 
  ggplot(aes(x=Day, y=Month, fill=n)) + # bcz this is heatmap so fill = n (number of occurences) 
  geom_tile() + # For heatmap we use geom_tile() 
  facet_grid(~Location) + # Use to get Two graphs (Russia and of USA) side by side
  theme_minimal() +
  scale_fill_gradient(low="black", high = "#8de1f0") +
  labs(title= "Times of Space Mission") +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor= element_blank(),
        text= element_text(family = "DM Sans"),
        plot.title = element_text(hjust = 0.5),
        legend.position = "none")

#plotly
ggplotly(graph_space_times)

graph_space_times_plotly <- ggplotly(graph_space_times)


library(htmlwidgets)


# Graph in html file in directory
saveWidget(graph_space_times_plotly, "space_times.html")

















