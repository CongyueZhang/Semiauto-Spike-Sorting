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

threshold = min(parameters.ceil,abs(parameters.floor));

%����Сֵ�㵱��֪
lct_low = 100*ratio;

spike_length = size(data.waveforms,2);
t = 0.1:0.1:m/10;

for i = 1 : size(data.waveforms,1)
    
    clf;
     %{   
    %û�а���Сֵ�㵱��֪
    
    [smooth,window] = smoothdata(data.waveforms(i,:),'gaussian');
    %[pkt,lct] = findpeaks(abs(smooth),'MinPeakHeight',threshold);
    maxValue = max(smooth);
    minValue = min(smooth);
    
    
    [pkt_high,lct_high,~,proms_high] = findpeaks(smooth,'MinPeakDistance',31,'MinPeakProminence',(maxValue-minValue)*0.04,'SortStr','descend','NPeaks',2);
    [pkt_low,lct_low,~,proms_low] = findpeaks(-smooth,'SortStr','descend','NPeaks',1);
    pkt = [pkt_high';-pkt_low'];       
    lct = [lct_high';lct_low'];
    proms = [proms_high';proms_low'];
    peaks = [lct pkt proms];      %ÿһ����һ���㣬��һ�������꣬�ڶ����Ǵ�С���������Ǽ�ֵ�߶�
    peaks = sortrows(peaks);


    [~,minPoint] = min(peaks(:,2));
    %minIndex = peaks(minPoint,1);
    %{
    %��ת�۵�
    newThreshold = threshold/20;
    %tuneIndex = find(abs(smooth(minIndex:end)-median(smooth(minIndex:end)))<threshold/20,1) + minIndex;     %��Сֵ���ת�۵�
    tuneIndex = find(abs(diff(smooth(minIndex+15:end)))<newThreshold,1) + minIndex+15;
    
    while isempty(tuneIndex)
        newThreshold = 1.3 * newThreshold;
        %tuneIndex = find(abs(smooth(minIndex:end)-median(smooth(minIndex:end)))<newThreshold,1) + minIndex;
        tuneIndex = find(abs(diff(smooth(minIndex+15:end)))<newThreshold,1);
    end
    %}

    if size(peaks,1) == 3        %�ҵ���������
        if minPoint == 2        %�����Сֵ�����м�
            if peaks(3,3) < 0.15 * (maxValue-minValue)  ||  abs(peaks(3,2)-minValue)<0.35 * (maxValue-minValue)
                peaks(3,:) = [];
            end
        end
    end
    
 %{   
    if size(peaks,1) == 2       %�ҵ�������
        if minPoint == 2        %�����Сֵ���ں���
            peaks(3,1) = tuneIndex;
            peaks(3,2) = smooth(tuneIndex);
        end
    end
%}
    %}
    
    %����Сֵ�㵱��֪
    smooth = smoothdata(data.waveforms(i,:),'gaussian');
    maxValue = max(smooth);
    minValue = min(smooth);
    
    [pkt_high1,lct_high1] = findpeaks(smooth(1:lct_low),'MinPeakProminence',(maxValue-minValue)*0.04,'NPeaks',1);
    
    [pkt_high2,lct_high2] = findpeaks(smooth(lct_low+1:end),'MinPeakProminence',(maxValue-minValue)*0.15,'MinPeakHeight',(maxValue-minValue)*0.35,'NPeaks',1);
    
    lct_high2 = lct_low + lct_high2;
    
    pkt = [data.waveforms(i,lct_high1);data.waveforms(i,lct_low);data.waveforms(i,lct_high2)];       
    lct = [lct_high1;lct_low;lct_high2];
    peaks = [lct pkt];      %ÿһ����һ���㣬��һ�������꣬�ڶ����Ǵ�С��
    
    hold on;
    plot(t,data.waveforms(i,:),'-o');   
    
    hold on;
    plot(t,smooth,'-x');
    
    hold on;
    plot(peaks(:,1)/10,peaks(:,2),'o','MarkerFaceColor','red');
    
    
    title('����ͼ');  
    xlabel('Time(ms)');
    ylabel('Voltage(mV)')

    hold on;
    plot(t,parameters.ceil * ones(m,1),'magenta');
    hold on;
    plot(t,parameters.floor * ones(m,1),'magenta');
    hold on;
    
    legend('Original Data','Smoothed Data','FeaturePoints','threshold','threshold')
    axis([0 m/10 min(data.waveforms(i,:)) max(data.waveforms(i,:))]); 
    pause;
    
end

%С���任����
%wavelets_filter(data);