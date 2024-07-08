rm(list = setdiff(ls(), c()))

library(tidyverse)
library(dplyr)
library(DBI)
library(tidyr)
library(RMySQL)
library(data.table)
library(stringr)
library(modelr)
library(scales)
library(knitr)
library(ggplot2)
library(lubridate)
library(rpart)
library(doParallel)
library(RPostgreSQL)

lapply(dbListConnections(MySQL()), dbDisconnect)
lapply(dbListConnections(PostgreSQL()), dbDisconnect)

params_user = 'u_tfnspain_ai_balaj'
params_pass = "JaL@45@#$"
params_host = '10.133.129.146'
params_port = 55432
params_database = "gpafiniti" 

ExtractDataFromMySQLDatabase <- function(db.credentials, conn.name, queries, data.description, cores = 10L){
  # Extracts data from mysql database
  # Args:
  #   db.credentials (data table): table containing database credentials with following columns (conn_name, user, 
  #                                password, db_name, db_host, db_port)
  #   conn.name (character string): name of database connection to use from db.credentials table
  #   query (character string): query which will be used to extract data
  #   data.description (character string): description of data
  # Returns:
  #   data (data table)
  registerDoParallel(cores = cores)
  message(paste0("PrepareData | ExtractDataFromMySQLDatabase will run on ", getDoParWorkers(), " cores"))
  data <- foreach(i = 1:length(queries), .combine = function(...) rbindlist(list(...)), .inorder = F, .multicombine = T,
                  .packages = c("data.table", "RMySQL") , .verbose = T) %dopar% {
                    if(conn.name != 'gp'){
                      db.conn <- dbConnect(MySQL(), user = db.credentials[conn_name == conn.name, user], password = db.credentials[conn_name == conn.name, password],
                                           dbname = db.credentials[conn_name == conn.name, db_name], host = db.credentials[conn_name == conn.name, db_host],
                                           port = db.credentials[conn_name == conn.name, db_port])
                    }else{
                      db.conn <- dbConnect(PostgreSQL(), user = db.credentials[conn_name == conn.name, user], password = db.credentials[conn_name == conn.name, password],
                                           dbname = db.credentials[conn_name == conn.name, db_name], host = db.credentials[conn_name == conn.name, db_host],
                                           port = db.credentials[conn_name == conn.name, db_port])
                    }
                    rs <- dbSendQuery(db.conn, queries[[i]])
                    data <- dbFetch(rs, n = -1)
                    dbClearResult(rs)
                    dbDisconnect(db.conn)
                    data <- as.data.table(data)
                    setnames(data, tolower(names(data)))
                  }
  message(paste0(data.description, "| data loaded from DB: ", nrow(data)))
  return(data)
}

### EVAL SUMMARY STATS ###

start.date <- as_date(Sys.Date()-10)
end.date <- as_date(Sys.Date()+1)

query <-  paste0( "SELECT date(call_time) as date, agent_id_string, count(*) as calls, sum(case when benchmark = 1 then 1 else 0 end) as on_calls,
                  sum(case when benchmark = 0 then 1 else 0 end) as off_calls, avg(case when benchmark = 0 then agent_percentile_actual end) as avg_off_ap
                   FROM afiniti.vw_eval_summary where call_time >= '", as_date(start.date), "' and call_time < '", as_date(end.date), "' 
                  and sensor_key = 'Retencion_Portados' group by 1,2 ;")


db.credentials <- data.table(
  conn_name = "gp",
  user = params_user,
  password = params_pass,
  db_name = params_database,
  db_host = params_host,
  db_port = params_port)

ag_stats <- ExtractDataFromMySQLDatabase(db.credentials, conn.name = "gp", query, data.description = "raw data", cores = 100L)

### AG Percentile/Rank from Model ###

query_model <-  paste0( "select * from afiniti.agent_diagonal_model where agent_diagonal_model_id = 195;")


db_ai.credentials <- data.table(
  conn_name = "mysql",
  user = 'tfnspain_aai_ai_user',
  password = 'At6$a9Us3R',
  db_name = 'afiniti',
  db_host = '10.133.129.137',
  db_port = 3307)

model_ranks <- ExtractDataFromMySQLDatabase(db_ai.credentials, conn.name = "mysql", query_model, data.description = "raw data", cores = 100L)

final_ag <- ag_stats %>% left_join(model_ranks, by = c("agent_id_string" = "agent_id"))

pivot <- final_ag %>% group_by(agent_id_string, date) %>% dplyr::summarize(calls = sum(calls), on_calls = sum(on_calls), off_calls = sum(off_calls),
                                                                           avg_off_ap = mean(avg_off_ap))
View(pivot)

