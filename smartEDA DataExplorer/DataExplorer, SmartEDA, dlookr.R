# DataExplorer, SmartEDA, dlookr
library(tidyverse)
library(DataExplorer)

data()
diamonds

create_report(diamonds, y= "price")
DataExplorer::plot_density(airquality)



library(SmartEDA)
ExpReport(airquality, op_file = 'smarteda.html')

View(ExpNumStat(diamonds,by="A",gp=NULL,Qnt=seq(0,1,0.1),MesofShape=2,Outlier=TRUE,round=2))

library(dlookr)

# Pdf report
diagnose_paged_report(diamonds)



install.packages("rmarkdown", dep = TRUE)

# Report with a response variable 
# dlookr support dplyr syntax

diamonds %>% 
  eda_web_report(
    target   = cut,
    output_format = "html",
    output_file = "EDA_diamonds.html"
  )



# Transformation report can imputes missing values

set.seed(3)
diamonds_NA <- missRanger::generateNA(diamonds) %>% select(1,3,6,7)

#example with outliers
transformation_report(diamonds_NA, target = price)
















