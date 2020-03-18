addpath('.\Functions');
addpath('.\MyFunctions');
path = 'E:\超声刺激\US RECORD\12_28\E2_processing\';
[X_old,USindex,ESindex] = dataLoad(path);

%global parameters
%parameters =[];

%% ================== Part 1: Preprocessing ===================
step = 100;    %step
fprintf('\n\n进行预处理操作\n\n');
alpha = 1/2.5;     %E1参数
%alpha = 1.5;       %E2参数
%alpha = 2.3;        %12_24 E2参数
%alpha = 37;        %12_24 E3参数
%alpha = 8;        %12_24 E1参数
[X,length,Max,Min,mu] = preprocessing(X_old,step,alpha);    %调用预处理
preprocessing_visualization(path,X_old,X,length,USindex,ESindex,Max,Min,mu);

%test

%figure;
%histogram(X);

%figure
%[f,t] = ecdf(X);
%plot(t,f);
