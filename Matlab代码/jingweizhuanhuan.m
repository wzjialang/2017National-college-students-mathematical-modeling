 function [x,y]=jingweizhuanhuan(lat1,log1,lat2,log2)
%  定义一个可以将经纬度之差转化成距离坐标之差的函数
x=distance(lat1,log1,lat2,log1)/180*pi*6370;
y=distance(lat1,log1,lat1,log2)/180*pi*6370;
if log2>log1
     x=-x;   
end
if lat2>lat1
    y=-y;
end

