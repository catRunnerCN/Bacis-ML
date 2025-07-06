function show_recommendations(data, prototype_idx)
    % Step 1: 提取数值型特征数据（第3到第7列）
    numeric_data = table2array(data(:, 3:end));

    % Step 2: 提取原型向量
    prototypes = numeric_data(prototype_idx, :);
    [len_pro, width_pro] = size(prototypes);
    [len_data, ~] = size(numeric_data);

    % Step 3: 计算距离和最近原型
    dist = pdist2(prototypes, numeric_data);
    [~, seq] = min(dist, [], 1);

    % Step 4: 计算每类的方差
    std_dev = zeros(len_pro, width_pro);
    for i = 1:len_pro
        seq2 = find(seq == i);
        std_dev(i, :) = std(numeric_data(seq2,:), 1).^2;
    end

    % Step 5: 计算EMF
    EMF = zeros(len_data, len_pro);
    for i = 1:len_pro
        EMF_data = numeric_data;
        rep_EMF_prototype = repmat(prototypes(i,:), len_data, 1);
        EMF_std_dev = std_dev(i,:);
        EMF(:,i) = 1 ./ (1 + (sum((EMF_data - rep_EMF_prototype).^2, 2)) / sum(EMF_std_dev));
    end

  % Step 6: 获取每个数据点对所有原型的最大隶属度
[max_emf, ~] = max(EMF, [], 2);

% 排除原型车辆
all_idx = 1:len_data;
non_proto_idx = setdiff(all_idx, prototype_idx);

% 在非原型车辆中找到隶属度最高的前 10 个
[~, sort_idx] = sort(max_emf(non_proto_idx), 'descend');
top10_idx = non_proto_idx(sort_idx(1:10));

% 输出推荐结果
disp('Top 10 Recommended cars based on highest EMF value:');
disp(data(top10_idx, :));

% % Step 6: 基于阈值推荐
% Recommendation_idx = [];
% seq_all = 1:len_data;
% seq_all(prototype_idx) = [];
% 
% for ii = 1:len_pro
%     temp = find(EMF(seq_all, ii) > 0.85);
%     match_temp = seq_all(temp);
% 
%     if ~isempty(match_temp)
%         Recommendation_idx = [Recommendation_idx; match_temp(:)];
%     end
% end
% 
% % 添加原型
% Recommendation_idx = [Recommendation_idx; prototype_idx(:)];
% Recommendation_idx = unique(Recommendation_idx);

end
