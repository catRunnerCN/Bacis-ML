%% Lab 6: K-means Clustering Template
% Author: [Bai]
% CNSCC.361 Artificial Intelligence
% Date: [4.1]

%% Step 0: 加载数据
load Flame_data.mat  % 确保 Flame_data.mat 包含变量 Data
[L, W] = size(Data);

%% Step 0.1: 离散化数据（适配 Hamming 距离）
% 将数据归一化后再二值化（例如 > 0.5 为 1，<=0.5 为 0）
Data_norm = normalize(Data);          % Min-max 归一化
Data_bin = round(Data_norm);          % 将连续数据二值化成 0 或 1

%% Step 1: 初始化聚类中心
K = 4;                                 % 可选 K = 3 或 4
seq = randperm(L);
Centres = Data_bin(seq(1:K), :);      % 用离散化后的数据初始化中心

%% Step 2: K-means 聚类主循环
Centres_new = zeros(K, W);

while true
    %% Step 2.1: 计算 Hamming 距离并分配样本
    ProxMat = pdist2(Data_bin, Centres, 'hamming');  % 不需要平方
    [~, idx] = min(ProxMat, [], 2);                 % 取最近的中心索引
    
    %% Step 2.2: 更新聚类中心
    for i = 1:K
        if sum(idx == i) > 0
            Centres_new(i, :) = round(mean(Data_bin(idx == i, :)));  % 对聚类内数据求均值后四舍五入为新中心
        end
    end

    %% 判断是否收敛
    if isequal(Centres_new, Centres)
        break;
    end
    Centres = Centres_new;
end

%% Step 3: 可视化原始数据分组结果
figure;
for i = 1:K
    plot(Data(idx == i, 1), Data(idx == i, 2), '.', 'markersize', 10);  % 用原始连续数据画图
    hold on;
end
grid on;
title(['K-means Clustering Result with Hamming Distance (K = ', num2str(K), ')']);
hold off;
