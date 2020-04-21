function spikedetection_i(X,t,parameters,ratio)
global data;
%此算法假设噪声全在阈值里，没有考虑噪声意外超出阈值的情况
%以第一个超出阈值的点为固定点

i = t;
end_index = parameters.length - int32(1.5 * t) - 1;

%多通道
%waveform = [];
%spiketime = [];

%阈值搜索
while i < end_index
    if(X(i)<=parameters.floor || X(i)>=parameters.ceil)                                       %超出噪声范围，说明附近有信号
        firstIndex = i - int32(ratio * t);
        lastIndex = i + t - int32(ratio * t);
        %多通道
        %if ~isempty(spiketime)                        %避免重复
        %单通道
        if ~isempty(data.spiketimes)    %Overlapping
            %{
            LastSpikeIndex = data.spiketimes(end,end);
            if firstIndex < LastSpikeIndex
                firstIndex = LastSpikeIndex+1;
                lastIndex = LastSpikeIndex+1+t;
            end
            %}
            
            LastSpikeIndex = data.spiketimes(end,end);
            if firstIndex < LastSpikeIndex
                firstIndex = firstIndex - int32(0.5 * t);
                lastIndex = i - int32(ratio * t) + int32(0.5 * t);
                spike = X((firstIndex:lastIndex),1);
                spikeIndex = (firstIndex:1:lastIndex); 
                data.abnormalSpiketimes = [data.abnormalSpiketimes;spikeIndex];
                data.abnormalWaveforms = [data.abnormalWaveforms;spike'];
                data.waveforms(end,:) = [];
                data.spiketimes(end,:) = [];
                i = lastIndex + 1;
                continue;
            end
            
            if (X(firstIndex)<parameters.floor || X(firstIndex)>parameters.ceil) && (X(firstIndex+1)<parameters.floor || X(firstIndex+1)>parameters.ceil)
                firstIndex = firstIndex - int32(0.5 * t);
                lastIndex = i - int32(ratio * t) + int32(0.5 * t);
                spike = X((firstIndex:lastIndex),1);
                spikeIndex = (firstIndex:1:lastIndex); 
                data.abnormalSpiketimes = [data.abnormalSpiketimes;spikeIndex];
                data.abnormalWaveforms = [data.abnormalWaveforms;spike'];
                data.waveforms(end,:) = [];
                data.spiketimes(end,:) = [];
                i = lastIndex + 1;
                continue;
            end
        end
        spike = X((firstIndex:lastIndex),1);
        
        spikeIndex = (firstIndex:1:lastIndex);     %全部点
        
        %spikeIndex = i + minIndex;       %仅最大值的时间坐标
 
        %多通道
        %spiketime = [spiketime;spikeIndex];
        %waveform = [waveform;spike'];
        
        %单通道
        data.spiketimes = [data.spiketimes;spikeIndex];
        data.waveforms = [data.waveforms;spike'];
        
        i = lastIndex + 1;
    end
    
    i = i+1;
end

%多通道
%data.waveforms{1,1} = waveform;
%data.spiketimes{1,1} = spiketime;

end