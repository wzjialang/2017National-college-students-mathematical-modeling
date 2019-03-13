clear;clc;close all;
data=xlsread('data.xlsx','sheet1');%任务
data4=xlsread('data.xlsx','sheet4');%人数和限额
 % data1为sheet1中的数据
tasknumber=length(data);
 % tasknumber为附录2任务总数量
x=data(:,1);
y=data(:,2);
 % x,y分别表示data4当中各任务的坐标
 
%price=data4(:,3);
%response=data4(:,4);



% 得到各数据
data2=xlsread('data.xlsx','sheet2'); %额度和信誉值
%data2主要为sheet2中关于会员的数据
huiyuan=data4(:,1:2); 
%huiyuan为会员经纬度坐标
xiane=data4(:,3);
%xiane是每位会员的配额

data3=xlsread('data.xlsx','sheet3');
xinyu=data2(:,2);
% 会员信誉表
set_valid=unique([find(and(huiyuan(:,1)>22,huiyuan(:,1)<24)); find(and(huiyuan(:,2)>112,huiyuan(:,2)<115))]); 
% 数据处理
huiyuan_valid=huiyuan(set_valid,:);

% 开始计算
center=mean(huiyuan_valid);
% 中心点坐标 会员的中心点
huiyuan_cart=zeros(size(huiyuan_valid));
% coord_cart是一个任务个数×任务个数的零方阵
for i=1:size(huiyuan_valid,1)
    [x,y]=jingweizhuanhuan(center(1),center(2),huiyuan_valid(i,1),huiyuan_valid(i,2));
    huiyuan_cart(i,1)=x;% 该会员坐标到中心点的横向距离
    huiyuan_cart(i,2)=y;% 该会员坐标到中心点的纵向距离
end

%% 计算所需指标
task_cart=zeros(tasknumber,2);
%任务坐标表



for iTask=1:tasknumber 
    [x,y]=jingweizhuanhuan(center(1),center(2),data(iTask,1),data(iTask,2));

     task_cart(iTask,:)=[x y];%任务相对于会员中心的坐标
    
end



edge_box=9;
area=edge_box^2;
% 选取一个边长为9的正方形
peiemidu=zeros(tasknumber,1);
shenqi=ones(size(huiyuan_valid,1),1);
% 全1的会员列矩阵
shenqi2=ones(tasknumber,1);
% 全1的任务列矩阵
renkoumidu=zeros(tasknumber,1);
xiyujunzhi=zeros(tasknumber,1);
renwumidu=zeros(tasknumber,1);

xin_renwumidu=zeros(tasknumber,1);

for iTask=1:tasknumber
    x=task_cart(iTask,1);
    y=task_cart(iTask,2);
    %任务的相对坐标
    in_box=intersect(find(and(huiyuan_cart(:,1)>x-edge_box/2, huiyuan_cart(:,1)<x+edge_box/2)), find(and(huiyuan_cart(:,2)>y-edge_box/2,huiyuan_cart(:,2)<y+edge_box/2)));
    % 筛选得到范围内会员的编号
    in_box2=intersect(find(and(task_cart(:,1)>x-edge_box/2, task_cart(:,1)<x+edge_box/2)), find(and(task_cart(:,2)>y-edge_box/2,task_cart(:,2)<y+edge_box/2)));
    % 筛选得到范围内任务的编号
    renkoumidu(iTask)=sum(shenqi(in_box))/area;
    % 单位面积内会员的总数
    peiemidu(iTask)=sum(xiane(in_box))/area;
    % 单位面积内配额的总量
    xiyujunzhi(iTask)=sum(xinyu(in_box))/area;
     % 单位面积内信誉值总和
    renwumidu(iTask)=sum(shenqi2(in_box2))/area;
     % 单位面积内任务个数总和
    
end


