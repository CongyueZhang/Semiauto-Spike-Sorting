%��ȡ����
addpath('.\Functions');
addpath('.\MyFunctions');

path = 'E:\�����̼�\US RECORD\12_28\E1_processing\';

[X_old,USindex,ESindex] = dataLoad(path);       %��ȡ���ݣ����dataLoad Function

parameters =[];


%�˲�����
X_filtered = fix_filter(X_old);

step = 500;    %step
k = 5;
[X,parameters] = preprocessing(X_old,step,parameters,k);    %����Ԥ����

X_filtered = X_filtered(1:parameters.length);
preprocessing_visualization(path,X,X_filtered,parameters,USindex,ESindex);    