# Author: Syed Aqhib Ahmed
# Date: 3/20/2019
# File: MGS662_assignment1.R

set.seed(1234)
rm(list = ls())
setwd("D://Syed//Graduate//Spring19//Optimization//assignment1")

#Loading in the training data from the csv file to build the model
train.data <- read.csv("BlogFeedback//blogData_train.csv", header =  FALSE)

#We find the number of responses to be skewed negatively
hist(train.data$V281)

#########################

#Experiment 1

#########################

# These are the features that we want to consider for experiment 1. We also attach the response variable to the dataframe.
basic.features <- c(51:60, 281)

#Building the test-set for experiment 1
exp1.train.data <- train.data[,basic.features]

# Getting the list of test data files from the data folder
folder <- "BlogFeedback//"
file.list = list.files(path = folder, pattern="*.csv")

# Creating a dataframe for each of the csv files in the folder with names test_"test set number"
for (i in 1:length(file.list)){
  
  assign(paste("test_",i,sep=''), 
         
         read.csv(paste(folder, file.list[i], sep=''), header = FALSE)
         
  )}

# Columns 55 and 60 seem to making our matrix singular(rank deficient) so we are dropping both
drop <- c('V55','V60')
exp1.train.data <- exp1.train.data[,!(names(exp1.train.data) %in% drop)]

#Fitting a linear model on the training data
exp1.lm.fit <- lm( formula = V281 ~., data = exp1.train.data )
summary(exp1.lm.fit)

# Running predict on all the test data files in the folder
mse1 = vector()
test_means = vector()
test_sd = vector()
for (i in 1:60){
  #create dataframe reference from string name
  name <- get(paste("test_",i,sep=''))
  #predict for test set i
  exp1.pred.lm = predict(exp1.lm.fit, name, se.fit = TRUE)
  #calculate mean squared error
  mse1[i] <- (sum(name$V281 - exp1.pred.lm$fit)^2)/length(name)
  #calculating mean and standard deviation for each test set to get context for the mse value for these sets
  test_means[i] <- mean(name$V281)
  test_sd[i] <- sd(name$V281)
}

#Finding out average MSE for all the test sets
sum1 <- 0
for (i in 1:60){
  sum1 <- sum1 + mse1[[i]]
}
mean.mse1 <- sum1/60

plot(1:60,mse1)

#########################

#Experiment 2

#########################


# These are the features that we want to consider for experiment 1. We also attach the response variable to the dataframe.
textual.features <- c(63:262, 281)

#Building the test-set for experiment 1
exp2.train.data <- train.data[,textual.features]

#Fitting a linear model on the training data
exp2.lm.fit <- lm( formula = V281 ~., data = exp2.train.data )
summary(exp2.lm.fit)


#remove na features
nalist <- list()

numofvariables=length(exp2.lm.fit$coefficients)-1
sum(is.na(exp2.lm.fit$coefficients))
for (i in 1:numofvariables){
  if(is.na(exp2.lm.fit$coefficients[i])){
    nalist = c(nalist,paste('V',i+61,sep=''))
  }
}

exp2.train.data <- exp2.train.data[,!(names(exp2.train.data) %in% nalist)]

exp2.lm.fit <- lm( formula = V281 ~., data = exp2.train.data )
summary(exp2.lm.fit)

# Running predict on all the test data files in the folder
mse2 = vector()

for (i in 1:60){
  #create dataframe reference from string name
  name <- get(paste("test_",i,sep=''))
  #predict for test set i
  exp2.pred.lm = predict(exp2.lm.fit, name, se.fit = TRUE)
  #calculate mean squared error
  mse2[i] <- (sum(name$V281 - exp2.pred.lm$fit)^2)/length(name)

}

#Finding out average MSE for all the test sets
sum2 <- 0
for (i in 1:60){
  sum2 <- sum2 + mse2[[i]]
}
mean.mse2 <- sum2/60

plot(1:60,mse2)