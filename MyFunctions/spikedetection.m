function spikedetection(X,t,parameters,ratio)
global data;
%���㷨��������ȫ����ֵ�û�п����������ⳬ����ֵ�����
%����͵�Ϊ���꣬��͵���data.waveforms(i,1+t*ratio);

%�迼�����⣺
%��ǰ���Ƿ���overlapping? min_index�Ƿ��ȡ��ǰ��overlapping�ĵ㣿
%��i����ֵ�Ƿ����ԭֵ�����������ѭ����

i = (1+ratio) * t;
end_index = parameters.length - 1 - (1+ratio)*t;
flag = 1;

%��ͨ��
%waveform = [];
%spiketime = [];

%��ֵ����
while i < end_index
    if(X(i)<=parameters.floor || X(i)>=parameters.ceil)                                       %����������Χ��˵���������ź�
        firstIndex_min = i - int32(ratio*t);
        lastIndex_min = i + int32(ratio*t);
        
        %��ͨ��
        %if ~isempty(spiketime)                        %�����ظ�
        %��ͨ��
        if ~isempty(data.spiketimes)||~isempty(data.abnormalSpiketimes)    %Overlapping
            %{
            LastSpikeIndex = data.spiketimes(end,end);
            if firstIndex < LastSpikeIndex
                firstIndex = LastSpikeIndex+1;
                lastIndex = LastSpikeIndex+1+t;
            end
            %}
            try
                [LastSpikeIndex,flag] = max([data.abnormalSpiketimes(end,end) data.spiketimes(end,end)+int32(ratio*t)]);
            catch
                if isempty(data.abnormalSpiketimes)
                    LastSpikeIndex = data.spiketimes(end,end)+int32(ratio*t);
                    flag = 2;
                else
                    LastSpikeIndex = data.abnormalSpiketimes(end,end);
                end
            end
            
            if firstIndex_min < LastSpikeIndex
                firstIndex_min = firstIndex_min - int32(0.5 * t);
                lastIndex_min = lastIndex_min + int32(0.5 * t);

                spike = X((firstIndex_min:lastIndex_min),1);
                spikeIndex = (firstIndex_min:1:lastIndex_min); 
                data.abnormalSpiketimes = [data.abnormalSpiketimes;spikeIndex];
                data.abnormalWaveforms = [data.abnormalWaveforms;spike'];

                
                if flag == 2
                    data.waveforms(end,:) = [];
                    data.spiketimes(end,:) = [];
                end
                flag = 1;
                i = lastIndex_min + 1;
                continue;
            end
           
        end
        
        
        
        [~,min_index] = min(X(firstIndex_min:lastIndex_min));
        min_index = firstIndex_min + min_index;
        firstIndex = min_index - int32(ratio*t);           
        lastIndex = min_index + int32(ratio*t);
        
        if ~isempty(data.spiketimes)||~isempty(data.abnormalSpiketimes)    %Overlapping
            %{
            LastSpikeIndex = data.spiketimes(end,end);
            if firstIndex < LastSpikeIndex
                firstIndex = LastSpikeIndex+1;
                lastIndex = LastSpikeIndex+1+t;
            end
            %}
            
            try
                [LastSpikeIndex,flag] = max([data.abnormalSpiketimes(end,end) data.spiketimes(end,end)+int32(ratio*t)]);
            catch
                if isempty(data.abnormalSpiketimes)
                    LastSpikeIndex = data.spiketimes(end,end)+int32(ratio*t);
                    flag = 2;
                else
                    LastSpikeIndex = data.abnormalSpiketimes(end,end);
                end
            end
            
            if firstIndex < LastSpikeIndex
                firstIndex = firstIndex - int32(0.5 * t);
                lastIndex = lastIndex + int32(0.5 * t);
                

                spike = X((firstIndex:lastIndex),1);
                spikeIndex = (firstIndex:1:lastIndex); 
                data.abnormalSpiketimes = [data.abnormalSpiketimes;spikeIndex];
                data.abnormalWaveforms = [data.abnormalWaveforms;spike'];

                
                if flag == 2
                    data.waveforms(end,:) = [];
                    data.spiketimes(end,:) = [];
                end
                flag = 0;
                i = lastIndex + 1;
                continue;
            end
            
        end
 
        %��ͨ��
        %spiketime = [spiketime;spikeIndex];
        %waveform = [waveform;spike'];
        
        spike = X((firstIndex:lastIndex),1);
        
        spikeIndex = min_index;     
        
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