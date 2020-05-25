function X = spikeSorting(path,d,channelNumber)
global data;
global parameters;
parameters = [];

%读取数据
addpath('E:\超声刺激\data processing\project\matlab\Functions');
addpath('E:\超声刺激\data processing\project\matlab\MyFunctions');
addpath('E:\超声刺激\data processing\project\matlab\MyFunctions\plotting');

path = [path '\'];

warning('off','signal:findpeaks:largeMinPeakHeight');

[X_old,data.USindex,data.ESindex,channelNumber] = dataLoad(path,channelNumber);

%多通道
data.waveforms = cell(1,8);            %每一行是一个waveforms； size(data.waveforms,1) = waveforms个数，size(data.waveforms,2) = 每个waveforms的点数
data.spiketimes = cell(1,8);
data.USindex = [];
data.ESindex = [];
data.abnormalWaveforms = cell(1,8);
data.abnormalSpiketimes = cell(1,8);
%% ================== Part 1: Preprocessing ===================
fprintf('\n\nPreprocessing Loading ...\n');
d.Message = 'Preprocessing ...';
k = 5;

%while(k)
    step = 1000;    %step
    [X,parameters] = preprocessing(X_old,step,parameters,k);    %调用预处理
    preprocessing_visualization(path,X_old,X);    
%    prompt = ['k = ' num2str(k)  '（若合适，请输入0；不合适，请输入新的k值）：'];
%    k = input(prompt);
%end
%% ================== Part 2: Spikes detection ===================
fprintf('\n\nSpikes detectiong Loading ...\n');
d.Message = 'Spikes detectiong ...';
t = 10;              %spike的长度，单位ms
ratio = 1/2;        %最高峰时间坐标的比例 

spikedetection(X,t*10,parameters,ratio);
%% ================== Part 3: Feature Extraction ===================
data.features = zeros(size(data.waveforms,1),5);
featureExtraciton_smooth(t*10,ratio);

%% ================== Part 4: Clustering ===================
%clusterSorting(features,data,parameters);      

%半自动
%Spikesinterp();
data.idx = zeros(size(data.waveforms,1),1);
%RL_FCM(data.features);

%v = max(max(data.features2(:,3)),max(data.features2(:,5)));
%alpha = t*10/0.9/v;
%data.features2(:,5) = alpha*data.features2(:,5);

%暂时注释
d.Message = 'Clustering ...';
clustering_GMMs();

%frequency_visualization(path,data,idx,parameters,USindex,ESindex);

end