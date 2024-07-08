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
library(kableExtra)
library(mailR)
source("/data/balerion_home_balaj.khalid/intraday_btnh/config_funcs.R")
setwd("/data/balerion_home_balaj.khalid/General")

#### DB Connections ####

gp.credentials <- data.table(
  conn_name = "gp",
  user = 'u_tfnspain_aai_ai_user',
  password = "3dC$00@Lhia7a",
  db_name = "gpafiniti",
  db_host = 'GPDB',
  db_port = 55432)

ai.credentials <- data.table(
  conn_name = "ai",
  user = 'tfnspain_aai_ai_user',
  password = 'At6$a9Us3R',
  db_name = 'smexplorerdata',
  db_host = '10.133.129.137',
  db_port = 3307)

prod.credentials <- data.table(
  conn_name = "ai",
  user = 'tefp_ai_red_user',
  password = 'W!zb3lL2021',
  db_name = 'afiniti',
  db_host = '10.133.129.133',
  db_port = 3307)

#### Data Queries ####

query <- "select a.modelunit_id, a.modelunit_name, a.call_diagonal_model_id, b.callgroup_id, b.min_percentile, b.max_percentile
from afiniti.call_diagonal_model b
left join (select modelunit_id, modelunit_name, call_diagonal_model_id 
from afiniti.modelunit 
where modelunit_id in (select distinct modelunit_id from afiniti.activemodelunits 
where active_datetime = (select max(active_datetime) from afiniti.activemodelunits))
and modelunit_name like '%Child'
and modelunit_name not like '%Portados%') a
on a.call_diagonal_model_id = b.call_diagonal_model_id
where modelunit_id is not null
and callgroup_id <> -1;"

query_arch <- "with skill_in_scope as (
select queue_name, skill
from de_afiniti.skills_in_scope 
where end_datetime = '2099-12-31 23:59:59.000'
and in_scope = 1),
eval_summary as (
select call_time, queue_name, modelunit_id, callgroup, row_number() over (partition by call_guid order by batch_guid desc) as row_number
from afiniti.vw_eval_summary a
left join skill_in_scope b
on substring(a.call_type_string,4,4) = b.skill::text
where call_time > date(now())
and queue_name in ('OFERTA', 'ATENCION', 'RETENCION')
and callgroup > -1)
select date(a.call_time) as date, a.queue_name, modelunit_id, callgroup, count(*) as calls
from eval_summary a
group by 1,2,3,4
order by 1,2,3,4;"

#### Data Fetch ####

prod_data <- ExtractDataFromMySQLDatabase(prod.credentials, conn.name = "ai", query, data.description = "raw data", cores = 100L)

ai_data <- ExtractDataFromMySQLDatabase(ai.credentials, conn.name = "ai", query, data.description = "raw data", cores = 100L)

arch_data <- ExtractDataFromMySQLDatabase(gp.credentials, conn.name = "gp", query_arch, data.description = "raw data", cores = 100L)

#### Preprocessing ####

arch_data[, total_calls := sum(ifelse(callgroup > -1, calls, 0)), .(date, queue_name, modelunit_id)]
arch_data[, new_bandwidth := calls/total_calls]

#### Joins ####

joined <- prod_data %>% left_join(ai_data, by = c("modelunit_id" = "modelunit_id", "callgroup_id" = "callgroup_id"), suffix = c('_prod', '_ai')) %>% setDT
joined_final <- arch_data %>% 
                left_join(joined[,c('modelunit_id', 'callgroup_id', 'min_percentile_prod', 'max_percentile_prod', 'min_percentile_ai', 'max_percentile_ai')],
                by = c("modelunit_id" = "modelunit_id", "callgroup" = "callgroup_id")) %>%  setDT

#### Runtime Percentile Calculation ####
joined_final2 <- list()

for (mu in (unique(joined_final$modelunit_id))){
  js <- joined_final[modelunit_id == mu,][order(min_percentile_prod)]
  js[, max_runtime := ifelse(zoo::rollapplyr(js$new_bandwidth, 1:nrow(js), sum, fill = 0, partial = T) >= 1, 1, zoo::rollapplyr(js$new_bandwidth, 1:nrow(js), sum, fill = 0, partial = T))]
  js[, min_runtime := ifelse((max_runtime - new_bandwidth) <= 0, 0, (max_runtime - new_bandwidth))]
  
  joined_final2 <- rbind(joined_final2, js)
}

#### Cumulative Graph ####
joined_final2[, runtime_bw := max_runtime - min_runtime]
joined_final2[, ai_bw := max_percentile_ai - min_percentile_ai]
joined_final2[, prod_bw := max_percentile_prod - min_percentile_prod]

joined_final3 <- list()

for (mu in (unique(joined_final2$modelunit_id))){
  js <- joined_final2[modelunit_id == mu,]
  js[, runtime := zoo::rollapplyr(js$runtime, 1:nrow(js), sum, fill = 0, partial = T)][order(min_runtime)]
  js[, ai := zoo::rollapplyr(js$ai, 1:nrow(js), sum, fill = 0, partial = T)][order(min_percentile_ai)]
  js[, prod := zoo::rollapplyr(js$prod, 1:nrow(js), sum, fill = 0, partial = T)][order(min_percentile_prod)]
  
  joined_final3 <- rbind(joined_final3, js)
}

#### Email Data Prep ####

final <- joined_final3[, c('date', 'queue_name', 'modelunit_id', 'callgroup',
                 'min_runtime', 'max_runtime', 'min_percentile_ai', 'max_percentile_ai', 'min_percentile_prod', 'max_percentile_prod',
                 'runtime_bw', 'ai_bw', 'prod_bw')]

# View(final)
final <- final %>% dplyr::rename(min_percentile_runtime = min_runtime, max_percentile_runtime = max_runtime)

final$min_percentile_runtime <- round(as.numeric(final$min_percentile_runtime),3)
final$max_percentile_runtime <- round(as.numeric(final$max_percentile_runtime),3)
final$min_percentile_ai <- round(as.numeric(final$min_percentile_ai),3)
final$max_percentile_ai <- round(as.numeric(final$max_percentile_ai),3)
final$min_percentile_prod <- round(as.numeric(final$min_percentile_prod),3)
final$max_percentile_prod <- round(as.numeric(final$max_percentile_prod),3)

final$runtime_bw <- round(as.numeric(100.0*final$runtime_bw),3)
final$ai_bw <- round(as.numeric(100.0*final$ai_bw),3)
final$prod_bw <- round(as.numeric(100.0*final$prod_bw),3)

final[, itr := paste0(queue_name, "_", modelunit_id)]

bw_list <- list()
graph_names <- list()

for (queue in c('ATENCION', 'RETENCION', 'OFERTA')){
  for (mu in unique(final[queue_name == queue, modelunit_id])){
    final_bw = final[queue_name == queue & modelunit_id == mu, c('date', 'queue_name', 'modelunit_id', 'callgroup',
                                            'min_percentile_ai', 'max_percentile_ai',
                                            'min_percentile_prod', 'max_percentile_prod',
                                            'min_percentile_runtime', 'max_percentile_runtime',
                                            'ai_bw', 'prod_bw','runtime_bw')]
    bw_list[[queue]]$mu = kable(final_bw, escape=FALSE) %>% kable_styling(full_width = F, bootstrap_options = 'bordered')%>% scroll_box(width='900px')

    bandwidth_long <- tidyr::gather(joined_final3[queue_name == queue & modelunit_id == mu], bandwidth, value, c(runtime, ai, prod), factor_key = T)

    ggsave(paste0(queue, "_", mu, "_bw.png"), ggplot(bandwidth_long, aes(x = reorder(callgroup, min_percentile_prod), y = value, color = bandwidth, group = bandwidth)) +
             geom_line() + geom_point() + xlab('Callgroup') + ylab('Bandwidth') + ggtitle(paste0(queue, " Model Unit: ", mu, " Bandwidths")) + 
             theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)), device = "png")
    graph_names <- c(graph_names, paste0("./", queue, "_", mu, "_bw.png"))  
  }
}

#### Email ####

sender <- 'TFN Spain Job Alerts<job-alerts@afiniti.com>'
# reciever_primary<-c("balaj.khalid@afiniti.com")
reciever_primary<-c("afiniti.ai.tde@afiniti.com")

send.mail(from = sender,
          to = reciever_primary,
          body=paste0("<style>\n    table{\n    width:100%;\n    border-collapse:collapse;\n    font-family: Helvetica, Arial, sans-serif;\n    background: #0033ffaa;\n    left-margin:auto;\n    right-margin:auto;\n    font-size: 12px;\n    }\n    td\n    {\n    padding:3px;\n    border:#000000 1px solid;\n    text-align: center !important;\n    font-size: 12px;\n    }\n    tr\n    {background:#ffffff;\n    color:#000066 !important; }\n    tr td:last-child {\n        width: 10%;\n        white-space: nowrap;\n    }\n    th\n    {background:#000000;\n    text-align: center !important;\n    font-weight: bold;\n    border:#ffffff 1px solid;\n    color: white;\n    font-size: 12px;}\n</style>"
                      ,"<head><h2>Model Bandwidth Alert</h2></head><body>",
                      "<br><br><h3>ATENCION</h3><br>", bw_list[["ATENCION"]],
                      "<br><br><h3>RETENCION</h3><br>", bw_list[["RETENCION"]],
                      "<br><br><h3>OFERTA</h3><br>", bw_list[["OFERTA"]],"</body>"),
          subject = paste0("TFN Spain | Model Bandwidth Alert | ",date()),
          attach.files = unlist(graph_names),
          authenticate =  FALSE,
          html = T,
          smtp = list(host.name = "185.81.190.149" , port = 25))

unlink(unlist(graph_names))

