

#Function, Loops and apply

library(tidyverse)

dataset <- mtcars



names(mtcars)

#creating function to standardise cariable (Z-score computation)


standardise <- function(x){  # x is a variable to be passed
  y<- (x-mean(x))/sd(x)
  return(y)
  
}

dataset$Zdisp <- standardise(dataset$disp) # calculationg Z score of variable disp using standardise function

dataset$Zhp <- standardise(dataset$hp)

dataset$Zdrat <- standardise(dataset$drat)


# For loops

dataset2 <-  dataset %>% 
  select(disp, hp, drat, wt, qsec, Zdisp, Zhp, Zdrat)

dataset2 %>%  view


# Using for loop to compute mean of all columns of dataset2 and storing it in a vector ColMeans

ColMeans <- vector(length = ncol(dataset2)) # ColMeans is a vector of length ncol(dataset2)


for(i in 1: ncol(dataset2)){
  ColMeans[i] = mean(dataset2[,i])
  
}


ColMeans



# Nested loop 

emptyMatrix <- matrix(0, nrow = 5, ncol = 5) # matrix of 5*5 having 0 values

#Nested loop to fill emptyMatrix wil row,col index values

for(i in 1:nrow(emptyMatrix)){  #Row wise running of first loop
  for(j in 1:ncol(emptyMatrix)){  # Column wise running of 2nd matrix
    
    emptyMatrix[i, j] <- paste0(i, ",", j)
    
    
    
  }
  
}


emptyMatrix


# While loop

stock <- 300

days <-1

set.seed(555) # random seeed for reproducibility purpose

# To see in how many days stock will cross 350 value
while(stock < 350) {
  stock <- stock + runif(1, -5, 20) # add random noise - generate from a Unifrom(-5, 20) distribution
  days <- days + 1
  print(days)
  
  
}

stock


# Ifelse statement

Zhp <-dataset$Zhp

HP_aboveAvergae <- ifelse(Zhp >= 0, TRUE, FALSE) # If Zhp >= 0 then TRUE else FALSE


HP_df <-data.frame(Zhp = Zhp, HP_aboveAvergae = HP_aboveAvergae)

HP_df


# Apply family to replace for loop, they are faster then loops and syntax simpler


dataset


 # Read as : Apply mean function over the columns of dataset
apply(dataset, 2, mean)  # !st argument is dataframe
                          # second argument 2 is margin either rows (for rows put 1) or columns (for columns put 2)
                         # 3rd argument is a function we want to apply over that margin


# Above apply code is equivalent to following for loop code
#   ColMeans <- vector(length = ncol(dataset2)) # ColMeans is a vector of length ncol(dataset2)
# 
# 
# for(i in 1: ncol(dataset2)){
#   ColMeans[i] = mean(dataset2[,i])
#   
# }
# 
# 



# lapply

x<- list( a = 1:5, beta = exp(-3:3), logic = c(TRUE, FALSE, FALSE, TRUE)) #Created list
#having alpha , beta and logic elements


lapply(x, mean) #lapply applied mean function to each element of the list



#applying quantile function to lapply

lapply(x, quantile, probs = 1:3/4)


#sapply

sapply(x, mean) # sapply output either retun a matrix or vector 
# Clickung on f2 can open how sapply function is written
# Or place cursor on function and press ctrl and click the function

sapply(x, quantile, probs=1:3/4)


# SAPPLY() example based on first function

Zmatrix <- sapply(dataset[, c("disp", "hp", "drat")], standardise) # Applying standardise function to 3 variables of dataset

Zscores <- data.frame(Zmatrix) # Converting Zmatrix into data.frame

colnames(Zscores) <- c("Zdisp", "Zhp", "Zdrat") # Giving new colnames to Zscores columns

Zscores














































































