install.packages("BiocManager")
BiocManager::install("EBImage")
install.packages("keras3")

#load packages
library(EBImage)
library(keras3)
setwd("C:/Users/Khushboo/OneDrive/Desktop/college assignments/SEM 7/R Programming/R Programming Assignment/ImageAnalysis")

pics <- c("p1.jpg", "p2.jpg", "p3.jpg", "p4.jpg", "p5.jpg", "p6.jpg",
          "c1.jpg", "c2.jpg", "c3.jpg", "c4.jpg", "c5.jpg", "c6.jpg")

mypic <- list()

for(i in 1:12) {
  mypic[[i]] <- readImage(pics[i])
}

#Explore
print(mypic[[1]])
display(mypic[[1]])
display(mypic[[8 ]])
summary(mypic[[1]])
hist(mypic[[2]])
str(mypic)

#Resize
for(i in 1:12) {mypic[[i]] <- resize(mypic[[i]], 28, 28)}
str(mypic)


#Reshape
for(i in 1:12) {mypic[[i]] <- array_reshape(mypic[[i]], c(28, 28, 3))}
str(mypic)

#Row Bind
trainx <- NULL
for(i in 1:5) {trainx <- rbind(trainx, mypic[[i]])}
str(trainx)

for(i in 7: 11) {trainx <- rbind(trainx, mypic[[i]])}
str(trainx)

trainy <-c(0,0,0,0,0,1,1,1,1,1)
testy <-c(0,1)

#One Hot Encoding
trainLabels <-to_categorical(trainy)
testLabels <-to_categorical(testy)

#model
model <- keras_model_sequential()
model %>% 
        layer_dense(units =256, activation = 'relu', input_shape= c(2352)) %>%
        layer_dense(units =128, activation = 'relu') %>%
        layer_dense(units =2, activation = 'softmax')
summary(model)

#compile
model %>%
    compile(loss = 'binary_crossentropy',
            optimizer = optimizer_rmsprop(),
            metrics= c('accuracy'))

#fit model
history <- model %>%
        fit(trainx,
            trainLabels,
            epochs = 30,
            batch_size = 32,
            validation_split = 0.2)

plot(history)

#Evaluation & Prediction - train data
model %>% evaluate(trainx, trainLabels)
pred_prob <- model %>% predict(trainx)

pred <- max.col(pred_prob) - 1

table(Predicted = pred, Actual = trainy)

prob <- model %>% predict(trainx)
cbind(prob, Prected = pred, Actual = trainy)

#Evaluation and Prediction - test data
model %>% evaluate(testx, testLabels)
pred <- model %>% predict_classes(testx)
table(Predicted = pred, Actual= testy)