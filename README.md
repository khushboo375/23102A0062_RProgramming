# Aeroplane vs Car Image Classification using R

## 1. Project Objective

The objective of this project is to implement a binary image classification
model using R Programming to classify images into two categories:
Aeroplane and Car.

The project follows the methodology demonstrated in the prescribed video
tutorial.

## 2. Problem Description

The project demonstrates image processing and neural network based
classification using a small dataset containing images of aeroplanes and cars.

The images are processed, resized, reshaped and provided as input to a
fully connected neural network.

## 3. Dataset

The dataset contains 12 images:

- 6 Aeroplane images
- 6 Car images

The images are named:

- p1.jpg to p6.jpg — Aeroplanes
- c1.jpg to c6.jpg — Cars

The first five images from each class are used for training and the sixth
image from each class is used for testing.

## 4. Technologies and Libraries

- R Programming
- RStudio
- EBImage
- Keras
- TensorFlow

## 5. Methodology

The project follows these steps:

1. Load the required R packages.
2. Read the input images using EBImage.
3. Explore the images and their dimensions.
4. Resize all images to 28 × 28 × 3.
5. Reshape each image into a vector of 2352 values.
6. Create training and testing datasets.
7. Assign labels:
   - 0 = Aeroplane
   - 1 = Car
8. Perform one-hot encoding.
9. Create a neural network model.
10. Train the model for 30 epochs.
11. Evaluate the model.
12. Generate predictions.
13. Generate confusion matrices.
14. Evaluate the model on test images.

## 6. Neural Network Architecture

Input Layer: 2352 features

Hidden Layer 1: 256 neurons, ReLU

Hidden Layer 2: 128 neurons, ReLU

Output Layer: 2 neurons, Softmax

## 7. Model Training

The model is trained using:

- Epochs: 30
- Batch Size: 32
- Validation Split: 20%
- Optimizer: RMSProp
- Loss Function: Categorical Cross-Entropy
- Evaluation Metric: Accuracy

## 8. Results

The model was evaluated on both training and testing data.

Training Accuracy: 90%

## 9. Conclusion

The project demonstrates an end-to-end image classification workflow using
R Programming. Images were processed using EBImage and classified using a
neural network implemented with Keras and TensorFlow.

The experiment demonstrates how image data can be transformed into numerical
features and used for binary classification.

## 10. Screenshots

Add screenshots of:

1. Image processing
2. Neural network model summary
3. Training graphs
4. Final predictions

## 12. Reference

Prescribed YouTube tutorial:
https://www.youtube.com/watch?v=iExh0qj2Ouo

Assignment Problem Statement:
R Project Implementation and Version Control Using GitHub

## 13. Presented by
Khushboo Yadav 
23102A0062
CMPN A