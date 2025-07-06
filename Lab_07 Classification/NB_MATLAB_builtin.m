%% Naive Bayes Classifier - Matlab Built-in function
fprintf('Naive Bayes Classifier (built-in):\n');
%% Load Training and Test data
load('iris_dataset.mat'); 
%% Call MATLAB built-in Naive Bayes Classifier 
% need to add code here ...
classifier = fitcnb(train_data,train_label,'Distribution','normal'); 
YPred = predict(classifier,validation_data);


%% Calculate accuracy
Accuracy = size(find(validation_label==YPred),1)/size(validation_label,1)
%% The below code uses confusion matrix to calculate the accuracy. We will discuss the confusion matrix in Week 9 Lecture.
% ConfusionMatrix = confusionmat(validation_label,YPred)
% accuracy_kNN_builtin = (ConfusionMatrix(1,1)+ConfusionMatrix(2,2)+ConfusionMatrix(3,3))/sum(ConfusionMatrix(:))