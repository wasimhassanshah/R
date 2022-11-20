library(tidyverse)
library(data.table)

# setnames Function of data.table 

x <- 1:5                                    # Create example vector
x                                           # Print example vector to RStudio console

x_names <- setNames(x, letters[1:5])        # Apply setNames function
x_names                                     # Print updated vector to RStudio console

install.packages("data.table")              # Install data.table package
library("data.table")                       # Load data.table package

data <- data.frame(x1 = 1:5,                # Create example data.frame
                   x2 = 6:10,
                   x3 = 11:15)
data                                        # Print example data.frame to RStudio console

setnames(data,                              # Apply setnames function
         c("x1", "x3"), # changing names of x1 and x3 as x4 and x5 respectively
         c("x4", "x5"))
data                                        # Print updated example data.frame






# Sort Data Frame in R 


data <- data.frame(x1 = 1:5,                         # Create example data
                   x2 = c("A", "D", "C", "A", "d"))

##### Example 1 - order function
data[order(data$x2), ]                               # Order data with Base R

##### Example 2 - dplyr package
                                    # Load dplyr R package

arrange(data, x2)                                    # Order data with dplyr

##### Example 3 - data.table package

data_ordered <- data                                 # Replicate example data
setorder(data_ordered, x2)                           # Order data with data.table
data_ordered                                         # Print ordered data

##### Example 4 Sort in decreasing order
data[order(data$x2, decreasing = TRUE), ]            # Order data in decreasing order



# Select Row with Maximum or Minimum Value in Each Group



data <- data.frame(x = 1:10,                    # Create example data
                   group = c(rep("A", 2),
                             rep("B", 3),
                             rep("C", 5)))

                              # Load dplyr package

data %>% group_by(group) %>% top_n(1, x)        # Apply dplyr functions
                                  # top_n function to extract max value row

# Please note that top_n has been superseded in favor of slice_min()/slice_max(). The following R code should therefore be preferred:
  
  
  data %>% group_by(group) %>% slice_max(n = 1, x)

# data table
setDT(data)[ , .SD[which.max(x)], by = group]   # Apply data.table functions

setDT(data)[ , .SD[which.min(x)], by = group]   # Min of groups


# Convert Row Names into Data Frame Column in R


# Append data.table to Another in R


data1 <- data.table(x1 = 1:5,                   # Create first data.table
                    x2 = letters[1:5],
                    x3 = 3)
data1                                           # Print first data.table

data2 <- data.table(x1 = 11:15,                 # Create second data.table
                    x2 = letters[11:15],
                    x3 = 33)
data2                                           # Print second data.table

data_concat <- rbindlist(list(data1, data2))    # Rbind data.tables
data_concat                                     # Print combined data.table


# Remove Data Frame Columns by Name in R

data <- data.frame(x1 = 1:5,                        # Create example data
                   x2 = 6:10,
                   x3 = letters[1:5],
                   x4 = letters[6:10])

data1 <- data[ , ! names(data) %in% c("x1", "x3")]  # Apply %in%-operator

data2 <- data[ , names(data) %in% c("x2", "x4")]    # Keep certain variables

data3 <- subset(data, select = - c(x1, x3))         # Apply subset function

data4 <- within(data, rm(x1, x3))                   # Apply within function


data5 <- select(data, - c(x1, x3))                  # Apply select function


data6 <- data
setDT(data6)[ , c("x1", "x3") := NULL]              # Using := NULL

class(data6)                                        # Check class of data




























