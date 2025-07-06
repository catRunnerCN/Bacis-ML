%% Lab 6: K-means Clustering Template
% Author: [Bai]
% CNSCC.361 Artificial Intelligence
% Date: [4.1]

%% Step 0: 加载数据
% 以 Flame 数据集为例（老师可能会给数据文件）
load Flame_data.mat  % 确保Flame.mat在当前文件夹中
[L, W] = size(Data);  % 获取数据的大小

%% Step 1: 初始化聚类中心
% K = 2;  % 聚类数量，可以修改为3, 4等，完成任务2
K = 3;
% K = 4;
seq = randperm(L);  % 随机打乱数据索引
Centres = Data(seq(1:K), :);  % 随机选择K个数据点作为初始聚类中心

%% Step 2: K-means 聚类循环
% 初始化一个变量用于存储新的中心
Centres_new = zeros(K, W);

% 继续迭代直到聚类中心不再变化
while true
    %% Step 2.1: 分配每个数据点到最近的中心
    % ProxMat = pdist2(Data, Centres).^2;  % 计算每个点到中心的距离（平方欧几里得距离）
    ProxMat = pdist2(Data, Centres, 'hamming');  % 使用cosine距离
    % ProxMat = pdist2(Data, Centres, 'hamming').^2;  % 使用cosine距离
    [~, idx] = min(ProxMat, [], 2);  % 为每个点找最近的中心，返回的是中心的索引
    
    %% Step 2.2: 更新聚类中心
    for i = 1:K
        Centres_new(i, :) = mean(Data(idx == i, :));  % 计算每个聚类的均值作为新中心
    end
    
    %% 检查是否收敛
    if isequal(Centres_new, Centres)
        break;  % 如果新旧中心相同，停止迭代
    end
    Centres = Centres_new;  % 更新中心，继续下一轮迭代
end

%% Step 3: 可视化聚类结果
figure;
for i = 1:K
    plot(Data(idx == i, 1), Data(idx == i, 2), '.', 'markersize', 10);
    hold on;
end
grid on;
plot(Centres(:,1), Centres(:,2), 'k*', 'markersize', 10, 'linewidth', 2);  % 绘制中心
title(['Hamming,K-means Clustering Result with K = ', num2str(K)]);
hold off;
