%��ȡ����
addpath('.\Functions');
addpath('.\MyFunctions');

path = 'E:\�����̼�\US RECORD\12_28\E1_processing\';

[X_old,USindex,ESindex] = dataLoad(path);       %��ȡ���ݣ����dataLoad Function

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
[X,parameters] = preprocessing(X_old,step,parameters,k);    %����Ԥ����

%X_filtered = fix_filter(X_old);
%X_filtered = X_filtered(1:parameters.length)';
%% ================== Part 2: Spikes detection ===================
fprintf('\n\nSpikes detectiong Loading ...\n');
ratio = 1/8;        %��߷�ʱ������ı��� 
t = 9;
spikedetection(X,t*10,parameters,ratio);
m = size(data.waveforms,2);
t = 1:m;

for i = 1 : size(data.waveforms,1)
    
    clf;
    plot(data.waveforms(i,:));
    title('ԭʼ�����ź�');  
    hold on;
    plot(t,parameters.ceil * ones(m,1),'magenta');
    hold on;
    plot(t,parameters.floor * ones(m,1),'magenta');
    hold on;
    pause;
    
end

%С���任����
%wavelets_filter(data);