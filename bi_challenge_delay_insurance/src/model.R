### necessary packages
library("readr")
library("rpart")
library("stringr")
library("dplyr")
library("randomForest")
library("FSelector")
library("lift")

### load
dataset <- read_csv("Y:/2017/coya/2008 (1).csv")

### vars definition
explanatoryVars <- c("Month", "DayOfWeek", "depTime", "CRSElapsedTime", "arrTime", "UniqueCarrier", "Distance", "originOther", "destOther")
explanatoryVarsFac <- c("depTime", "arrTime", "UniqueCarrier",  "originOther", "destOther")

### deleteCanceled
dataset <- dataset[dataset$Cancelled == 0, ]

### Delay is na
dataset <- dataset[is.na(dataset$ArrDelay) == F, ]

### target
isDelayed <- factor((dataset$ArrDelay>60)*1)

### dep time
dataset$depTime <-  substr(dataset$CRSDepTime, 1,nchar(dataset$CRSDepTime)-2)

### arr time
dataset$arrTime <-  substr(dataset$CRSArrTime, 1,nchar(dataset$CRSArrTime)-2)

### origin
noOrigin <- dataset %>% group_by(Origin) %>% summarise(n()) %>% arrange(`n()`) %>% tail(30) 
namesOrigin <- noOrigin$Origin
dataset$originOther <- is.element(dataset$Origin,namesOrigin)
dataset$originOther[dataset$originOther == T] <- dataset$Origin[dataset$originOther == T]
dataset$originOther[dataset$originOther == F] <- "Other"
noOriginControl <- dataset %>% group_by(originOther) %>% summarise(n()) %>% arrange(`n()`) 

### dest
noDest <- dataset %>% group_by(Dest) %>% summarise(n()) %>% arrange(`n()`) %>% tail(30) 
namesDest <- noDest$Dest
dataset$destOther <- is.element(dataset$Dest,namesDest)
dataset$destOther[dataset$destOther == T] <- dataset$Dest[dataset$destOther == T]
dataset$destOther[dataset$destOther == F] <- "Other"
noDestControl <- dataset %>% group_by(destOther) %>% summarise(n()) %>% arrange(`n()`) 

### make factors
dataset <- data.frame(dataset)
idx <- which(is.element(colnames(dataset),explanatoryVarsFac))
for (i in idx){
  dataset[,i] <- factor(dataset[,i])
  print(levels(dataset[,i]))
}

### divide to train, test
split <- runif(nrow(dataset))
trainDataset <- dataset[split < 0.25, ] 
testDataset <- dataset[split > 0.90, ]
trainIsDelayed <- isDelayed[split < 0.25]
testIsDelayed <- isDelayed[split > 0.90]

### make formula
formulaAll <- as.simple.formula(explanatoryVars,"trainIsDelayed")

### rmv dataset due to memory issues
remove(list=c("dataset"))

### train forest
fit <- randomForest(formula = formulaAll, ntree = 10, data = trainDataset) 
summary(fit)
plot(fit)
varImpPlot(fit, sort = T, n.var=10, main="Top X - Variable Importance")

### train glm
fit <- glm(formula = formulaAll, family = binomial(link = "logit"), data = trainDataset) 
summary(fit)

### TRAIN predict and lift
prob      <- predict(fit, trainDataset, type="response")
TopDecileLift(prob,trainIsDelayed)
plotLift(prob, trainIsDelayed, cumulative = TRUE, n.buckets = 50)

### TEST predict and lift
prob      <- predict(fit, testDataset, type="response")
TopDecileLift(prob,testIsDelayed)
plotLift(prob, testIsDelayed, cumulative = TRUE, n.buckets = 50)
