global data;
global parameters;
data.USindex = [];
data.ESindex = [];
data.waveforms = [];
data.spiketimes = [];
data.abnormalWaveforms = [];
data.abnormalSpiketimes = [];
parameters =[];

%��ȡ����
addpath('E:\�����̼�\data processing\project\matlab\Functions');
addpath('E:\�����̼�\data processing\project\matlab\MyFunctions');
addpath('E:\�����̼�\data processing\project\matlab\MyFunctions\plotting');

path = 'E:\�����̼�\US RECORD\12_28\E1_processing\';

warning('off','signal:findpeaks:largeMinPeakHeight');

[X_old,data.USindex,data.ESindex] = dataLoad(path);       %��ȡ���ݣ����dataLoad Function

%% ================== Part 1: Preprocessing ===================

fprintf('\n\nPreprocessing Loading ...\n');
k = 5;

step = 1000;    %step
[X,parameters] = preprocessing(X_old,step,parameters,k);    %����Ԥ����
preprocessing_visualization(path,X_old,X);    

%% ================== Part 2: Spikes detection ===================
fprintf('\n\nSpikes detectiong Loading ...\n');
t = 10;              %spike�ĳ��ȣ���λms
ratio = 1/2;        %��߷�ʱ������ı��� 

spikedetection(X,t*10,parameters,ratio);

figure;
for i = 1:size(data.abnormalWaveforms,1)
    plot(data.abnormalWaveforms(i,:));
    pause;
end