function decisionTree(trainData, trainLabels, testData, testLabels)
    % 假设 trainData 和 testData 是 75x4 的矩阵，trainLabels 和 testLabels 是 75x1 的标签向量
    data = load('iris_dataset.mat');
    % 划分训练集与测试集
    % 这里数据已经传入函数，划分不再需要
    inputs = data.train_data;       % 训练数据集，75x4
    labels = data.train_label;     % 训练标签，75x1
    
    % 训练决策树
    attributes = 1:size(inputs, 2);  % 特征索引 1~4
    tree = buildTree([inputs, labels], attributes);  % 合并数据与标签一起传递给决策树构建函数

    % 打印树结构
    disp('训练集构建的决策树结构：');
    printTree(tree, 0);

    % 测试集预测
    y_pred = zeros(size(data.test_data, 1), 1);
    y_true = data.test_label;

    for i = 1:length(y_pred)
        y_pred(i) = classify(tree, data.test_data(i, :));  % 用训练的树来预测
    end

    % 计算准确率
    accuracy = sum(y_pred == y_true) / length(y_true);
    fprintf('\n预测准确率：%.2f%%\n', accuracy * 100);

    % 混淆矩阵
    confMat = confusionmat(y_true, y_pred);
    disp('混淆矩阵：');
    disp(confMat);
end
