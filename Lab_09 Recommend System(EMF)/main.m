load BrandNewCarsData.mat; 
%load SecondHandCarsData.mat;
display(seen_cars);

flag = true; 
while flag
prototype_idx = input...
('Please choose IDs of the cars from the list [a,b,c,...]: '); 
if ismember(prototype_idx,seen_cars.Car_ID)
flag = false;
end
end

data1=table2array(data(:,3:5)); 
normalized_data=[];
for i=1:1:size(data1,2)
    normalized_data=[normalized_data,(data1(:,i)-min(data1(:,i)))...
        ./(max(data1(:,i))-min(data1(:,i)))];
end

[EMF,Recommendation_idx]=recommender(normalized_data,prototype_idx);

[cont_data, MembershipDegree] = ContinuousMembershipFunctionPlotting(normalized_data,prototype_idx);

%%print result

figure 
ii=1;
for jj=1:1:size(MembershipDegree,3) 
plot(cont_data(:,ii)*(max(data1(:,ii))-min(data1(:,ii)))...
+min(data1(:,ii)),MembershipDegree(ii,:,jj),'-','linewidth',2) 
hold on
end 
axis([min(data1(:,ii)),max(data1(:,ii)),0,1]); 
plot(data1(prototype_idx,ii),...
ones(size(MembershipDegree,3),1),'k.','markersize',18) 
xlabel('Price (GBP)')
ylabel('Membership Degree') 
set(gca,'fontsize',14)
figure 
ii = 2;
for jj = 1:1:size(MembershipDegree,3) 
plot(cont_data(:,ii)*(max(data1(:,ii))-min(data1(:,ii)))...
+min(data1(:,ii)),MembershipDegree(ii,:,jj),'-','linewidth',2) 
hold on
end 
plot(data1(prototype_idx,ii),...
ones(size(MembershipDegree,3),1),'k.','markersize',18) 
axis([min(data1(:,ii)),max(data1(:,ii)),0,1]); 
xlabel('Fuel Consumption (MPG)')
ylabel('Membership Degree') 
set(gca,'fontsize',14)
figure 
ii = 3;
for jj = 1:1:size(MembershipDegree,3) 
plot(cont_data(:,ii)*(max(data1(:,ii))-min(data1(:,ii)))...
+min(data1(:,ii)),MembershipDegree(ii,:,jj),'-','linewidth',2) 
hold on
end 
plot(data1(prototype_idx,ii),...
ones(size(MembershipDegree,3),1),'k.','markersize',18) 
axis([min(data1(:,ii)),max(data1(:,ii)),0,1]); 
xlabel('Speed (MPH)')
ylabel('Membership Degree'); 
set(gca,'fontsize',14)
data(Recommendation_idx,:)
%show_recommendations(data, prototype_idx);