library(ggplot2)

df_ad_expenditure <- read.csv("scatter_plot_ii.csv")

regression_scatter <- ggplot(df_ad_expenditure,
                             aes(x= Budget,
                                 y= Sales)) +
                      geom_point(size = 3,
                                 color = "grey12") + #grey1 is is light grey and grey100 is veryblack
                      geom_smooth(method= lm,
                                  color= "red",
                                  fill= "red") + # Fill is for filling Confidence level area
                    xlab("Ad Expenditure in (000's $)") +
                    ylab("Sales in (000's $)") + 
                    ggtitle("Effect of Ad Expenditure on Sales")
                             
regression_scatter  
