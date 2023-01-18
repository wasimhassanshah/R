

library(tidyverse)

billboard<- read_csv("billboard100.csv")



library(lubridate)

library(stringr)

# Clean date column

billboard2<-billboard %>% 
  mutate(month = as_date(floor_date(date, "month")))


class(billboard$date)

names(billboard)


# Analysis of the popularity of top_5 song genres with time

mtv_data = read_csv("MTV.csv")

top_5_genres <- billboard %>% 
  inner_join(mtv_data, by = c("artist" = "name")) %>% 
  select(song, artist, genre) %>% 
  filter(!is.na(genre)) %>% 
  distinct() %>% count(genre) %>% 
  top_n(5) %>% 
  arrange(desc(n)) %>% 
  pull(genre)  # Pull give vector of top 5 genre names

select()
# Popularity Analysis of top 5 genres from 1960 to 2020


billboard %>% 
  inner_join(mtv_data, by = c("artist" = "name")) %>% 
  mutate(date= floor_date(date, unit ="year")) %>%  # data looks pretty messy so it is better to aggregate the data by either month or year
  select(date, song, genre) %>%                      # unit = year means take one point for year by aggregating all 12 months , so it will clear noise (messy thing) in data
  filter(genre %in% top_5_genres) %>%               # basically we are making scale wide to make graph readable
  count(date, genre) %>% #datewise , genre count
  ggplot(aes(x=date, y=n, color=genre)) +geom_line()   





















































