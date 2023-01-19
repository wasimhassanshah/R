
library(data.table)
library(dplyr)

# dplyr vs data.table

library(data.table)
library(dplyr)



# Changing column classes in data.table


data <- data.table(x1 = 1:5,
                    x2 = letters[6:2],
                    x3 = 9:5)


data


sapply(data, class) # shows class of each vector


data_new1 <- data[ , x1 := as.character(x1)] # Convert one column x1

 

sapply(data_new1, class) 


change_columns <- c("x1", "x3") # Specify columns to change

data_new2 <- data



# .SD is a symbol representing each group

data_new2[ ,
           (change_columns) := lapply(.SD, as.character),
           .SDcols = change_columns]

sapply(data_new2, class)





# Selecting top N highest values by group

data <- data.frame(group = rep(letters[1:3], each =5),
                   value = 1:15)
data


#dplyr
data_new2 <- data %>%   # Top N highest value by group
  arrange(desc(value)) %>% 
  group_by(group) %>% 
  slice(1:3)

data_new2


# with data.table

data_new3 <- data[order(data$value, decreasing = TRUE), ] # Top N highest value by group

data_new3 <- data.table(data_new3, key = "group")

data_new3 <- data_new3[ , head(.SD, 3), by = group]

data_new3





# Use previous row of data.table in R : shift function and get values


data <- data.table(x1 = 1:5,
                   x2 = 7:3,
                   x3 = "x")

data


data[ , lag1 := x1 * shift(x2)]  #use previous row value of x2 * x1
data


data[ , lag3 := x1 * shift(x2, 3, type = "lag")] # Use three row before

data



# Summarize Multiple Columns of data.table by Group in R

data <- data.table(x1 = 1:12,
                   x2 = 11:22,
                   group = rep(letters[1:3], each = 4))

data

data_group <- data[ , lapply(.SD, mean), by = group] # Summarize by group

data_group





# dplyr vs data.table syntax equvalence

mydt[, .N, ..(Hobbyist, OpenSourcer)] # two dots (..) one dot moves u up one directory. Here , u r moving up one namespace from environment inside data.table brackets up to the global environment
[order(Hobbyist, -N)] # Read as: For all rows,  count number of rows grouped by Hobbyist and OpenSourcer and then order first by Hobbyist and then by number of rows descending


#above is equivalent to below dplyr code

mydf %>% 
  count(Hobbyist, OpenSourcer) %>% 
  order(Hobbyist, -n)



# ifelse

dt1[ , RUser := ifelse(LanguageWorkedWith %like% "\\bR\\b", TRUE, FALSE)] # Creating RUser column where R word is TRUE or FALSE

#%chin%

rareos <- dt1[OpernSOurcer %chin% c("Never", "Less than once per year")] # %chin% is for character vectors not for numbers



#fcase is like case_when() of dplyr



usd[ , Language: fcase(          # Creating Language variable with 4 conditions
  RUSER & !PythonUser, "R",
  PythonUser & !RUser, "Python",
  PythonUser & RUser, "Both",
  !PythonUser & !RUser, "Neither"
)]








































































