clear;clc
%% kNN Classifier - Implementing kNN classifier from scratch
fprintf('K Nearest Neighbours (scratch):\n');
%% Load Training and Test data
load('iris_dataset.mat'); 
%% Number of neighbors
k = 1;
%% kNN implementation
YPred = zeros(size(validation_data,1),1);%% Store the predicted label for each validation sample
for ind_val = 1:size(validation_data,1)
    tmp = validation_data(ind_val,:);
    %% Compute square distance between test point and each training observation
    r_zx = sum(bsxfun(@minus, train_data, tmp).^2, 2);
    %% Sort the distances in ascending order
    [r_zx,idx] = sort(r_zx, 1, 'ascend');
    %% Keep only the K nearest neighbours
    r_zx = r_zx(1:k); % keep the first ’kNN’ distances
    idx = idx(1:k); % keep the first ’kNN’ indexes
    %% Majority vote only on those ’kNN’ indexes
    YPred(ind_val,1) = mode(train_label(idx));
end
%% Calculate accuracy
Accuracy = size(find(validation_label==YPred),1)/size(validation_label,1)
%% The below code uses confusion matrix to calculate the accuracy. We will discuss the confusion matrix in Week 9 Lecture.
% ConfusionMatrix = confusionmat(validation_label,YPred)
% accuracy_kNN_builtin = (ConfusionMatrix(1,1)+ConfusionMatrix(2,2)+ConfusionMatrix(3,3))/sum(ConfusionMatrix(:))
