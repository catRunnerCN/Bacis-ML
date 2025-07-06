function Iris(P)
%主函数
%P为子集最大样例所占比例，取值应在[0，1]内
[attrib]=Iris_tree_preprocess();
tree= Iris_tree(attrib,P);
A=cell(1,1);
[A,]=prev(tree,A,1,0);
print_tree(A,P)
end
 
function print_tree(A,P)
%打印树
for i=1:length(A)
    nodes(1,i)=A{i,2};
end
treeplot(nodes)
[x,y]=treelayout(nodes);
x=x';
y=y';
%name1=cellstr(num2str((1:count)'));
for i=1:length(A)
   name{i,1}=A{i,1};
end
 
text(x(:,1),y(:,1),name,'VerticalAlignment','bottom','HorizontalAlignment','right')
d=num2str(100*P);
s=strcat('鸢尾花决策树  精确度为',d,'%');
title({s},'FontSize',12,'FontName','宋体');
end
 
function [A,i]=prev(T,A,i,j)
%遍历树 并产生可以被treeplot用来画图的结点序列
% 输入i应为1;j应为0；
%% 函数迭代过程中传递不了A值，所以要在输入和输出上将cell设为变量
if isstruct(T)==1 && (strcmp(T.left,'null')==0 || strcmp(T.right,'null')==0)
   A{i,1}=T.value;
   A{i,2}=j;
   i=i+1;j=i-1;
   %% i随迭代不断增加，但j是固定在每步迭代当中
   [A,i]=prev(T.left,A,i,j);
   i=i+1;
   [A,i]=prev(T.right,A,i,j);
else if isstruct(T)==1 && strcmp(T.left,'null')==1 && strcmp(T.right,'null')==1
        A{i,1}=T.value;
        A{i,2}=j;
    else
    A{i,1}=T;
    A{i,2}=j;
    end
end
end
 
 
 
 
 
function [ tree ] = Iris_tree(attrib,P)
%P为子集最大样例所占比例，取值应在[0，1]内
tree = struct('value', 'null', 'left', 'null', 'right', 'null');
numberExamples = length(attrib(:,1));
    num_class_1=sum(attrib(:,5)==1);
    num_class_2=sum(attrib(:,5)==2);
    num_class_3=sum(attrib(:,5)==3);
I_parent=-((num_class_1/numberExamples)*log(num_class_1/numberExamples)+(num_class_2/numberExamples)*log(num_class_2/numberExamples)+(num_class_3/numberExamples)*log(num_class_3/numberExamples));
% 节点熵
[point,class,num_diff,gain]=Gain(attrib);
if  num_class_1>max( num_class_2, num_class_3)
tree.value=1;
else if num_class_2< num_class_3
        tree.value=3;
    else
        tree.value=2;
    end
end
if I_parent>gain
 
tree.value=[class,point];
attrib=sortrows(attrib,class);
% 按照选中的属性排序
attrib_0=attrib(1:num_diff,:);
attrib_1=attrib(num_diff:end,:);
%划分样本子集
if ~isempty(attrib_0)
 
num_0=length(attrib_0(:,1));
    value_class_1=sum(attrib_0(:,5)==1);
    value_class_2=sum(attrib_0(:,5)==2);
    value_class_3=sum(attrib_0(:,5)==3);
 
if  value_class_1>max( value_class_2, value_class_3)
tree.left=1;
else if  value_class_2< value_class_3
        tree.left=3;
    else
        tree.left=2;
    end
end
 
 
if num_0~=bijiao( value_class_1, value_class_2, value_class_3) && bijiao( value_class_1, value_class_2, value_class_3)/num_0<P
    tree.left=Iris_tree(attrib_0,P);
end
end
 
if ~isempty(attrib_1)
 
num_1=length(attrib_1(:,1));
    value_class_1=sum(attrib_1(:,5)==1);
    value_class_2=sum(attrib_1(:,5)==2);
    value_class_3=sum(attrib_1(:,5)==3);
 
if  value_class_1>max( value_class_2, value_class_3)
tree.right=1;
else if  value_class_2< value_class_3
        tree.right=3;
    else
        tree.right=2;
    end
end
 
 
if num_1~=bijiao( value_class_1, value_class_2, value_class_3) && bijiao( value_class_1, value_class_2, value_class_3)/num_1<P
    tree.right=Iris_tree(attrib_1,P);
end
end
 
 
end
 
 
 
end
 
function max=bijiao(a,b,c)
%三个函数取最大
max=a;
if max<b
max=b;
end
if max<c
max=c;
end
end
 
function [point,class,num_diff,gain]=Gain(attrib)
%求熵，并根据最小熵进行划分子集
% point 划分的数值
% class 划分类别
% num_diff 划分的小子集基数
numberExamples = length(attrib(:,1));
attri{1,1}=sortrows(attrib,1);
attri{1,2}=sortrows(attrib,2);
attri{1,3}=sortrows(attrib,3);
attri{1,4}=sortrows(attrib,4);
% 按照某行排序
class=1;
point=0;
gain=20;
 
for s=1:4
    j=1;
    clear  different
for i=1:numberExamples-1
    if attri{1,s}(i,5)~=attri{1,s}(i+1,5)
        different(j)=i;
        j=j+1;
    end
end
 
for i=1:length(different)
    classs=s;
    pointt=attri{1,s}(different(i),s);
    num_class_1=sum(attri{1,s}((1:different(i)),5)==1);
    num_class_2=sum(attri{1,s}((1:different(i)),5)==2);
    num_class_3=sum(attri{1,s}((1:different(i)),5)==3);
    num0_class_1=sum(attri{1,s}(:,5)==1)- num_class_1;
    num0_class_2=sum(attri{1,s}(:,5)==2)- num_class_2;
    num0_class_3=sum(attri{1,s}(:,5)==3)- num_class_3;
    
    gainn=-(different(i)/numberExamples)*((num_class_1/different(i))*sjlog(num_class_1/different(i))+(num_class_2/different(i))*sjlog(num_class_2/different(i))+(num_class_3/different(i))*sjlog(num_class_3/different(i)))-(1-different(i)/numberExamples)*((num0_class_1/(numberExamples-different(i)))*sjlog(num0_class_1/(numberExamples-different(i)))+(num0_class_2/(numberExamples-different(i)))*sjlog(num0_class_2/(numberExamples-different(i)))+(num0_class_3/(numberExamples-different(i)))*sjlog(num0_class_3/(numberExamples-different(i))));
   %计算熵
    if gainn<gain
        point=pointt;
        class=classs;
        gain=gainn;
        num_diff=different(i);
    end
    
end
end
end
 
function y = sjlog(x)
%% 重新定义,使0*log0=0
if x==0
y = 0;
else
y = log(x);
end
end
 
 
function [attrib] = Iris_tree_preprocess()
    % 直接从 iris_dataset.mat 文件中读取训练数据
    data = load('iris_dataset.mat');  % 确保 iris_dataset.mat 路径正确

    % 将 train_data 和 train_label 合并为一个 attrib 矩阵
    % attrib 的最后一列为标签，其余为属性
    attrib = [data.train_data, data.train_label];
end
