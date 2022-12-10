

# Accessing mySQL through R
library(DBI) # Contain different functions for interacting and queruing with db

connection <- dbConnect(RMySQL::MySQL(),
                        dbname="tweater",
                        host="courses.csrrinzqubik.us-east-1.rds.amazonaws.com",
                        port=3306,
                        user="student",
                        password="datacamp")

# to list table in connection db

dbListTables(connection)

users <- dbReadTable(connection, "users") # only reading users table


print(users)

# Within dbGetQuery u can write any SQL Query

dbGetQuery(connection, "select name from users")




# Clear the result
dbClearResult(res)

# Dont Forget to close your connection
# Disconnect from the database
dbDisconnect(con)
