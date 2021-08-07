setwd('/Users/mustafamughal/Desktop/STA314')
rm(list = ls())
library(tidyverse)
library(caret)
library(leaps)
library(MASS)
library(plotmo) # nicer plotting of glmnet output
library(glmnet) # this contains procedures for fitting ridge and lasso
library(ISLR) 
library(party)
library(partykit)
library(randomForest)


# read in the data
# d.train is the training set
d.train = read.csv('trainingdata.csv')
# d.test are the predictors in the test set
d.test = read.csv('test_predictors.csv')

x = model.matrix(y ~ . ,d.train)[,-1]  
y = d.train$y

ctrl_cv <- trainControl(method = "cv", 
                        number = 10)


classifier1 = randomForest(x,
                          y,
                          ntree = 500, random_state = 0)


p <- classifier1 %>% predict(d.test, type = "response")
pred = data.frame(cbind(1:6000,p))
names(pred) = c('id','y')

write.csv(pred,file='rndmForest.csv',row.names=FALSE)

