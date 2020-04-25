function featureExtraciton_smooth(t,ratio)
    global data;
    lct_low = t*ratio;
for i = 1 : size(data.waveforms,1)
    features = zeros(1,6);
    smooth = smoothdata(data.waveforms(i,:),'gaussian');
    maxValue = max(smooth);
    minValue = min(smooth);
    
    data.features(i,3) = data.waveforms(i,lct_low);

    [pkt_high1,lct_high1] = findpeaks(smooth(1:lct_low),'MinPeakProminence',(maxValue-minValue)*0.04,'NPeaks',1);
    
    if ~isempty(lct_high1)
        data.features(i,1) = lct_high1;
        data.features(i,2) = data.waveforms(i,lct_high1);
    end
    
    [pkt_high2,lct_high2] = findpeaks(smooth(lct_low+1:end),'MinPeakProminence',(maxValue-minValue)*0.15,'MinPeakHeight',(maxValue+minValue)*0.35,'NPeaks',1);
    
    if ~isempty(lct_high2)
        data.features(i,4) = lct_high2;
        data.features(i,5) = data.waveforms(i,lct_high2);
    end
    
    pkt = [data.waveforms(i,lct_high1);data.waveforms(i,lct_low);data.waveforms(i,lct_high2)];       
    lct = [lct_high1;lct_low;lct_high2];
    peaks = [lct pkt];      %每一行是一个点，第一列是坐标，第二列是大小；
    
   
end

for i = 1:size(data.features,2)
    index = data.features(:,i) ~= 0;
    if ~isempty(index)
        mu = mean(data.features(index,i));
        data.features(:,i) = bsxfun(@minus, data.features(:,i), mu);
        sigma = std(data.features(index,i));
        data.features(:,i) = bsxfun(@rdivide, data.features(:,i), sigma);
    end
end
    
end