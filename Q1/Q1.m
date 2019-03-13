clear;clc;close all;
data=xlsread('data.xlsx','sheet1');
nTask=length(data); % the number of taskresponse=data(:,4); % yes/no
x=data(:,1);
y=data(:,2);
price=data(:,3);
response=data(:,4);


%% part1: data visualization
figure(1);
subplot(2,2,1);
color=repmat([1 0 0],nTask,1);
color(find(response==0),:)=repmat([0 0 1],sum(response==0),1);
scatter3(x,y,price,price/4,color,'filled');%,'MarkerFaceAlpha',0.25);
title('Scatterplot of the data');
xlabel('weidu');ylabel('jingdu');zlabel('price');hold on;

% get the coordinate of the members
data2=xlsread('data.xlsx','sheet4'); % latitudes / longitudes of members
coord=data2(:,1:2);
weight=data2(:,3);
%% to exlude outliers of the location of the members
set_valid=unique([find(and(coord(:,1)>22,coord(:,1)<24)); find(and(coord(:,2)>112,coord(:,2)<115))]); % data clean
coord_set_valid=coord(set_valid,:);
weight=weight(set_valid);
scatter3(coord_set_valid(:,1),coord_set_valid(:,2),zeros(size(coord_set_valid,1),1),weight,[0 0.6 0],'filled');%,'MarkerFaceAlpha',0.25);
xlim([22 24]);ylim([112 116]);

subplot(2,2,2);
scatter3(x,y,price,price/4,color,'filled');hold on;
scatter3(coord_set_valid(:,1),coord_set_valid(:,2),zeros(size(coord_set_valid,1),1),weight,[0 0.6 0],'filled');
xlabel('weidu');ylabel('jingdu');zlabel('price');
view(90,90);
set(gcf,'position',[100 200 1400 400]);


subplot(2,2,3);
scatter3(x,y,price,price/4,color,'filled');hold on;
scatter3(coord_set_valid(:,1),coord_set_valid(:,2),zeros(size(coord_set_valid,1),1),weight,[0 0.6 0],'filled');
xlabel('weidu');ylabel('jingdu');zlabel('price');
view(0,0);

subplot(2,2,4);
scatter3(x,y,price,price/4,color,'filled');hold on;
scatter3(coord_set_valid(:,1),coord_set_valid(:,2),zeros(size(coord_set_valid,1),1),weight,[0 0.6 0],'filled');
xlabel('weidu');ylabel('jingdu');zlabel('price');
view(90,0);
set(gcf,'position',[100 00 900 900]);

%%
% calculate the coordinate of all members
center=mean(coord_set_valid);
coord_cart=zeros(size(coord_set_valid));
for i=1:size(coord_set_valid,1)
    [x,y]=ToCartesian(center(1),center(2),coord_set_valid(i,1),coord_set_valid(i,2));
    coord_cart(i,1)=x;
    coord_cart(i,2)=y;
end

%% calculate the avalable work force in unit area
coord_task_cart=zeros(nTask,2);
for iTask=1:nTask
    [x,y]=ToCartesian(center(1),center(2),data(iTask,1),data(iTask,2));
    coord_task_cart(iTask,:)=[x y];
end


figure(2);
edge_box=9;
area=edge_box^2;
density=zeros(nTask,1);
for iTask=1:nTask
    x=coord_task_cart(iTask,1);
    y=coord_task_cart(iTask,2);
    in_box=intersect(find(and(coord_cart(:,1)>x-edge_box/2, coord_cart(:,1)<x+edge_box/2)), find(and(coord_cart(:,2)>y-edge_box/2,coord_cart(:,2)<y+edge_box/2)));
    density(iTask)=sum(weight(in_box))/area;
end
% subplot(2,5,i);
scatter(density,price,10,'filled')
xlabel('avaiable work force per unit area');
ylabel('price');

[mdl,dev,stats] = glmfit([density price],response, 'binomial', 'link', 'logit');
yfit = glmval(mdl,[density price],'probit');
y=zeros(size(response));
y(yfit>0.5)=1;
scatter(1:length(response-y), response-y,20,'filled','k');

accuracy=sum(response-y==0)/length(y);
[edge_box accuracy]


