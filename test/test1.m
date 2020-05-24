global data;
global parameters;
data.USindex = [];
data.ESindex = [];
data.waveforms = [];
data.spiketimes = [];
data.abnormalWaveforms = [];
data.abnormalSpiketimes = [];
parameters =[];

%读取数据
addpath('E:\超声刺激\data processing\project\matlab\Functions');
addpath('E:\超声刺激\data processing\project\matlab\MyFunctions');
addpath('E:\超声刺激\data processing\project\matlab\MyFunctions\plotting');

path = 'E:\超声刺激\US RECORD\12_28\E1_processing\';

warning('off','signal:findpeaks:largeMinPeakHeight');

[X_old,data.USindex,data.ESindex] = dataLoad(path);       %读取数据，详见dataLoad Function

%% ================== Part 1: Preprocessing ===================

fprintf('\n\nPreprocessing Loading ...\n');
k = 5;

step = 1000;    %step
[X,parameters] = preprocessing(X_old,step,parameters,k);    %调用预处理
preprocessing_visualization(path,X_old,X);    

%% ================== Part 2: Spikes detection ===================
fprintf('\n\nSpikes detectiong Loading ...\n');
t = 10;              %spike的长度，单位ms
ratio = 1/2;        %最高峰时间坐标的比例 

spikedetection(X,t*10,parameters,ratio);

figure;
for i = 1:size(data.abnormalWaveforms,1)
    plot(data.abnormalWaveforms(i,:));
    pause;
end