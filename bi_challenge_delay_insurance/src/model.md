### model description
The main goal of "flight delay model" is to find the probabilty of delay for each customer. As already mentioned, the target is factor variable isDelayed, i.e. 0 stands for delay <= 45, 1 represents delay > 45. We chose general linear model with  

## feature selection
 glm based on features "Month", "DayOfWeek", "CRSDepTime", "CRSElapsedTime", "SRSArrTime", "UniqueCarrier", "Origin", "Dest"


## lift curve
![alt text](Rplot.png)

## variable importance bar graph
![alt text](varImpPlot.png)

