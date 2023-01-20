 # merge dataframes

 #Joins with R base, dplyr, data.table

#Joins R base merge function , 20 times slower then data.table for large datasets


joined_df <- merge(mydf, mylookupdf, by.x= "UniqueCarrier", by.y = "Code", all.x = TRUE, all.y + FALSE)


# dplyr joins , faster way then base R

left_join(df1, df2, by = c("df1col" = "df2col")) # if columns dont have same name use by argument # if columns names same exclude by argument



joined_tibble <- left_join(mytibble, mylookup_tibble, by = c("UniqueCarrier" = "Code"))

glimpse(joined_tibble)


# data.table join way, the fastest way

#fread create the data.table object


mydt<- fread("abc.csv")

mylookup_dt <- fread("xyz.csv")

#Way 1 is same as base R merge function


joined_dt1 <- merge(mydt, mylookup_dt, by.x= "UniqueCarrier", by.y = "Code", all.x = TRUE, all.y + FALSE)


# Way2 with separate setkey function

setkey(mydt, "UniqueCarrier")
setkey(mylookup_dt, "Code")
joined_dt2 <- mylookup_dt[mydt]


#Way 3, without key function and with on argument

joined_dt3 <- mylookup_dt[mydt, on = c(Code = "UniqueCarrier")]













































