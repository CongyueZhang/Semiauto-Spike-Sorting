%��ȡ����
addpath('.\Functions');
addpath('.\MyFunctions');

path = 'E:\�����̼�\US RECORD\12_28\E2_processing\';

[X_old,USindex,ESindex] = dataLoad(path);       %��ȡ���ݣ����dataLoad Function

global parameters
parameters =[];

data.waveforms = [];
data.spiketimes = [];

%% ================== Part 1: Preprocessing ===================
step = 500;    %step
fprintf('\n\nPreprocessing Loading ...\n');

k = 4;
[X,parameters] = preprocessing(X_old,step,parameters,k);    %����Ԥ����
preprocessing_visualization(path,X_old,X,parameters,USindex,ESindex);    

%% ================== Part 2: Spikes detection ===================
fprintf('\n\nSpikes detectiong Loading ...\n');
t = 9;   %spike�ĳ��ȣ���λms
[data] = spikedetection(X,t*10,parameters,data);

%n = 25;
%spikes_visualization(X,data,n,parameters);        

%% ================== Part 3: Feature Extraction ===================
[features] = featureExtraction(data,parameters);

%% ================== Part 4: Spikes sorting ===================
%clusterSorting(features,data,parameters);

%frequency_visualization(path,data,idx,parameters,USindex,ESindex);