% ClimateDataProcessing.m
% 任务：对气候数据进行预处理、可视化与降维分析

%% 读取并构造数据表
raw_data = readmatrix('ClimateData.csv');
features = {'Temperature', 'Wind_Speed', 'Wind_Direction', 'Precipitation', 'Humidity'};
climate_table = array2table(raw_data, 'VariableNames', features);

%% 1. Min-Max Scaling
min_vals = min(raw_data);
range_vals = max(raw_data) - min_vals;
minmax_scaled = (raw_data - min_vals) ./ range_vals;

fprintf('Min-Max Scaling Preview:\n');
disp(minmax_scaled(1:5, :));

%% 2. Z-Score Standardization
mean_features = mean(raw_data);
std_features = std(raw_data);
zscore_scaled = (raw_data - mean_features) ./ std_features;

fprintf('Z-Score Standardization Preview:\n');
disp(zscore_scaled(1:5, :));
figure('Name','Mean of Features After Z-Score Standardization','NumberTitle','off');
bar(mean_features, 'FaceColor', [0.2, 0.6, 0.8]);
set(gca, 'XTickLabel', feature_names, 'XTick', 1:numel(feature_names));
xlabel('Features');
ylabel('Mean (Z-Score)');
title('Feature-wise Mean After Z-Score Normalization');
grid on;
%% 3. Outlier Detection and Removal
zscore_values = abs(zscore_scaled);
threshold_z = 3;
non_outliers = all(zscore_values <= threshold_z, 2);
filtered_data = raw_data(non_outliers, :);

fprintf('Outliers Removed: %d\n', sum(~non_outliers));
fprintf('Cleaned Data Preview:\n');
disp(filtered_data(1:5, :));

% % 可选保存：
% writematrix(minmax_scaled, 'MinMax_Result.csv');
% writematrix(zscore_scaled, 'ZScore_Result.csv');
% writematrix(filtered_data, 'Cleaned_Result.csv');

%% 4. 数据可视化（前两个特征：Temperature 与 Wind_Speed）
figure('Name','Data Visualization','NumberTitle','off');

subplot(2,2,1);
scatter(raw_data(:,1), raw_data(:,2), 20, 'filled');
title('Raw Data');
xlabel('Temperature'); ylabel('Wind Speed');

subplot(2,2,2);
scatter(minmax_scaled(:,1), minmax_scaled(:,2), 20, 'filled');
title('Min-Max Scaled');
xlabel('Temperature'); ylabel('Wind Speed');

subplot(2,2,3);
scatter(zscore_scaled(:,1), zscore_scaled(:,2), 20, 'filled');
title('Z-Score Scaled');
xlabel('Temperature'); ylabel('Wind Speed');

subplot(2,2,4);
scatter(filtered_data(:,1), filtered_data(:,2), 20, 'filled');
title('Cleaned Data (No Outliers)');
xlabel('Temperature'); ylabel('Wind Speed');

%% 5. 递归密度估计（KDE）- 针对 Temperature  https://ww2.mathworks.cn/help/stats/ksdensity.html
%% 多变量 KDE 可视化
figure('Name','KDE of All Features','NumberTitle','off');
hold on;

feature_names = {'Temperature', 'Humidity', 'Wind Speed','Wind Direction','Precipitation'}; % 修改为你实际的数据列名
colors = lines(length(feature_names)); % 自动生成不同颜色

for i = 1:length(feature_names)
    data_column = raw_data(:, i);        % 取第 i 列数据
    [f, xi] = ksdensity(data_column);    % 计算核密度估计
    plot(xi, f, 'LineWidth', 2, 'Color', colors(i,:)); % 绘制 KDE 曲线
end

title('Kernel Density Estimation for All Features');
xlabel('Value');
ylabel('Density');
legend(feature_names, 'Location', 'northeast');
grid on;
hold off;


%The ksdensity function in MATLAB is used to estimate the probability density function (pdf) 
%of a given data set using kernel smoothing. This function is particularly useful
%for visualizing the distribution of data.

%% 6. 主成分分析（PCA）降维可视化
[coeff, score, ~] = pca(raw_data);

figure('Name','PCA 2D Projection','NumberTitle','off');
scatter(score(:,1), score(:,2), 20, 'filled');
title('PCA - 2D Projection of Climate Data');
xlabel('Principal Component 1');
ylabel('Principal Component 2');
grid on;
%主成分分析 (PCA) 是一种统计方法，它可以通过正交变换将一组可能相关的变量转换成一组线性不相关的变量，这些不相关变量称为主成分。
% 在 MATLAB 中，PCA 可以通过 pca 函数实现，该函数能够从数据集中提取主成分，并用于数据降维、特征提取等多种场景。