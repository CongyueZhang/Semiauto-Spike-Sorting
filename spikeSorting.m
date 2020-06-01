function X = spikeSorting(d,X_old)
global data;
global ch;

warning('off','signal:findpeaks:largeMinPeakHeight');

%��ͨ��
data.waveforms = cell(1,9);            %ÿһ����һ��waveforms�� size(data.waveforms,1) = waveforms������size(data.waveforms,2) = ÿ��waveforms�ĵ���
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
    [X] = preprocessing(X_old,step,k);    %����Ԥ����
    preprocessing_visualization(X_old{ch},X{ch});    
%    prompt = ['k = ' num2str(k)  '�������ʣ�������0�������ʣ��������µ�kֵ����'];
%    k = input(prompt);
%end
%% ================== Part 2: Spikes detection ===================
fprintf('\n\nSpikes detectiong Loading ...\n');
d.Message = 'Spikes detectiong ...';
t = 10;              %spike�ĳ��ȣ���λms
ratio = 1/2;        %��߷�ʱ������ı��� 

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