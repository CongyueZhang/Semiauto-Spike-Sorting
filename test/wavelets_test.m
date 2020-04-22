%��ȡ����
addpath('E:\�����̼�\data processing\project\matlab\Functions');
addpath('E:\�����̼�\data processing\project\matlab\MyFunctions');
addpath('E:\�����̼�\data processing\project\matlab\MyFunctions\plotting');

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
ratio = 1/2;        %��ͷ�ʱ������ı��� 
t = 10;
spikedetection(X,t*10,parameters,ratio);
m = size(data.waveforms,2);
t = 1:m;

threshold = min(parameters.ceil,abs(parameters.floor));
threshold = threshold/2;
for i = 1 : size(data.waveforms,1)
    
    clf;
    [smooth,window] = smoothdata(data.waveforms(i,:),'gaussian');
    %[pkt,lct] = findpeaks(abs(smooth),'MinPeakHeight',threshold);
    [pkt_high,lct_high] = findpeaks(smooth,'MinPeakDistance',40,'SortStr','descend','NPeaks',2);
    [pkt_low,lct_low] = findpeaks(-smooth,'SortStr','descend','NPeaks',1);
    pkt = [pkt_high';-pkt_low'];       
    lct = [lct_high';lct_low'];
    peaks = [lct pkt];      %ÿһ����һ���㣬��һ�������꣬�ڶ����Ǵ�С
    peaks = sortrows(peaks);
    
    [~,minPoint] = min(peaks(:,2));
    minIndex = peaks(minPoint,1);
    newThreshold = threshold/15;
    tuneIndex = find(abs(smooth(minIndex:end)-median(smooth(minIndex:end)))<threshold/20,1) + minIndex;     %��Сֵ���ת�۵�
    
    while isempty(tuneIndex)
        newThreshold = 1.3 * newThreshold;
        tuneIndex = find(abs(smooth(minIndex:end)-median(smooth(minIndex:end)))<newThreshold,1) + minIndex;
    end
    
    if size(peaks,1) == 3        %�ҵ���������
        if minPoint == 2        %�����Сֵ�����м�
            if abs(peaks(3,2) - smooth(tuneIndex))<threshold/5        %���ת�۵�͵��������ֵ��С
                peaks(3,1) = tuneIndex;
                peaks(3,2) = smooth(tuneIndex);
            end
        end
    end
    
    if size(peaks,1) == 2       %�ҵ�������
        if minPoint == 2        %�����Сֵ���ں���
            peaks(3,1) = tuneIndex;
            peaks(3,2) = smooth(tuneIndex);
        end
    end
    
    
    plot(t,data.waveforms(i,:),'-o',t,smooth,'-x');
    legend('Original Data','Smoothed Data')
    
    hold on;
    plot(peaks(:,1),peaks(:,2),'o','MarkerSize',12,'MarkerEdgeColor','red')
    
    
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