### necessary packages
library("readr")
library("rpart")
library("stringr")
library("dplyr")
library("randomForest")
library("FSelector")
library("lift")
library("caret")
library("plotly")

### load
dataset <- read_csv("Y:/2017/coya/2008 (1).csv")

### vars definition
explanatoryVars <- c("Month", "DayOfWeek", "depTime", "CRSElapsedTime", "arrTime", "UniqueCarrier", "Distance", "origin", "dest")
explanatoryVarsFac <- c("Month","DayOfWeek","depTime", "arrTime", "UniqueCarrier",  "origin", "dest")
explanatoryVarsNum <- c( "CRSElapsedTime")

### deleteCanceled
dataset <- dataset[dataset$Cancelled == 0, ]

### Delay is na
dataset <- dataset[is.na(dataset$ArrDelay) == F, ]

### target
isDelayed <- factor((dataset$ArrDelay>45)*1)
dataset$isDelayed <- isDelayed

### DR ad hoc analysis
#minutes <- c(1:180)
#meanDelay <- c()
#for (i in minutes){
#  meanDelay <- c(meanDelay, mean(((dataset$ArrDelay>i)*1)))
#}
#plot(minutes,meanDelay)

### dep time
dataset$depTime <-  substr(dataset$CRSDepTime, 1,nchar(dataset$CRSDepTime)-2)

### arr time
dataset$arrTime <-  substr(dataset$CRSArrTime, 1,nchar(dataset$CRSArrTime)-2)

### origin
noOrigin <- dataset %>% group_by(Origin) %>% summarise(n()) %>% arrange(`n()`) %>% tail(30) 
namesOrigin <- noOrigin$Origin
dataset$origin <- is.element(dataset$Origin,namesOrigin)
dataset$origin[dataset$origin == T] <- dataset$Origin[dataset$origin == T]
dataset$origin[dataset$origin == F] <- "Other"
noOriginControl <- dataset %>% group_by(origin) %>% summarise(n()) %>% arrange(`n()`) 

### dest
noDest <- dataset %>% group_by(Dest) %>% summarise(n()) %>% arrange(`n()`) %>% tail(30) 
namesDest <- noDest$Dest
dataset$dest <- is.element(dataset$Dest,namesDest)
dataset$dest[dataset$dest == T] <- dataset$Dest[dataset$dest == T]
dataset$dest[dataset$dest == F] <- "Other"
noDestControl <- dataset %>% group_by(dest) %>% summarise(n()) %>% arrange(`n()`) 

### make factors
dataset <- data.frame(dataset)
idx <- which(is.element(colnames(dataset),explanatoryVarsFac))
for (i in idx){
  dataset[,i] <- factor(dataset[,i])
  print(levels(dataset[,i]))
}

### subsample due to memory issues
split <- runif(nrow(dataset))
dataset <- dataset[split < 0.2, ] 
isDelayed <- isDelayed[split < 0.2] 

### make formula
formulaAll <- as.simple.formula(explanatoryVarsFac,"isDelayed")

### dummy
dummies <- model.matrix(formulaAll, data = dataset)
dummies <- as.data.frame(dummies)
dummiesNames <- colnames(dummies)
dataset <- cbind(dataset,dummies)

### divide to train, test
split <- runif(nrow(dataset))
trainDataset <- dataset[split < 0.7, ] 
testDataset <- dataset[split > 0.7, ]
trainIsDelayed <- isDelayed[split < 0.7]
testIsDelayed <- isDelayed[split > 0.7]

### rmv dataset due to memory issues
remove(list=c("dataset","dummies"))

### make formula
intercept <- c(which(is.element(dummiesNames,"(Intercept)")))
dummiesNames <- dummiesNames[-intercept]
formulaAllTrain <- as.simple.formula(c(explanatoryVarsNum,dummiesNames),"trainIsDelayed")

### scale
idx <- which(is.element(colnames(trainDataset),c(explanatoryVarsNum,dummiesNames)))
for (i in idx){
trainDataset[,i] <- scale(trainDataset[,i])
testDataset[,i] <- scale(testDataset[,i])
}

### train forest
#fit <- randomForest(formula = formulaAllTrain, ntree = 100, data = trainDataset) 
#summary(fit)
#plot(fit)
#varImpPlot(fit, sort = T, n.var=10, main="Top X - Variable Importance")

### train glm
fit <- glm(formula = formulaAllTrain, family = binomial(link = "logit"), data = trainDataset) 
summary(fit)
#importance(fit)

### TRAIN predict and lift
prob      <- predict(fit, trainDataset, type="response")
TopDecileLift(prob,trainIsDelayed)
plotLift(prob, trainIsDelayed, cumulative = TRUE, n.buckets = 100)

### TEST predict and lift
prob      <- predict(fit, testDataset, type="response")
TopDecileLift(prob,testIsDelayed)
plotLift(prob, testIsDelayed, cumulative = TRUE, n.buckets = 100)

### prepare DF of coeffs
coefDF <- data.frame(coef = fit$coefficients)
varImpTOP20 <-  data.frame(varName = row.names(coefDF), coef = coefDF$coef, coefAbs = abs(coefDF$coef)) %>% arrange(coefAbs) %>% tail(51)
varImpTOP20 <- varImpTOP20[-51,]
varImpTOP20$varName <- as.character(varImpTOP20$varName)

### plot ly
p <- plot_ly(data = varImpTOP20, y = varImpTOP20$varName, x = varImpTOP20$coef, type = "bar",  orientation = "h", color = varImpTOP20$coefAbs) %>%
  layout(title = "Most important variables",
         yaxis = list(categoryarray = varImpTOP20$varName),
         showlegend = TRUE, 
         margin = list(l = 100))
p

