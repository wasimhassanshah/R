
# Creating Data Frame 

title <- c("Star Wars", "The EMpire Strikes Back", "Return of the Jedi", "The phantom Menace",
           "Attack of the Clones", "Revenge of the Sith", "The Forcce Awakens")
year <- c(1977, 1980, 1983, 1999, 2002, 2005, 2015)
length.min <- c(121, 124, 133, 142, 140, 135, 143)
 box.office.mil <- c(787, 534, 572, 1027, 657, 849, 2059)
 my.data <- data.frame(title, year, length.min, box.office.mil)
 my.data
 
 # Renaming dataframe  columns
 names(my.data)  <- c("Movie Title", "Release Year", " Length in Minutes", "Box Office")
 
 my.data <- data.frame (Title = title, Year = year, Length =length.min, Gross = box.office.mil)
 my.data
?data.frame 

 write.csv( my.data, file="MyFirstDF.csv", row.names = FALSE)
 
 
 # geting working directory 
 library(tidyverse) 
getwd()





 
 
# Loading data csv through read.table

my.pok <- read.table("pokRdex-comma.csv",
                     sep = ',', # How to structure a data
                     header = TRUE,
                     stringsAsFactors = FALSE)

my.pok 

# Loading data csv through read.csv

 my.pak <- read.csv("pokRdex-comma.csv", header = TRUE, sep= ","
                    )
class(my.pak)
str(my.pak)
head(my.pak)


my.prk <- read.delim("pokRdex-tab.txt", header = TRUE, sep= "/t"
)
class(my.pak)

# knowing your data
nrow(my.pok)
ncol(my.pok)

colnames(my.pak)


str(my.pok)
summary(my.pok)


starwars
class(starwars)
my.wars <- as.data.frame(starwars)

class(my.wars)

my.wars <- my.wars[, -(11:13)]
my.wars
head(my.wars)
tail(my.wars)
my.wars[3,9]
my.wars[3,"homeworld"]

head(my.wars)
head(my.wars[ ,1])
head(my.wars[["name"]])
head(my.wars$name)

my.wars[c(1:14), c("name","homeworld", "gender")]

my.data

## Adding columns

mark <- c(37.5, 34.75, 34.25, 0, 0, 0.75, 0)
carrie <- c(13.5, 22.75, 21.25,0, 0, 0.5, 5.75)
my.data$MarkScreenTime <- mark
my.data$CarrieScreenTime <- carrie
my.data


my.data$MarkScreenTime <- NULL
my.data$CarrieScreenTime <- NULL
my.data


my.data <- cbind(my.data, MarkScreenTime = mark, CarrieScreenTime = carrie)
my.data


# Dealing NA
is.na(my.wars)

any(is.na(my.wars))
my.wars$height[is.na(my.wars$height)]<- median(my.wars$height, na.rm= T)
my.wars$height  
head(my.wars)
colnames(my.wars)
my.wars$height 



# Manipulating data with dplyr


star <- starwars
star
view(star)
filter(star, species == "Droid", homeworld =="Tatooine")

star.eyecolor <- filter(star, eye_color == "red" | eye_color == "yellow", eye_color == "orange" )



star.eyecolor 

select(star, birth_year, homeworld, species, starships)

select(star, ends_with("color"))

select(star, name, vehicles, starships, everything())
 
star <- mutate(star, bmi = mass/((height/100)^2))
 select(star, name:bmi)

 star.trans <- transmute(star, bmi2=mass/((height/100)^2) )

 star.trans
 
 
 
 arrange(star, mass)
 
 arrange(star, desc(mass))
 
summarize(star, avg.height = mean(height, na.rm =T))
 
 
star.species <- group_by(star, species)
summarize(star.species, avg.height = mean(height, na.rm = T))
 
sample_n(star, 10) # 10 rows od data

sample_frac(star, 0.1) # 10 percent od data

# R's Pipe Operator


star %>%
  group_by(species) %>%
  summarize(count = n(), mass = mean(mass, na.rm= T)) %>%
  filter(count>1)
 

# Tidy data for data cleaning

billboard <- read.csv("billboard.csv", header = TRUE, sep= ",")
billboard <- as_tibble(billboard)
billboard


billboard.gahered <- billboard %>% gather(x1st.week:x76th.week, key = "week",
                      value ="rank", na.rm = T) %>%
   arrange(artist.inverted)


billboard.separated <- billboard.gahered %>% separate(week, into = c("Num","unit"))
   
 
billboard.separated 
 