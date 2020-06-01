function X = spikeSorting(d,X_old)
global data;
global ch;

warning('off','signal:findpeaks:largeMinPeakHeight');

%多通道
data.waveforms = cell(1,9);            %每一行是一个waveforms； size(data.waveforms,1) = waveforms个数，size(data.waveforms,2) = 每个waveforms的点数
data.spiketimes = cell(1,9);
data.abnormalWaveforms = cell(1,9);
data.abnormalSpiketimes = cell(1,9);
data.features = cell(1,9);
data.idx = cell(1,9);
%% ================== Part 1: Preprocessing ===================
fprintf('\n\nPreprocessing Loading ...\n');
d.Message = 'Preprocessing ...';
k = 5;

%while(k)
    step = 1000;    %step
    [X] = preprocessing(X_old,step,k);    %调用预处理
    preprocessing_visualization(X_old{ch},X{ch});    
%    prompt = ['k = ' num2str(k)  '（若合适，请输入0；不合适，请输入新的k值）：'];
%    k = input(prompt);
%end
%% ================== Part 2: Spikes detection ===================
fprintf('\n\nSpikes detectiong Loading ...\n');
d.Message = 'Spikes detectiong ...';
t = 10;              %spike的长度，单位ms
ratio = 1/2;        %最高峰时间坐标的比例 

spikedetection(X,t*10,ratio);
%% ================== Part 3: Feature Extraction ===================
featureExtraciton_smooth(t*10,ratio);

%% ================== Part 4: Clustering ===================
%v = max(max(data.features2(:,3)),max(data.features2(:,5)));
%alpha = t*10/0.9/v;
%data.features2(:,5) = alpha*data.features2(:,5);

d.Message = 'Clustering ...';
clustering_GMMs();

end