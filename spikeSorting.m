function X = spikeSorting(path,d)
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


%path = [path '\'];

path = 'E:\�����̼�\US RECORD\12_28\E1_processing\';

warning('off','signal:findpeaks:largeMinPeakHeight');

d.Message = 'data Loading ...';
[X_old,data.USindex,data.ESindex] = dataLoad(path);       %��ȡ���ݣ����dataLoad Function


%��ͨ��
%data.waveforms = cell(1,1);            %ÿһ����һ��waveforms�� size(data.waveforms,1) = waveforms������size(data.waveforms,2) = ÿ��waveforms�ĵ���
%data.spiketimes = cell(1,1);


%% ================== Part 1: Preprocessing ===================

fprintf('\n\nPreprocessing Loading ...\n');
d.Message = 'Preprocessing ...';
k = 5;

%while(k)
    step = 1000;    %step
    [X,parameters] = preprocessing(X_old,step,parameters,k);    %����Ԥ����
    preprocessing_visualization(path,X_old,X);    
%    prompt = ['k = ' num2str(k)  '�������ʣ�������0�������ʣ��������µ�kֵ����'];
%    k = input(prompt);
%end

%% ================== Part 2: Spikes detection ===================
fprintf('\n\nSpikes detectiong Loading ...\n');
d.Message = 'Spikes detectiong ...';
t = 10;              %spike�ĳ��ȣ���λms
ratio = 1/2;        %��߷�ʱ������ı��� 

spikedetection(X,t*10,parameters,ratio);

%n = 25;
%spikes_visualization(X,data,n,parameters);        

%% ================== Part 3: Feature Extraction ===================
data.features = zeros(size(data.waveforms,1),5);
featureExtraciton_smooth(t*10,ratio);

%% ================== Part 4: Clustering ===================
%clusterSorting(features,data,parameters);      

%���Զ�
%Spikesinterp();
data.idx = zeros(size(data.waveforms,1),1);
%RL_FCM(data.features);

%v = max(max(data.features2(:,3)),max(data.features2(:,5)));
%alpha = t*10/0.9/v;
%data.features2(:,5) = alpha*data.features2(:,5);

d.Message = 'Clustering ...';
clustering_GMMs();


%frequency_visualization(path,data,idx,parameters,USindex,ESindex);

end