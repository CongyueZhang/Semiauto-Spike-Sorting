function [data] = spikedetection(X,t,parameters,data)

%此算法假设噪声全在阈值里，没有考虑噪声意外超出阈值的情况

i = t;
over_index = parameters.length - t;

%阈值搜索
while i < over_index
    if(X(i)<parameters.floor || X(i)>parameters.ceil)                                       %超出噪声范围，说明附近有信号
        firstIndex = i - int32(t/3);
        lastIndex = i+int32(2*t/3);
        if ~isempty(data.spiketimes)    
            LastSpikeIndex = data.spiketimes(end,end);
            if firstIndex < LastSpikeIndex
                firstIndex = LastSpikeIndex+1;
                lastIndex = LastSpikeIndex+1+t;
            end
        end
        spike = X((firstIndex:lastIndex),1);
        data.waveforms = [data.waveforms spike];
        spikeIndex = (firstIndex:1:lastIndex)';
        data.spiketimes = [data.spiketimes spikeIndex];
        i = i+int32(5*t/6);
    end
    i = i+1;
end

end