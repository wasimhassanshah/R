library(ggplot2)

df_kdnuggets <- read.csv("bar_line_chart_data.csv")

combo <- ggplot(df_kdnuggets,
                aes(x= Year,
                    y = Participants, Python.Users)) +
         geom_bar(aes(y= df_kdnuggets$Participants),# Choosing Participants columns of df_Kdnuggets
                  stat = "identity", # Choosing stat as identity to plot num of participants each year
                  fill ="black") + 
         geom_line(aes(y= df_kdnuggets$Python.Users * max(df_kdnuggets$Participants )),  # Making python Users value 
                                              # equal of Particapnts colum value by * it with max value of Particpants
                      stat = "identity",
                      color ="red",
                      size = 2) +
  scale_y_continuous(sec.axis = sec_axis(~./max(df_kdnuggets$Participants)*100, #rescale line chart y-axis and convert to percentage scale 
                                         name = "Python Users in %")) 
combo
