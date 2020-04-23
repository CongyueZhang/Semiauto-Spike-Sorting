 function spikedetection(X,t,parameters,ratio)
global data;
%���㷨��������ȫ����ֵ�û�п����������ⳬ����ֵ�����
%����͵�Ϊ���꣬��͵���data.waveforms(i,1+t*ratio);

%�迼�����⣺
%��ǰ���Ƿ���overlapping? min_index�Ƿ��ȡ��ǰ��overlapping�ĵ㣿
%��i����ֵ�Ƿ����ԭֵ�����������ѭ����


i = t;
end_index = parameters.length - int32(1.5 * t) - 1;

%��ͨ��
%waveform = [];
%spiketime = [];

%��ֵ����
while i < end_index
    if(X(i)<=parameters.floor || X(i)>=parameters.ceil)                                       %����������Χ��˵���������ź�
        firstIndex_min = i - ratio*t;
        lastIndex_min = i + ratio*t;
        
        %��ͨ��
        %if ~isempty(spiketime)                        %�����ظ�
        %��ͨ��
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
        
        spikeIndex = (firstIndex:1:lastIndex);     %ȫ����
        
        %spikeIndex = i + minIndex;       %�����ֵ��ʱ������
 
        %��ͨ��
        %spiketime = [spiketime;spikeIndex];
        %waveform = [waveform;spike'];
        
        %��ͨ��
        data.spiketimes = [data.spiketimes;spikeIndex];
        data.waveforms = [data.waveforms;spike'];
        
        i = lastIndex + 1;
    end
    
    i = i+1;
end

%��ͨ��
%data.waveforms{1,1} = waveform;
%data.spiketimes{1,1} = spiketime;

end