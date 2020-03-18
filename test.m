addpath('.\Functions');
addpath('.\MyFunctions');
path = 'E:\�����̼�\US RECORD\12_28\E2_processing\';
[X_old,USindex,ESindex] = dataLoad(path);

%global parameters
%parameters =[];

%% ================== Part 1: Preprocessing ===================
step = 100;    %step
fprintf('\n\n����Ԥ�������\n\n');
alpha = 1/2.5;     %E1����
%alpha = 1.5;       %E2����
%alpha = 2.3;        %12_24 E2����
%alpha = 37;        %12_24 E3����
%alpha = 8;        %12_24 E1����
[X,length,Max,Min,mu] = preprocessing(X_old,step,alpha);    %����Ԥ����
preprocessing_visualization(path,X_old,X,length,USindex,ESindex,Max,Min,mu);

%test

%figure;
%histogram(X);

%figure
%[f,t] = ecdf(X);
%plot(t,f);
