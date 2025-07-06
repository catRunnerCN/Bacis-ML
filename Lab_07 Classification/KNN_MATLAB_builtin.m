clear;clc
%%kNN Classifier - Matlab Built-in function
fprintf('K Nearest Neighbours (built-in)(k=9):\n');
%% Load Training and Test data
load('iris_dataset.mat'); 
%% Number of neighbors
k = 9;
%% Call MATLAB built-in kNN Classifier
% need to add code here ...
classifier = fitcknn(train_data,train_label,'NumNeighbors',k); 
YPred = predict(classifier,validation_data);
%% Calculate accuracy
Accuracy = size(find(validation_label==YPred),1)/size(validation_label,1)
%% The below code uses confusion matrix to calculate the accuracy. We will discuss the confusion matrix in Week 9 Lecture.
% ConfusionMatrix = confusionmat(validation_label,YPred)
% accuracy_kNN_builtin = (ConfusionMatrix(1,1)+ConfusionMatrix(2,2)+ConfusionMatrix(3,3))/sum(ConfusionMatrix(:))