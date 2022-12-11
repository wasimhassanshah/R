library(caret)

Titanic <- read.csv("https://raw.githubusercontent.com/mariocastro73/ML2020-2021/master/datasets/Titanic.csv")
summary(Titanic)

Titanic <- Titanic[,c("PClass","Age","Sex","Survived")]

#If you want to play with categorical variable, u need to convert it to factors functions
Titanic$Survived <- as.factor(ifelse(Titanic$Survived==0,"Died","Survived"))
Titanic$PClass <- as.factor(Titanic$PClass)
Titanic$Sex <- as.factor(Titanic$Sex)
str(Titanic)
summary(Titanic)

Titanic <- na.omit(Titanic)
set.seed(9999)
# Cross Validation
train <- createDataPartition(Titanic[,"Survived"],p=0.8,list=FALSE) # Target vriable is Survived, 80% data for training
Titanic.trn <- Titanic[train,]
Titanic.tst <- Titanic[-train,]

ctrl  <- trainControl(method  = "cv",number  = 10) #, summaryFunction = multiClassSummary # Cross validation

# Fitting  Train set for target variable Survived with rpart algorithm using ctrl cross validation

fit.cv <- train(Survived ~ ., data = Titanic.trn, method = "rpart",
                trControl = ctrl,
                # preProcess = c("center","scale"),
                # tuneGrid =data.frame(cp=0.05))
                tuneLength = 30) # metric="Kappa",

pred <- predict(fit.cv,Titanic.tst)
confusionMatrix(table(Titanic.tst[,"Survived"],pred))
print(fit.cv)
plot(fit.cv)
plot(fit.cv$finalModel)
text(fit.cv$finalModel)


library(rpart.plot)
rpart.plot(fit.cv$finalModel)
rpart.plot(fit.cv$finalModel,fallen.leaves = FALSE)
