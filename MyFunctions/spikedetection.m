function spikedetection(X,t,ratio)
global data;
global parameters;

%此算法假设噪声全在阈值里，没有考虑噪声意外超出阈值的情况
%以最低点为定标，最低点是data.waveforms(i,1+t*ratio);

%需考虑问题：
%①前方是否有overlapping? min_index是否会取到前方overlapping的点？
%②i的新值是否大于原值？（否则会死循环）

for ch = parameters.channel
    
    i = (1+ratio) * t;
    end_index = size(X{ch},1) - 1 - (1+ratio)*t;
    flag = 1;
    
    %阈值搜索
    while i < end_index
        if(X{ch}(i)<=parameters.floor || X{ch}(i)>=parameters.ceil)                                       %超出噪声范围，说明附近有信号
            firstIndex_min = i - int32(ratio*t);
            lastIndex_min = i + int32(ratio*t);
            
            if ~isempty(data.spiketimes{ch})||~isempty(data.abnormalSpiketimes{ch})    %Overlapping
                %{
                LastSpikeIndex = data.spiketimes{ch}(end,end);
                if firstIndex < LastSpikeIndex
                    firstIndex = LastSpikeIndex+1;
                    lastIndex = LastSpikeIndex+1+t;
                end
                %}
                try
                    [LastSpikeIndex,flag] = max([data.abnormalSpiketimes{ch}(end,end) data.spiketimes{ch}(end,end)+int32(ratio*t)]);
                catch
                    if isempty(data.abnormalSpiketimes{ch})
                        LastSpikeIndex = data.spiketimes{ch}(end,end)+int32(ratio*t);
                        flag = 2;
                    else
                        LastSpikeIndex = data.abnormalSpiketimes{ch}(end,end);
                    end
                end
                
                if firstIndex_min < LastSpikeIndex
                    firstIndex_min = firstIndex_min - int32(0.5 * t);
                    lastIndex_min = lastIndex_min + int32(0.5 * t);
                    
                    spike = X{ch}((firstIndex_min:lastIndex_min),1);
                    spikeIndex = (firstIndex_min:1:lastIndex_min);
                    data.abnormalSpiketimes{ch} = [data.abnormalSpiketimes{ch};spikeIndex];
                    data.abnormalWaveforms{ch} = [data.abnormalWaveforms{ch};spike'];
                    
                    if flag == 2
                        data.waveforms{ch}(end,:) = [];
                        data.spiketimes{ch}(end,:) = [];
                    end
                    flag = 1;
                    i = lastIndex_min + 1;
                    continue;
                end
                
            end
            
            [~,min_index] = min(X{ch}(firstIndex_min:lastIndex_min));
            min_index = firstIndex_min + min_index;
            firstIndex = min_index - int32(ratio*t);
            lastIndex = min_index + int32(ratio*t);
            
            if ~isempty(data.spiketimes{ch})||~isempty(data.abnormalSpiketimes{ch})    %Overlapping
                %{
                LastSpikeIndex = data.spiketimes{ch}(end,end);
                if firstIndex < LastSpikeIndex
                    firstIndex = LastSpikeIndex+1;
                    lastIndex = LastSpikeIndex+1+t;
                end
                %}
                
                try
                    [LastSpikeIndex,flag] = max([data.abnormalSpiketimes{ch}(end,end) data.spiketimes{ch}(end,end)+int32(ratio*t)]);
                catch
                    if isempty(data.abnormalSpiketimes{ch})
                        LastSpikeIndex = data.spiketimes{ch}(end,end)+int32(ratio*t);
                        flag = 2;
                    else
                        LastSpikeIndex = data.abnormalSpiketimes{ch}(end,end);
                    end
                end
                
                if firstIndex < LastSpikeIndex
                    firstIndex = firstIndex - int32(0.5 * t);
                    lastIndex = lastIndex + int32(0.5 * t);
                    
                    spike = X{ch}((firstIndex:lastIndex),1);
                    spikeIndex = (firstIndex:1:lastIndex);
                    data.abnormalSpiketimes{ch} = [data.abnormalSpiketimes{ch};spikeIndex];
                    data.abnormalWaveforms{ch} = [data.abnormalWaveforms{ch};spike'];
                    
                    
                    if flag == 2
                        data.waveforms{ch}(end,:) = [];
                        data.spiketimes{ch}(end,:) = [];
                    end
                    flag = 0;
                    i = lastIndex + 1;
                    continue;
                end
                
            end
            
            
            spike = X{ch}((firstIndex:lastIndex),1);
            
            spikeIndex = min_index;
            
            data.spiketimes{ch} = [data.spiketimes{ch};spikeIndex];
            data.waveforms{ch} = [data.waveforms{ch};spike'];
            
            i = lastIndex + 1;
        end
        
        i = i+1;
    end
    
end
end