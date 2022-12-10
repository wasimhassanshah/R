# DBI, RSQLite, dbplyr install them first , dbplyr= to work with dplyr functions in db
# Load of querying will be on database

library(DBI)
library(RSQLite)
library(dplyr)

# Introduction & Connecting To Databases
# making our connection object namely  portadb 
portaldb <- dbConnect(SQLite(), #connector function
               "C:/Users/HP/Downloads/archive (2)/portal_mammals.sqlite" #path
               )  # Connected to database

 
# portaldb <- dbConnect(RSQLite::SQLite(), "portal.sqlite") # Here :: means load SQLite()  function from RSQLite
 
dbListTables(portaldb) # gives number of tables

#Details of each table

dbListFields(portaldb, "plots") #plots table columns

# Direct connection to these individual tables with TBL command from dplyr


survey <- tbl(portaldb, "surveys") # surveys in name of table

survey # gives us tibble of surveys table connection with databas


# Bringing whole table in R using Collect function\

surveys_df <-collect(survey) # this will go into database and pull all of the data from it into R as dataframe


View(surveys_df) 






# Interacting database with R based on Queries 
# By writing down queries as string

# Counting number of individuals associated with species id from portal dataset
count_query <- "SELECT species_id, COUNT(*)
                FROM surveys
                GROUP BY species_id"  # COUNT(*) count each row associated with species id
# Now this query is stored in string count_query

# To run that query we have multiple options 
# With DBI pkg functions


dbGetQuery(portaldb,count_query)  #(connection, SQL statement)
 # That query will run in the database
 # and it will return df in R give number of rows

# With tbl function

tbl(portaldb, sql(count_query))
# Tbl leaves the resulting table still in the database
# it doesnt know how many rows there are

# to get it in R we use collect function of dplyr 

count_data <- tbl(portaldb, sql(count_query)) %>%
  collect()


# Below is Using dplyr to run commands inside the database


surveys <-tbl(portaldb, "surveys")

species_count <- surveys %>% 
  group_by(species_id) %>% 
  summarize(count = n()) %>% # to create count col which count of the number of rows of species id with n( ) function
  collect() # Resulting data is still in databse to bring it in R add collect function



species_count


# All of this work is actually happening in the database by using dplyr in R




# Below is the method to write back result that is generated in R back to Database

# Writing species_count result from R to DB as a permanent table
# We have ony plots, species, surveys tables as yet in the portaldb

dbListTables(portaldb) 


# To store a copy of our species_count data frame in the database we use the copy_to() function
# And a copy_to function takes arguments as copy_to(connection, table_to_be_copied_in_DB, temporary = FALSE) 
# temporary = FALSE means permanently store this table in DB

copy_to(portaldb, species_count, temporary = FALSE)


dbListTables(portaldb) 
# Now we can see that we have species_count table in portaldb


# dplyr and SQL Queries Comparison/Validation










