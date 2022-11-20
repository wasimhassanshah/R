 # Data manipulation using data.tables
library(data.table)
library(hflights)

View(hflights)

# Converting dataset into data table to use this library

hflights <- as.data.table(hflights)

class(hflights)


# Data Selection


hflights[1:3, c("ArrDelay", "DepDelay")] # through data.fram way

hflights[1:3, list(ArrDelay, DepDelay)] # through data.table way


# Select multiple columns using . operation

hflights[1:3, .(ArrDelay, DepDelay)] # through data.table way




# Data Filtration

head(hflights[hflights$ArrDelay >= 45, Origin]) # through data.frame way

head(hflights[ArrDelay>=45, Origin]) # through data.tables way

 

# Removing NA Values


head(hflights[!is.na(hflights$ArrDelay), "ArrDelay"]) # data.frame way


head(hflights[, na.omit(ArrDelay)]) #data.table way


# Add new column

# := help in creating new column in data.tables

hflights_total_delay <- hflights[, total_delay := ArrDelay +DepDelay]

head(hflights_total_delay)

# print columns where total_delay >= 80 only 5 rows
head(hflights_total_delay[total_delay>=80, ], 5)

# Remove Columns

hflights_total_delay [ , total_delay := NULL] # removing total_delay column



# Copy entire table


copied_new_data <- copy(hflights_total_delay)


#Select last flight in the dataset


hflights[.N, ] # select the last index of the row



# Data Aggregation


# Mean Arrival delay of month

hflights[, mean(na.omit(ArrDelay)), by = Month]

# mean delay of unique carriers by month


shorted_mean_delay_by_month <- hflights[,.(mean_delay = mean(na.omit((ArrDelay+DepDelay))),
                                        N_UniqueCarrier = length(unique(UniqueCarrier))),
                                        by = month]



# Left and Right Join


x <- data.table(colour = c("red", "green", "black", num=1:3))
y <- data.table(colour = c("red", "green", "orange"), size= c("small", "Medium", "Large"))

# Keep left dataset constant and try to find match with y
left_join <-merge(x,y, by = "colour", all.x = TRUE) # joining on left data set by color colum
# all.x True means it will hel x dataset constant
left_join



right_join <- merge(x,y, by= "colour", all.y = TRUE)
right_join


full_outer_join <-merge(x,y, by ="colour", all= TRUE)

full_outer_join










































