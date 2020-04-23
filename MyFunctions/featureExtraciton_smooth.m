function [features] = featureExtraciton_smooth()
    global data;
    
for i = 1 : size(data.waveforms,1)
    features = zeros(1,6);
    smooth = smoothdata(data.waveforms(i,:),'gaussian');
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
    
    if size(peaks,1) == 3        %�ҵ���������
        if minPoint == 2        %�����Сֵ�����м�
            if peaks(3,3) < 0.15 * (maxValue-minValue)  ||  abs(peaks(3,2)-minValue)<0.35 * (maxValue-minValue)
                peaks(3,:) = [];
            end
        end
    end
    
    for j = 1:2:2*size(peaks,1)
        features(j:j+1) = [peaks(j,1) waveforms(i,peaks(j,1))];
    end
   
end
    
end