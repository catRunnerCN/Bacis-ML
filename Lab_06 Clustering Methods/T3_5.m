load Aggregation_data.mat  % 确保Flame.mat在当前文件夹中
[L, W] = size(Data);  % 获取数据的大小
[idx, C] = kmeans(Data, 9, 'Distance', 'sqeuclidean');  % 聚类数量5，cosine距离

% 可视化结果Data：数据矩阵（每行是一个样本，每列是一个特征）

% K：想分成多少类（簇）

% IDX：返回的分类结果（每个点被分到哪一类）

% C：每一类的中心点坐标

% SUMD：每一类内点到中心点的距离和

% D：每个点到每个簇中心的距离（Proximity Matrix）
figure;
for i = 1:max(idx)
    plot(Data(idx == i, 1), Data(idx == i, 2), '.', 'markersize', 10);
    hold on;
end
plot(C(:,1), C(:,2), 'k*', 'markersize', 10, 'linewidth', 2);
title('Built-in kmeans Clustering Result');
hold off;
