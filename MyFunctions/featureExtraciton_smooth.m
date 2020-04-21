function [features] = featureExtraciton_smooth(data,parameters)
    global data;
    global parameters;
    features = [];
    
for i = 1 : size(data.waveforms,1)
    smoothdata(data.waveforms(i,:),'gaussian');
    [pkt,lct] = findpeaks(waveforms_smooth);
    
    plot(t,data.waveforms(i,:),'-o',t,smooth,'-x');
    legend('Original Data','Smoothed Data')
    
end
    
end