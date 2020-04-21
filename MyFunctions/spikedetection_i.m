function spikedetection_i(X,t,parameters,ratio)
global data;
%���㷨��������ȫ����ֵ�û�п����������ⳬ����ֵ�����
%�Ե�һ��������ֵ�ĵ�Ϊ�̶���

i = t;
end_index = parameters.length - int32(1.5 * t) - 1;

%��ͨ��
%waveform = [];
%spiketime = [];

%��ֵ����
while i < end_index
    if(X(i)<=parameters.floor || X(i)>=parameters.ceil)                                       %����������Χ��˵���������ź�
        firstIndex = i - int32(ratio * t);
        lastIndex = i + t - int32(ratio * t);
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