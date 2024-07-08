######## 1 Model Configuration ########

# This section setups directory structure and loads packages and balerion functions.

rm(list = setdiff(ls(), c()))

#### 1.1 Loading Libraries ####

library(data.table)
library(RMySQL)
library(rpart)
library(stringr)
library(ggplot2)
library(rstan)
library(plyr)
library(tictoc)
library(scales)
library(doParallel)
library(lubridate)
library(bayesplot)

options(mc.cores = parallel::detectCores()) # rstan config
rstan_options(auto_write = T) # rstan config

setDTthreads(threads = parallel::detectCores()/4) # threads to use for data.table

#### 1.2 Configuration ####

model.settings <- list()
model.settings$user <- "balaj" # Your user name
model.settings$client.name <- "TEF Spain" # This is the name of the client which is used for logging purposes.
model.settings$queue.name <- "Retention" # This should match one of the queues used in balerion.home/balerion_config.txt.
model.settings$model.name <- "Retencion_Portados" # This should match one of the model names used in balerion.home/balerion_config.txt under above given queue.
model.settings$model.number <- "908_fhbh" #This is the id number of this specific model. Use a unique number for each model under same queue.name and model.name.
model.settings$balerion.home <- "/data/balerion_home_balaj.khalid/home_balerion"
setwd(paste0(model.settings$balerion.home, "/balerion_models/", model.settings$queue.name, "/",model.settings$model.name))
model.settings$location <- paste0("./models/", model.settings$model.number)
model.settings$data.location <- paste0("./models/", model.settings$model.number, "/data/")
model.settings$callgroups.location <- paste0("./models/", model.settings$model.number, "/callgroups/")
dir.create(model.settings$location)
dir.create(model.settings$data.location)
dir.create(model.settings$callgroups.location)

source("./config/config.R")
source(paste0(model.settings$balerion.home, "/balerion/src/main/R/prepare_data.R"))
source(paste0(model.settings$balerion.home, "/balerion/src/main/R/extract_parameters_copy.R"))
source(paste0(model.settings$balerion.home, "/balerion/src/main/R/estimate_model_diff.R"))
source(paste0(model.settings$balerion.home, "/balerion/src/main/R/process_model.R"))
source(paste0(model.settings$balerion.home, "/balerion/src/main/R/repercentile.R"))
source(paste0(model.settings$balerion.home, "/balerion/src/main/R/run_validation.R"))
source(paste0(model.settings$balerion.home, "/balerion/src/main/R/deploy_model.R"))
source(paste0(model.settings$balerion.home, "/balerion/src/main/R/utilities_ob.R"))

######## 2 Data Prep ########

######## 2.1 Data Configuration ####

######## select ####
data.config <- list()
data.config$select.query <- paste0(
  "select calltime,
  date(calltime) as calltimedt,
  co_matricula_ic as  agentid,
  call_key as callid,
  ca_tiempo_conversacion as aht,
  co_skill as  skill,
  on_off
  , movement_factor
  , ap_actual_eval
  , cp_actual_eval
  , precio_change_crm_7
  , precio_change_crm_15
  , precio_change_crm
  , precio_change_final
  from  sme_ai_portados")

# This stores all the db credentials for database in one data table.
data.config$db.credentials <- data.table(
  conn_name = c("ai", "arch", "prod", "prod_lookup"),
  user = c(ai.db.user, arch.db.user, prod.db.user, prod.lookup.db.user),
  password = c(ai.db.password,  arch.db.password, prod.db.password, prod.lookup.db.password),
  db_name = c(ai.db.name,  arch.db.name, prod.db.name, prod.lookup.db.name),
  db_host = c(ai.db.host, arch.db.host, prod.db.host, prod.lookup.db.host),
  db_port = c(ai.db.port, arch.db.port, prod.db.port, prod.lookup.db.port))
####### dates #########
data.config$start.date <- as.Date('2022-10-01')
data.config$end.date <- as.Date('2022-11-11')
data.config$queries <- list()
####### where #########
i <- 1
jump <- 1
s.date <- data.config$start.date
while(s.date < data.config$end.date) {
  e.date <- ifelse(as_date(s.date + jump) > data.config$end.date, data.config$end.date, s.date + jump)
  print(paste(i, s.date, as_date(e.date)))
  data.config$queries[i] <- with(data.config, 
                                 paste0(select.query, " where calltime >= '", 
                                        as_date(s.date), "' and calltime < '", as_date(e.date), "'",
                                        "and is_inbound = 1 
                                        and inscope_call = 1 
                                        and ca_atendidas_entrantes = 1 
                                        and ca_tiempo_conversacion > 0 
                                        and queue_name_skill_new = 'RETENCION PORTADOS' and co_skill in ('4358','4359','4357')
                                        ;"))
  i <- i + 1
  s.date <- as_date(s.date + jump)
}

# A data dictionary view can also be created on the AI server if desired.
data.config$dictionary <- read.csv("/data/balerion_home_balaj.khalid/General/FHBH/dict_fhbh.csv") %>% setDT
data.config$dictionary[, column_name := tolower(column_name)]

#### 2.2 Data Extraction ####
complete.data <- with(data.config, ExtractDataFromMySQLDatabase(db.credentials, 
                                                                conn.name = "ai", 
                                                                queries, 
                                                                data.description = "raw data", 
                                                                cores = 20L))

nrow(complete.data)

# complete.data <- complete.data %>% filter(on_off == 0)

total_disp_30<-sum(ifelse(complete.data$precio_change_crm!=0,1,0))
total_disp_3<-sum(ifelse(complete.data$precio_change_crm_3!=0,1,0))
total_disp_7<-sum(ifelse(complete.data$precio_change_crm_7!=0,1,0))
total_disp_15<-sum(ifelse(complete.data$precio_change_crm_15!=0,1,0))
total_disp_final<-sum(ifelse(complete.data$precio_change_final!=0,1,0))
disp_deacts <- sum(ifelse((complete.data$movement_factor == 'ClientDeactivation' | complete.data$movement_factor == 'AccessDeactivation' 
                           | complete.data == 'Downgrade') & complete.data$precio_change_crm != 0, 1,0))
# View(complete.data[,.(calls=.N,
#                  percentage_of_calls=round(.N*100/nrow(complete.data),2),
#                  percentage_of_disp_30=round(sum(ifelse(precio_change_crm!=0,1,0))*100/total_disp_30,2),
#                  percentage_of_disp_7=round(sum(ifelse(precio_change_crm_7!=0,1,0))*100/total_disp_7,2),
#                  percentage_of_disp_outcomes=round(sum(ifelse(precio_change_final!=0,1,0))*100/total_disp_final,2),
#                  precio_change_crm=round(mean(precio_change_crm),2),
#                  precio_change_crm_7=round(mean(precio_change_crm_7),2),
#                  precio_change_final=round(mean(precio_change_final),2)
#                  ),by=movement_factor][order(-calls)])

# as a percentage of total disp
max(complete.data$calltime)
min(complete.data$calltime)
{
  ### custome metric ######
  complete.data[,is_movement_ClientDeactivation:=ifelse(movement_factor=='ClientDeactivation',1,0)]
  # complete.data[,is_movement_no_change:=ifelse(movement_factor=='No Change',1,0)]
  complete.data[,is_movement_AccessDeactivation:=ifelse(movement_factor=='AccessDeactivation',1,0)]
  complete.data[,is_movement_Downgrade:=ifelse(movement_factor=='Downgrade',1,0)]
  # complete.data[,is_movement_Downgrade:=ifelse(movement_factor=='Downgrade',1,0)]
  complete.data[,issave_final:=ifelse(precio_change_final>=0,1,0)]
  complete.data[,issave_final_neg10:=ifelse(precio_change_final>=-10,1,0)]
  
  complete.data[,issave_7:=ifelse(precio_change_crm_7>=0,1,0)]
  complete.data[,issave_15:=ifelse(precio_change_crm_15>=0,1,0)]
  complete.data[,issave_30:=ifelse(precio_change_crm>=0,1,0)]
  complete.data[,issave_30_neg10:=ifelse(precio_change_crm>=-10,1,0)]
  complete.data[,issave_7_neg10:=ifelse(precio_change_crm_7>=-10,1,0)]
  
  
  complete.data[,ischange_final:=ifelse(precio_change_final!=0,1,0)]
  complete.data[,ischange_15:=ifelse(precio_change_crm_15!=0,1,0)]
  complete.data[,ischange_7:=ifelse(precio_change_crm_7!=0,1,0)]
  complete.data[,ischange_30:=ifelse(precio_change_crm!=0,1,0)]
  complete.data[,ischange_deacts:=ifelse((movement_factor=='ClientDeactivation' | movement_factor=='AccessDeactivation') 
                                         & precio_change_crm!=0,1,0)]
  
  # complete.data[,ischange_final_thres_10:=ifelse(precio_change_final<=0 & precio_change_final>=-10,1,0)]
  # complete.data[,ischange_7_thres_10:=ifelse(precio_change_crm_7<=0 & precio_change_crm_7>=-10,1,0)]
  # complete.data[,ischange_30_thres_10:=ifelse(precio_change_crm<=0 & precio_change_crm>=-10,1,0)]
  
  complete.data[,issave_final_thres_10:=ifelse(precio_change_final>=-10,1,0)]
  complete.data[,issave_7_thres_10:=ifelse(precio_change_crm_7>=-10,1,0)]
  complete.data[,issave_30_thres_10:=ifelse(precio_change_crm>=-10,1,0)]
  
  
  complete.data[,week:=week(calltime)]
  complete.data[,min_dt:=min(date(calltime)),by=week]
}

metric_cor <- complete.data[(calltime > '2022-10-01' & calltime < '2022-11-01') | (calltime > '2022-11-01' & calltime < '2022-11-11'),
                            .(ischange_30 = cor(ischange_30, precio_change_crm, method = c('spearman')),
                              ischange_15 = cor(ischange_15, precio_change_crm, method = c('spearman')),
                              ischange_7 = cor(ischange_7, precio_change_crm, method = c('spearman')), 
                              ischange_final = cor(ischange_final, precio_change_crm, method = c('spearman')),
                              ischange_deacts = cor(ischange_deacts, precio_change_crm, method = c('spearman')),
                              issave_7 = cor(issave_7, precio_change_crm, method = c('spearman')),
                              issave_15 = cor(issave_15, precio_change_crm, method = c('spearman')),
                              issave_30 = cor(issave_30, precio_change_crm, method = c('spearman')),
                              issave_final = cor(issave_final, precio_change_crm, method = c('spearman')),
                              issave_30_neg10 = cor(issave_30_neg10, precio_change_crm, method = c('spearman')),
                              issave_7_neg10 = cor(issave_7_neg10, precio_change_crm, method = c('spearman')),
                              is_movement_ClientDeactivation = cor(is_movement_ClientDeactivation, precio_change_crm, method = c('spearman')),
                              is_movement_AccessDeactivation = cor(is_movement_AccessDeactivation, precio_change_crm, method = c('spearman')),
                              is_movement_Downgrade = cor(is_movement_Downgrade, precio_change_crm, method = c('spearman'))
                                        
)]

# metric_cor_final = melt(metric_cor, id.var = (names(metric_cor)))

names(complete.data)
weekwise  <- complete.data[,.(calls=.N,
                              percentage_of_disp_30=round(100*mean(ifelse(precio_change_crm!=0,1,0)),2),
                              percentage_of_disp_15=round(100*mean(ifelse(precio_change_crm_15!=0,1,0)),2),
                              percentage_of_disp_7=round(100*mean(ifelse(precio_change_crm_7!=0,1,0)),2),
                              percentage_of_disp_outcomes=round(100*mean(ifelse(precio_change_final!=0,1,0)),2),
                              precio_change_crm=round(mean(precio_change_crm),2),
                              precio_change_crm_7=round(mean(precio_change_crm_7),2),
                              recio_change_crm_15=round(mean(precio_change_crm_15),2),
                              precio_change_final=round(mean(precio_change_final),2)
),by=.(min_dt,week)][order(-min_dt)]
# View(weekwise)

# complete.data[,issale_7:=ifelse(precio_change_crm_7>0,1,0)]
# complete.data[,issale_final:=ifelse(precio_change_final>0,1,0)]
# complete.data[,issale_30:=ifelse(precio_change_crm>0,1,0)]
# View(agent_level_100_calls)
agent_level<-complete.data[on_off==0,.(calls=.N,
                                       is_movement_ClientDeactivation=mean(is_movement_ClientDeactivation),
                                       # is_movement_no_change=mean(is_movement_no_change),
                                       is_movement_AccessDeactivation=mean(is_movement_AccessDeactivation),
                                       is_movement_Downgrade=mean(is_movement_Downgrade),
                                       
                                       issave_15=mean(issave_15),
                                       issave_7=mean(issave_7),
                                       issave_final=mean(issave_final),
                                       issave_30=mean(issave_30),
                                       issave_final_thres_10=mean(issave_final_thres_10),
                                       issave_7_thres_10=mean(issave_7_thres_10),
                                       issave_30_thres_10=mean(issave_30_thres_10),
                                       # issale_7=mean(issale_7),
                                       # issale_final=mean(issale_final),
                                       # issale_30=mean(issale_30),
                                       
                                       precio_change_crm_15=mean(precio_change_crm_15),
                                       precio_change_crm_7=mean(precio_change_crm_7),
                                       precio_change_crm=mean(precio_change_crm),
                                       precio_change_final=mean(precio_change_final),
                                       
                                       ischange_final=mean(ischange_final),
                                       ischange_15=mean(ischange_15),
                                       ischange_7=mean(ischange_7),
                                       ischange_30=mean(ischange_30),
                                       ischange_deacts = mean(ischange_deacts)
)
,by=.(agentid)]
agent_level_100_calls<-agent_level[calls>50,]
# length(unique(complete.data[calltime>'2022-07-18',]$calltimedt))
fh<-complete.data[agentid %in% agent_level[calls>50,]$agentid & calltime>'2022-11-01' & calltime<'2022-11-11', ]
bh<-complete.data[agentid %in% agent_level[calls>50,]$agentid & calltime>'2022-10-01' & calltime<'2022-11-01', ]
nrow(fh)

fh_ag<-fh[on_off==0,.(calls=.N,
                      ischange_30=mean(ischange_30),
                      ischange_15=mean(ischange_15),
                      ischange_7=mean(ischange_7),
                      ischange_final=mean(ischange_final),
                      ischange_deacts = mean(ischange_deacts),
                      
                      issave_7=mean(issave_7),
                      issave_15=mean(issave_15),
                      issave_30=mean(issave_30),
                      issave_final=mean(issave_final),
                      issave_30_neg10=mean(issave_30_neg10),
                      issave_7_neg10=mean(issave_7_neg10),
                      
                      is_movement_ClientDeactivation=mean(is_movement_ClientDeactivation),
                      is_movement_AccessDeactivation=mean(is_movement_AccessDeactivation),
                      is_movement_Downgrade=mean(is_movement_Downgrade)
)
,by=.(agentid)]

bh_ag<-bh[on_off==0,.(calls=.N,
                      ischange_30=mean(ischange_30),
                      ischange_15=mean(ischange_15),
                      ischange_7=mean(ischange_7),
                      ischange_final=mean(ischange_final),
                      ischange_deacts = mean(ischange_deacts),
                      
                      issave_7=mean(issave_7),
                      issave_15=mean(issave_15),
                      issave_30=mean(issave_30),
                      issave_final=mean(issave_final),
                      issave_30_neg10=mean(issave_30_neg10),
                      issave_7_neg10=mean(issave_7_neg10),
                      
                      is_movement_ClientDeactivation=mean(is_movement_ClientDeactivation),
                      is_movement_AccessDeactivation=mean(is_movement_AccessDeactivation),
                      is_movement_Downgrade=mean(is_movement_Downgrade)
)
,by=.(agentid)]



nrow(fh_ag)
nrow(bh_ag)
joined<-merge(fh_ag,bh_ag,by='agentid',all.x=FALSE,all.y=FALSE,suffixes = c('_FH','_BH'))
nrow(joined)
joined[,c('agentid','calls_FH','calls_BH'):=NULL]
matrix_<-(cor(joined,method=c('spearman')))
class(matrix_)
setDT(matrix_)
# View(matrix_)
# View(matrix_[1:14,15:28])
dim(matrix_[[1]])
# View(joined)
fhbh_values<-matrix_[1:14,15:28]
heatmap(fhbh_values,col=colorRampPalette(brewer.pal(8,"Blues"))(8))
legend(x='bottomright',legend=c(1:8),cex=0.8,fill=colorRampPalette(brewer.pal(8,"Blues"))(8))
print(nrow(agent_level_100_calls))
print(nrow(agent_level))

agent_level_100_calls[,c('agentid','calls'):=NULL]
agent_correlations<-(cor(agent_level_100_calls,method=c('spearman')))
# View(agent_correlations)
# View(cor(agent_level_100_calls,method=c('pearson')))

final_fhbh <- data.frame(metric = tail(names(fh_ag),14),
                         FH = rep("Nov", 14),
                         BH = rep("Oct", 14),
                          fh_bh = diag(fhbh_values),
                          cor_30D = unlist(metric_cor, use.names = F))


library(openxlsx)
#### Change wd ####
setwd(paste0("/data/balerion_home_balaj.khalid/General/FHBH"))

#### Writing to xlss ####
# data <- list("FHBH" = fhbh_values, "correlations" = agent_correlations)

data <- list("FHBH" = final_fhbh)


filename <- str_replace_all(paste0("fhbh_correlations", Sys.Date(), ".xlsx"), '-', '_')

hs <- openxlsx::createStyle(textDecoration = "BOLD")

openxlsx::write.xlsx(data, filename, colWidths = "auto", colNames  = TRUE, headerStyle = hs)

#### Send Email ####
library(mailR)
sender <- "job-alerts@afiniti.com"
reciever <- c('balaj.khalid@afiniti.com')

file_path = paste0("/data/balerion_home_balaj.khalid/General/FHBH/", filename)
send.mail(from = sender, to = reciever,
          subject = paste0("TFN Spain | FHBH Correlation Oct vs Nov", Sys.Date()),
          attach.files=file_path,
          body = 'TFN SPAIN | FHBH Correlation', authenticate=FALSE,
          smtp = list(host.name ="185.81.190.149", port =25))

# fh_ag[order(-ischange_deacts), rank := 1:.N]
# bh_ag[order(-ischange_deacts), rank := 1:.N]
# 
# fh_ag[, fh_percentile := (rank - 0.5)/.N]
# bh_ag[, bh_percentile := (rank - 0.5)/.N]
# 
# fh_ag[, fh_quintile := ceiling(fh_percentile*4)]
# bh_ag[, bh_quintile := ceiling(bh_percentile*4)]
# 
# joined_fh_bh <- fh_ag %>% inner_join(bh_ag, by = "agentid")
# 
# View(joined_fh_bh[abs(fh_quintile - bh_quintile) >= 2, c('agentid', 'ischange_deacts.x', 'ischange_deacts.y', 'rank.x', 'rank.y',
#                                                          'is_movement_ClientDeactivation.x', 'is_movement_ClientDeactivation.y',
#                                                          'is_movement_AccessDeactivation.x', 'is_movement_AccessDeactivation.y',
#                                                          'is_movement_Downgrade.x', 'is_movement_Downgrade.y')])
# 
# 
# cor(complete.data[,'precio_change_final'],complete.data[,'precio_change_crm'])
# cor(agent_level[,'issave_7_thres_10'],agent_level[,'issave_30'], method = 'spearman')
