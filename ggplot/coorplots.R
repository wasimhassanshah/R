
install.packages("corrplot")

library(corrplot)

# correlation plot

corrplot(corr = cor(iris[ , 1:4])) # excluding 5th categorical column

corrplot(corr = cor(iris[-5]))



?corrplot

corrplot(cor(mtcars),
         addCoef.col = "white",
         number.cex = 0.8,
         number.digits = 1,
         diag= FALSE,
         bg = "grey",
         outline = "black",
         addgrid.col = "white",
         mar = c(1,1,1,1))



GGally :: ggcorr(mtcars,
                 method= c("everything", "pearson"),
                 label = TRUE,
                 label_alpha = TRUE)





































