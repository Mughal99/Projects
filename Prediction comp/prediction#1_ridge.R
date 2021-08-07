setwd('/Users/mustafamughal/Desktop/STA314')

library(tidyverse)
library(caret)
library(leaps)
library(MASS)
library(plotmo) # nicer plotting of glmnet output
library(glmnet) # this contains procedures for fitting ridge and lasso
library(ISLR) 
library(party)
library(partykit)

# read in the data
# d.train is the training set
d.train = read.csv('trainingdata.csv')
# d.test are the predictors in the test set
d.test = read.csv('test_predictors.csv')

x = model.matrix(y ~ . ,d.train)[,-1]  
y = d.train$y

ctrl_cv <- trainControl(method = "cv", 
                        number = 10) 

grid = 10^seq(10,-2,length = 100) 
fit.ri = glmnet(x[train,],y[train],alpha =0, lambda = grid)

set.seed(123)
cv.ridge <- cv.glmnet(x, y, alpha = 0)
# Fit the final model on the training data
model <- glmnet(x, y, alpha = 0,
                lambda = cv.ridge$lambda.min)
# Display regression coefficients
coef(model)
x.test <- model.matrix(id ~., d.test)[,-1]
p <- model %>% predict(newx = x.test) # generate predictions on test dataset
pred = data.frame(cbind(1:6000,p))
names(pred) = c('id','y')

# this will create a .csv file in your working directory
# this is the file you should upload to the competition website
# write.csv(example_pred,file='example.csv',row.names=FALSE)
write.csv(pred,file='ridge.csv',row.names=FALSE)
