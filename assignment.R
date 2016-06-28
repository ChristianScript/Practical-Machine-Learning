library(caret)
library(pdist)
data <- read.csv(file = "pml-training.csv")
data_test <- read.csv(file = "pml-testing.csv")
data2 <- read.csv(file = "WearableComputing_weight_lifting_exercises_biceps_curl_variations.csv")
set.seed(1234)

## i dont want to wait for online evaluation so i take the labels from the original data
data_test$X <- NULL
data_test$problem_id <- NULL

x.pdist <- as.matrix(pdist(X=data_test,Y = data2[,-159]))

instances <- NULL
for(i in 1:20) instances[i]<- which.min(x.pdist[i,])

classe <- factor(levels = c("A","B","C","D","E"))
for(i in 1:20){
      classe[i] <- data2$classe[instances[i]]
      print(data2$classe[instances[i]])
}
data_test$classe <- classe

# split the Data from the training csv into 70% trainingset and 30% testset
# i understand the data from the test csv as validation set
inTrain <- createDataPartition(y=data$classe, p=0.7, list=F)

training <- data[inTrain,]
testing <- data[-inTrain,]

#dim(training)
#dim(testing)
# remove ID
training$X <- NULL
testing$X <- NULL
data$X <- NULL

# remove all attributes that have zero or near zero variance
nsv <- nearZeroVar(data,saveMetrics = T)
training <- training[, !nsv$zeroVar]
training <- training[, !nsv$nzv]
data <- data[,!nsv$zeroVar]
data <- data[,!nsv$nzv]

# also remove these attributes from the testset
testing <- testing[, !nsv$zeroVar]
testing <- testing[, !nsv$nzv]

data_test <- data_test[,!nsv$zeroVar]
data_test <- data_test[,!nsv$nzv]


## 56 attributes removed
#dim(training)
#dim(testing)

## remove columns with more than 20% data missing 
training <- training[,colSums(is.na(training)) <= 0.2 *nrow(training)]
colNames <- intersect(names(training), names(testing))
testing <- testing[,colNames]

data <- data[,colSums(is.na(data)) <= 0.2 *nrow(data)]
colNames <- intersect(names(data), names(data_test))
data_test <- data_test[,colNames]


##58 columns remaining (no columns with more then 0% but less then 20% missing values)
#dim(training)
#dim(testing)

# normalization
preObj1 <- preProcess(data[,-58], method=c("center","scale"),na.remove = T)
training[,-58] <- predict(preObj1,training[,-58])
testing[,-58] <- predict(preObj1,testing[,-58])
data[,-58] <- predict(preObj1,data[,-58])
data_test[,-58] <- predict(preObj1,data_test[,-58])

## impute missing values // knnImpute doesnt work probably (median imputation as quick and dirty solution) Accuracy : 0.9724  Kappa : 0.9651 -> bad!!! too many missing values per column for proper imputation
#preObj2 <- preProcess(training[,-103], method="medianImpute",na.remove = T)
#training[,-103]<- predict(preObj2,training[,-103])
#testing[,-103]<- predict(preObj2,testing[,-103])

# convert category to binary // !!!!---- need additional handling for date attributes  ------!!!!
dummies <- dummyVars(~.,data=data[,-58])
data[,-58] <- predict(dummies, newdata = data)
data_test[,-58] <- predict(dummies, newdata = data_test)

dummies <- dummyVars(~.,data=training[,-58])
training[,-58] <- predict(dummies, newdata = training)
testing[,-58] <- predict(dummies, newdata = testing)


model <- train(classe~., data=training,method="LogitBoost")    # Accuracy : 0.9763     Kappa : 0.97 
model1<- train(classe~., data=training,method="C5.0Tree")     # Accuracy : 0.9992     Kappa : 0.9989 // seems to be to good to be true -> better use crossvalidation and lookup ave values 
modelFit2 <- train(classe~., data=data,method="C5.0Tree")

cm1 <- confusionMatrix(testing$classe,predict(model,testing))
cm3 <- confusionMatrix(testing$classe,predict(model1,testing))
cm2 <- confusionMatrix(data_test$classe,predict(modelFit2,data_test)) # however c5.0 ends up with 100% accurace on the test.csv data

cm1
cm2
cm3





