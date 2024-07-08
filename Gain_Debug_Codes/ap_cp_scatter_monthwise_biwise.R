library(DBI) 
library(dplyr)
library(tidyr)
library(ggplot2)
library(gridExtra)
library(RMySQL)
library(RPostgreSQL)
library(data.table)
library(stringr)
library(modelr)
library(scales)
library(knitr)
library(kableExtra)
library(lubridate)
library(RColorBrewer)
library(plotly)
library(shiny)
library(parallel)
library(foreach)
library(doParallel)
library(stringr)
source('/data/balerion_home_balaj.khalid/intraday_btnh/config_funcs.R')

params_user = 'tfnspain_aai_ai_user'
params_pass = "At6$a9Us3R"
params_host = '10.133.129.137'
params_port = 3307
params_database = "smexplorerdata" 

#### SME #####

start.date <- as_date('2023-02-01')
end.date <- as_date('2023-04-01')

queries <- list()

i <- 1
jump <- 1
s.date <- start.date

while(s.date < end.date) {
  e.date <- ifelse(as_date(s.date + jump) > end.date, end.date, s.date + jump)
  print(paste(i, s.date, as_date(e.date)))
  
  queries[i] <-  paste0("select calltime, call_key, bi_flag, on_off, 
                        eval_agent_percentile_actual, eval_call_percentile_actual, eval_eval_score_actual
                        from smexplorerdata.sme_ai_oferta_vw
                        where calltime > '", as_date(s.date) , "'and calltime < '", as_date(e.date), "' and
                        queue_name_skill_new = 'OFERTA'
                        and inscope_call = 1 and ca_tiempo_conversacion  > 0 and is_inbound = 1 and agentid != 'N/D' ;")
  i <- i + 1
  s.date <- as_date(s.date + jump)
}

db.credentials <- data.table(
  conn_name = "ai",
  user = params_user,
  password = params_pass,
  db_name = params_database,
  db_host = params_host,
  db_port = params_port)

sme <- ExtractDataFromMySQLDatabase(db.credentials, conn.name = "ai", queries, data.description = "raw data", cores = 100L)

sme$calltime <- as.POSIXct(sme$calltime)
sme$eval_agent_percentile_actual <- as.numeric(sme$eval_agent_percentile_actual)
sme$eval_call_percentile_actual <- as.numeric(sme$eval_call_percentile_actual)
sme$eval_eval_score_actual <- as.numeric(sme$eval_eval_score_actual)
sme[, calltimedt := date(calltime)]
sme[, month := month(calltime)]
sme[, month := month.name[month]]
sme[, week := week(calltime)]
sme[, ap_actual_floor := floor(eval_agent_percentile_actual * 10000) + 1]

sme_grouped_on <- sme %>% filter(on_off == 1) %>% group_by(month, bi_flag, ap_actual_floor) %>%
  summarize(ap_actual = mean(eval_agent_percentile_actual), cp_actual = mean(eval_call_percentile_actual),
            calls = n()) %>% setDT

ggplotly(ggplot(sme_grouped_on[calls > 5,], aes(ap_actual, cp_actual)) + geom_point()
         + facet_grid(rows = vars(bi_flag), cols = vars(month))
         + xlab('agent percentile actual') + ylab('call percentile actual') + ggtitle('Monthwise BIwise AP/CP Scatter Plot | Afiniti On'))

sme_grouped_off <- sme %>% filter(on_off == 0) %>% group_by(month, bi_flag, ap_actual_floor) %>%
  summarize(ap_actual = mean(eval_agent_percentile_actual), cp_actual = mean(eval_call_percentile_actual), calls = n()) %>% setDT

ggplotly(ggplot(sme_grouped_off[calls > 5,], aes(ap_actual, cp_actual)) + geom_point()
         + facet_grid(rows = vars(bi_flag), cols = vars(month))
         + xlab('agent percentile actual') + ylab('call percentile actual') + ggtitle('Monthwise BIwise AP/CP Scatter Plot | Afiniti Off'))

sme_grouped_overall <- sme %>% group_by(month, bi_flag, ap_actual_floor) %>%
  summarize(ap_actual = mean(eval_agent_percentile_actual), cp_actual = mean(eval_call_percentile_actual), calls = n()) %>% setDT

ggplotly(ggplot(sme_grouped_overall[calls > 5,], aes(ap_actual, cp_actual)) + geom_point()
         + facet_grid(rows = vars(bi_flag), cols = vars(month))
         + xlab('agent percentile actual') + ylab('call percentile actual') + ggtitle('Monthwise BIwise AP/CP Scatter Plot Overall'))

eval_grouped <- sme %>% group_by(month, bi_flag, on_off) %>% 
  summarize(eval_score = mean(eval_eval_score_actual, na.rm = T), calls = n())



