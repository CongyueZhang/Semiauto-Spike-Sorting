 function spikedetection(X,t,parameters,ratio)
global data;
%此算法假设噪声全在阈值里，没有考虑噪声意外超出阈值的情况
%以最低点为定标，最低点是data.waveforms(i,1+t*ratio);

%需考虑问题：
%①前方是否有overlapping? min_index是否会取到前方overlapping的点？
%②i的新值是否大于原值？（否则会死循环）


i = t;
end_index = parameters.length - int32(1.5 * t) - 1;

%多通道
%waveform = [];
%spiketime = [];

%阈值搜索
while i < end_index
    if(X(i)<=parameters.floor || X(i)>=parameters.ceil)                                       %超出噪声范围，说明附近有信号
        firstIndex_min = i - ratio*t;
        lastIndex_min = i + ratio*t;
        
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
            if firstIndex_min < LastSpikeIndex
                firstIndex_min = firstIndex_min - 0.5 * t;
                lastIndex_min = lastIndex_min;
                spike = X((firstIndex_min:lastIndex_min),1);
                spikeIndex = (firstIndex_min:1:lastIndex_min); 
                data.abnormalSpiketimes = [data.abnormalSpiketimes;spikeIndex];
                data.abnormalWaveforms = [data.abnormalWaveforms;spike'];
                data.waveforms(end,:) = [];
                data.spiketimes(end,:) = [];
                i = lastIndex_min + 1;
                continue;
            end
            
            if (X(firstIndex_min)<parameters.floor || X(firstIndex_min)>parameters.ceil) && (X(firstIndex_min+1)<parameters.floor || X(firstIndex_min+1)>parameters.ceil)
                firstIndex_min = firstIndex_min - 0.5 * t;
                lastIndex_min = lastIndex_min;
                spike = X((firstIndex_min:lastIndex_min),1);
                spikeIndex = (firstIndex_min:1:lastIndex_min); 
                data.abnormalSpiketimes = [data.abnormalSpiketimes;spikeIndex];
                data.abnormalWaveforms = [data.abnormalWaveforms;spike'];
                data.waveforms(end,:) = [];
                data.spiketimes(end,:) = [];
                i = lastIndex_min + 1;
                continue;
            end
        end
        
        [~,min_index] = min(X(firstIndex_min:lastIndex_min));
        min_index = firstIndex_min + min_index;
        firstIndex = min_index - ratio*t;           
        lastIndex = min_index + ratio*t;
        
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
                firstIndex = firstIndex - 0.5 * t;
                lastIndex = lastIndex;
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
                firstIndex = firstIndex - 0.5 * t;
                lastIndex = lastIndex;
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