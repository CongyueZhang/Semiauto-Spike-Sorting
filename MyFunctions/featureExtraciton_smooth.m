function featureExtraciton_smooth(t,ratio)
global data;
global parameters;

for ch = parameters.channel
lct_low = t*ratio;
data.features{ch} = zeros(size(data.waveforms{ch},1),5);
for i = 1 : size(data.waveforms{ch},1)
    smooth = smoothdata(data.waveforms{ch}(i,:),'gaussian');
    maxValue = max(smooth);
    minValue = min(smooth);
    
    data.features{ch}(i,3) = data.waveforms{ch}(i,lct_low);
    
    [pkt_high1,lct_high1] = findpeaks(smooth(1:lct_low),...
        'MinPeakProminence',(maxValue-minValue)*0.04,'NPeaks',1);
    
    if ~isempty(lct_high1)
        data.features{ch}(i,1) = lct_high1;
        data.features{ch}(i,2) = data.waveforms{ch}(i,lct_high1);
    end
    
    [pkt_high2,lct_high2] = findpeaks(smooth(lct_low+1:end),'MinPeakProminence',(maxValue-minValue)*0.15,'MinPeakHeight',(maxValue+minValue)*0.35,'NPeaks',1);
    
    if ~isempty(lct_high2)
        data.features{ch}(i,4) = lct_high2;
        data.features{ch}(i,5) = data.waveforms{ch}(i,lct_high2);
    end
    
    pkt = [data.waveforms{ch}(i,lct_high1);data.waveforms{ch}(i,lct_low);data.waveforms{ch}(i,lct_high2)];
    lct = [lct_high1;lct_low;lct_high2];
    peaks = [lct pkt];      %每一行是一个点，第一列是坐标，第二列是大小；
    
    
end

for i = 1:size(data.features{ch},2)
    index = data.features{ch}(:,i) ~= 0;
    if ~isempty(index)
        mu = mean(data.features{ch}(index,i));
        data.features{ch}(:,i) = bsxfun(@minus, data.features{ch}(:,i), mu);
        sigma = std(data.features{ch}(index,i));
        if mod(i,2)
            data.features{ch}(:,i) = bsxfun(@rdivide, data.features{ch}(:,i), sigma);
        else
            data.features{ch}(:,i) = bsxfun(@rdivide, data.features{ch}(:,i), sigma) * 2;
        end
    end
end
end
end