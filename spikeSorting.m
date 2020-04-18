function data = spikeSorting(path)

%读取数据
addpath('E:\超声刺激\data processing\project\matlab\Functions');
addpath('E:\超声刺激\data processing\project\matlab\MyFunctions');
addpath('E:\超声刺激\data processing\project\matlab\MyFunctions\plotting');


%path = [path '\']

path = 'E:\超声刺激\US RECORD\12_28\E1_processing\';

[X_old,USindex,ESindex] = dataLoad(path);       %读取数据，详见dataLoad Function

parameters =[];

%多通道
%data.waveforms = cell(1,1);            %每一行是一个waveforms； size(data.waveforms,1) = waveforms个数，size(data.waveforms,2) = 每个waveforms的点数
%data.spiketimes = cell(1,1);

global data;
data.waveforms = [];
data.spiketimes = [];
data.abnormalWaveforms = [];
data.abnormalSpiketimes = [];

%% ================== Part 1: Preprocessing ===================

fprintf('\n\nPreprocessing Loading ...\n');
k = 5;

%while(k)
    step = 1000;    %step
    [X,parameters] = preprocessing(X_old,step,parameters,k);    %调用预处理
    preprocessing_visualization(path,X_old,X,parameters,USindex,ESindex);    
%    prompt = ['k = ' num2str(k)  '（若合适，请输入0；不合适，请输入新的k值）：'];
%    k = input(prompt);
%end

%% ================== Part 2: Spikes detection ===================
fprintf('\n\nSpikes detectiong Loading ...\n');
t = 8;              %spike的长度，单位ms
ratio = 1/10;        %最高峰时间坐标的比例 

spikedetection(X,t*10,parameters,ratio);

%n = 25;
%spikes_visualization(X,data,n,parameters);        

%% ================== Part 3: Feature Extraction ===================
%features = featureExtraction(data,parameters);

%% ================== Part 4: Clustering ===================
%clusterSorting(features,data,parameters);      

%半自动
%Spikesinterp();
data.idx = zeros(size(data.waveforms,1),1);

%v = max(max(data.features2(:,3)),max(data.features2(:,5)));
%alpha = t*10/0.9/v;
%data.features2(:,5) = alpha*data.features2(:,5);

%clustering_GMMs(data,path);


%frequency_visualization(path,data,idx,parameters,USindex,ESindex);

end