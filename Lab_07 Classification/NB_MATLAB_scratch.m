%% Naive Bayes Classifier - Implementing Naive Bayes classifier from scratch
fprintf('Naive Bayes Classifier (scratch):\n');
%% Load Training and Test data
load('iris_dataset.mat'); 
%% Dividing training samples into 3 parts (because there are 3 classes)
class1 = [];class2 = [];class3 = [];
for i =1:size(train_data,1)
    if train_label(i) == 1
        class1 = cat(1,class1,train_data(i,:));
    elseif train_label(i) == 2
        class2 = cat(1,class2,train_data(i,:));
    elseif train_label(i) == 3
        class3 = cat(1,class3,train_data(i,:));
    end
end
%% Prior probability
% need to add your own code here ...Belongs P(Ci)
totalSamples = size(train_data,1);
priorProb_class1 = size(class1,1) / totalSamples;
priorProb_class2 = size(class2,1) / totalSamples;
priorProb_class3 = size(class3,1) / totalSamples;
%% Mean and std (variance) of each attribute in each class
stdMap_class1 = std(class1,1); meanMap_class1 = mean(class1,1);% Mean and std for class C1
stdMap_class2 = std(class2,1); meanMap_class2 = mean(class2,1);% Mean and std for class C2
stdMap_class3 = std(class3,1); meanMap_class3 = mean(class3,1);% Mean and std for class C3
%% Testing
YPred = zeros(size(validation_data,1),1);%% Store the predicted label for each validation sample
for testIndex=1:size(validation_data,1)
    %Class 1
    condProb_class1 = normpdf(validation_data(testIndex,:), meanMap_class1,stdMap_class1);
    condProb_class1 = prod(condProb_class1);
    prob(1,1) = condProb_class1*priorProb_class1;
    %Class 2
    condProb_class2 = normpdf(validation_data(testIndex,:), meanMap_class2,stdMap_class2);
    condProb_class2 = prod(condProb_class2);
    prob(1,2) = condProb_class2*priorProb_class2;
    %Class 3
    condProb_class3 = normpdf(validation_data(testIndex,:), meanMap_class3,stdMap_class3);
    condProb_class3 = prod(condProb_class3);
    prob(1,3) = condProb_class3*priorProb_class3;
    %find Maximum one
    [maxval,argmax] = max(prob);
    YPred(testIndex,1) = argmax;
end
%% Calculate accuracy
Accuracy = size(find(validation_label==YPred),1)/size(validation_label,1)
%% The below code uses confusion matrix to calculate the accuracy. We will discuss the confusion matrix in Week 9 Lecture.
% ConfusionMatrix = confusionmat(validation_label,YPred)
% accuracy_kNN_builtin = (ConfusionMatrix(1,1)+ConfusionMatrix(2,2)+ConfusionMatrix(3,3))/sum(ConfusionMatrix(:))