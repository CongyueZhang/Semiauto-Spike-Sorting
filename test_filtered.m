%读取数据
addpath('.\Functions');
addpath('.\MyFunctions');

path = 'E:\超声刺激\US RECORD\12_28\E1_processing\';

[X_old,USindex,ESindex] = dataLoad(path);       %读取数据，详见dataLoad Function

parameters =[];


%滤波代码
X_filtered = fix_filter(X_old);

step = 500;    %step
k = 5;
[X,parameters] = preprocessing(X_old,step,parameters,k);    %调用预处理

X_filtered = X_filtered(1:parameters.length);
preprocessing_visualization(path,X,X_filtered,parameters,USindex,ESindex);    