function [continuousdata,MembershipDegree] = ContinuousMembershipFunctionPlotting(data,prototype_idx)

prototypes = data(prototype_idx ,:);
[L,W] = size(prototypes);
N = size(data,1);
dist = pdist2(prototypes,data);
[~,seq] = min(dist,[],1);
miu = zeros(L,W);
stan = zeros(L,W);
for i = 1:1:L
seq2 = find(seq == i);
miu(i,:) = mean(data(seq2,:),1);
stan(i,:) = std(data(seq2,:),1).^2;
end
seq = 0:0.001:1;
continuousdata = repmat(seq',1,W);
MembershipDegree = zeros(W,length(seq),L);
for j = 1:1:W
    for i = 1:1:L
        MembershipDegree(j,:,i) = stan(i,j)./((continuousdata(:,j)-prototypes(i,j)).^2+stan(i,j));
    end
end

end