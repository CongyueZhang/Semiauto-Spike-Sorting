%读取数据
addpath('E:\超声刺激\data processing\project\matlab\Functions');
addpath('E:\超声刺激\data processing\project\matlab\MyFunctions');
addpath('E:\超声刺激\data processing\project\matlab\MyFunctions\plotting');

path = 'E:\超声刺激\US RECORD\12_28\E4_processing\';

[X_old,USindex,ESindex] = dataLoad(path);       %读取数据，详见dataLoad Function

parameters =[];

global data;

data.waveforms = [];
data.spiketimes = [];
data.abnormalWaveforms = [];
data.abnormalSpiketimes = [];

%% ================== Part 1: Preprocessing ===================
fprintf('\n\nPreprocessing Loading ...\n');
step = 1000;    %step
k = 5;
[X,parameters] = preprocessing(X_old,step,parameters,k);    %调用预处理

%X_filtered = fix_filter(X_old);
%X_filtered = X_filtered(1:parameters.length)';
%% ================== Part 2: Spikes detection ===================
fprintf('\n\nSpikes detectiong Loading ...\n');
ratio = 1/2;        %最低峰时间坐标的比例 
t = 9;
spikedetection(X,t*10,parameters,ratio);
m = size(data.waveforms,2);
t = 1:m;

threshold = min(parameters.ceil,abs(parameters.floor));
threshold = threshold/2;
for i = 1 : size(data.waveforms,1)
    
    clf;
    [smooth,window] = smoothdata(data.waveforms(i,:),'gaussian');
    [pkt,lct] = findpeaks(abs(smooth),'MinPeakHeight',threshold);
    
    plot(t,data.waveforms(i,:),'-o',t,smooth,'-x');
    legend('Original Data','Smoothed Data')
    
    hold on;
    plot(lct,pkt,'o','MarkerSize',12)
    
    title('原始噪声信号');  
    hold on;
    plot(t,parameters.ceil * ones(m,1),'magenta');
    hold on;
    plot(t,parameters.floor * ones(m,1),'magenta');
    hold on;
    pause;
    
end

%小波变换降噪
%wavelets_filter(data);