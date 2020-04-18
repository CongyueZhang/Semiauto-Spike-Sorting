function data = spikeSorting(path)

%��ȡ����
addpath('E:\�����̼�\data processing\project\matlab\Functions');
addpath('E:\�����̼�\data processing\project\matlab\MyFunctions');
addpath('E:\�����̼�\data processing\project\matlab\MyFunctions\plotting');


%path = [path '\']

path = 'E:\�����̼�\US RECORD\12_28\E1_processing\';

[X_old,USindex,ESindex] = dataLoad(path);       %��ȡ���ݣ����dataLoad Function

parameters =[];

%��ͨ��
%data.waveforms = cell(1,1);            %ÿһ����һ��waveforms�� size(data.waveforms,1) = waveforms������size(data.waveforms,2) = ÿ��waveforms�ĵ���
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
    [X,parameters] = preprocessing(X_old,step,parameters,k);    %����Ԥ����
    preprocessing_visualization(path,X_old,X,parameters,USindex,ESindex);    
%    prompt = ['k = ' num2str(k)  '�������ʣ�������0�������ʣ��������µ�kֵ����'];
%    k = input(prompt);
%end

%% ================== Part 2: Spikes detection ===================
fprintf('\n\nSpikes detectiong Loading ...\n');
t = 8;              %spike�ĳ��ȣ���λms
ratio = 1/10;        %��߷�ʱ������ı��� 

spikedetection(X,t*10,parameters,ratio);

%n = 25;
%spikes_visualization(X,data,n,parameters);        

%% ================== Part 3: Feature Extraction ===================
%features = featureExtraction(data,parameters);

%% ================== Part 4: Clustering ===================
%clusterSorting(features,data,parameters);      

%���Զ�
%Spikesinterp();
data.idx = zeros(size(data.waveforms,1),1);

%v = max(max(data.features2(:,3)),max(data.features2(:,5)));
%alpha = t*10/0.9/v;
%data.features2(:,5) = alpha*data.features2(:,5);

%clustering_GMMs(data,path);


%frequency_visualization(path,data,idx,parameters,USindex,ESindex);

end