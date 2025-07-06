function [EMF,Recommendation_idx] = recommender(data,prototype_idx)

prototypes = data(prototype_idx,:);
[len_pro,width_pro] = size(prototypes);
[len_data, width_data] = size(data);
EMF = zeros(len_data,len_pro);
dist = pdist2(prototypes,data);
[~,seq] = min(dist,[],1);
std_dev = zeros(len_pro,width_pro);
for i = 1:1:len_pro
    seq2 = find(seq == i);
    std_dev(i,:) = std(data(seq2,:),1).^2;
end
% for i = 1:1:len_pro
%     EMF_data = data(:,1:width_pro);
%     EMF_prototype = prototypes(i,1:width_pro);
%     rep_EMF_prototype = repmat(EMF_prototype,len_data,1);
%     EMF_std_dev = std_dev(i,1:width_pro);
%     EMF(:,i) = 1./(1+(sum(((EMF_data - rep_EMF_prototype).^2),2))/ sum(EMF_std_dev));
% end
EMF = 1 ./ (1 + pdist2(data, prototypes, 'euclidean').^2 ./ sum(std_dev, 2)');
% Recommendation_idx = [];
% seq = 1:1:len_data;
% seq(prototype_idx) = [];
% for ii = 1:1:len_pro
%     temp = find(EMF(seq,ii)>0.85);
%     match_temp = seq(temp);
%     tran_temp = match_temp;
%     if ~isempty(tran_temp)
%         Recommendation_idx = [Recommendation_idx; prototype_idx(ii); tran_temp(:)];
%     end
% end

N = 5;
Recommendation_idx = [];
seq = 1:1:len_data;
seq(prototype_idx) = [];
for ii = 1:1:len_pro
    [~, sorted_idx] = sort(EMF(seq, ii), 'descend');
    topN = seq(sorted_idx(1:N));
    Recommendation_idx = [Recommendation_idx; prototype_idx(ii); topN(:)];
end

