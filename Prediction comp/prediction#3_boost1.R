setwd('/Users/mustafamughal/Desktop/STA314')
rm(list = ls())
library(tidyverse)
library(caret)
library(leaps)
library(MASS)
library(plotmo) # nicer plotting of glmnet output
library(glmnet) # this contains procedures for fitting ridge and lasso
library(ISLR) 
library(randomForest)
library(gbm)

# read in the data
# d.train is the training set
d.train = read.csv('trainingdata.csv')
# d.test are the predictors in the test set
d.test = read.csv('test_predictors.csv')

x = model.matrix(y ~ . ,d.train)[,-1]  
y = d.train$y

set.seed(1)
boostmod = gbm(y~.,
              data= d.train,
              distribution='gaussian',
              n.trees = 6000,
              interaction.depth = 1,
              shrinkage = 0.01,
              cv.folds = 10
)


yhat1=predict(boostmod,newdata= d.train, n.trees=6000)
mean((yhat1 -y)^2)

p <- boostmod %>% predict(d.test, type = "response")
pred = data.frame(cbind(1:6000,p))
names(pred) = c('id','y')
write.csv(pred,file='boost3.csv',row.names=FALSE)
