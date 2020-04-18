function spikedetection_old(X,t,parameters)
%% ===================��ֵ�����������жϡ�������ȡ ===================
%���㷨��������ȫ����ֵ�û�п����������ⳬ����ֵ�����

global data;

i = t;
over_index = size(X,1)-2*t-2;

%��ֵ����
while i < over_index
    if(X(i)<parameters.floor || X(i)>parameters.ceil)                                                 %����������Χ��˵���������ź�
        [value,index] = min(X(i:i+int64(3*t/4)));
        if value > parameters.floor
        [~,index] = max(X(i:i+int64(3*t/4)));
        end
        spike =  X((i+index-int64(t/3)):(i+index+int64(t/3)),1);
        [~,max_index_temp] = max(spike);
        max_index_temp = i+index-int64(t/3)+max_index_temp;
        [~,min_index_temp] = min(spike);
        min_index_temp = i+index-int64(t/3)+min_index_temp;       %����ʱ�����ϵ�λ��
        
        if(max_index_temp<i||min_index_temp<i)      %ǰ��overlap
            spike = X(i-t:i+t,1);
            data.waveforms_abnormal = [data.waveforms_abnormal;spike'];
            data.features_abnormal = [data.features_abnormal;1];
            data.spiketimes_abnormal = [data.spiketimes_abnormal;i];
            i = i+t+1;
            continue;
        end
        
        %��1����2
        if max_index_temp>min_index_temp                                            
            spike =  X((min_index_temp-int64(t/2)):(min_index_temp+int64(t/2)),1);
            [min_value,min_index] = min(spike);
            [max_value1,max_index1] = max(spike(1:min_index));       %��1��ǰ�������       
            [max_value2,max_index2] = max(spike(min_index:end));       %��2�����������
            max_index2 = min_index_temp-int64(t/2)+max_index2;
            base_index = find(spike>parameters.floor & spike<parameters.ceil);
            start_index = find(base_index<min_index);
            end_index = find(base_index>max_index2);
            
            %if isempty(after_index)||isempty(before_index)
                %after_index
                %before_index
                %mid_index
                %figure;
             %plot(spike);
            %end
        
            if min_index>max_index2 || isempty(end_index)           %��overlap
                %figure;
                %plot(X(i:i+2*t));
                spike =  X(i:i+2*t,1);
                data.waveforms_abnormal = [data.waveforms_abnormal;spike'];
                data.features_abnormal = [data.features_abnormal;2];
                data.spiketimes_abnormal = [data.spiketimes_abnormal;i];
                i = i + 2 * t + 1;
                continue;
            end
        
            if isempty(start_index)                 %ǰ��overlap
                %figure;
                %plot(X(i-100:i+100));
                
                spike =  X(i-t:i+t,1);
                data.waveforms_abnormal = [data.waveforms_abnormal;spike'];
                data.features_abnormal = [data.features_abnormal;1];
                data.spiketimes_abnormal = [data.spiketimes_abnormal;i];
                i = i + t + 1;
                continue;
            end
        
            first_index = max(base_index(start_index));       %ע�ⲹ�俼��max_value1<parameters.ceil �� first_index>max_index1 �����
        
            if max_value1<parameters.ceil/2
                max_value1 = 0;
                max_index1 = first_index;
            end
            
            last_index = min(base_index(end_index));
            feature_3(1) = max_value1;                        %��1��ֵ
            feature_3(2) = (max_index1-first_index)/10;       %��1��ֵ����
            feature_3(3) = max_value2;                        %��2��ֵ
            feature_3(4) = (max_index2-first_index)/10;      %��2����
            feature_3(5) = min_value;                         %����ֵ
            feature_3(6) = (min_index-first_index)/10;        %����ֵ����
            feature_3(7) = (last_index-first_index)/10;       %βֵ����
            data.features3 = [data.features3;feature_3];
            i = i+min_index+int64(t/2);
            data.waveforms3 = [data.waveforms3;spike'];
            spike_index = min_index+i;                       %����ֵ������ʱ��������
            data.spiketimes3_max = [data.spiketimes3_max;spike_index];
            
            spiketimes3 = min_index_temp-int64(t/2):1:min_index_temp+int64(t/2);
            data.spiketimes3 = [data.spiketimes3;spiketimes3];
            
        end
        
        if max_index_temp<min_index_temp         %������
            
            spike =  X((max_index_temp-int64(t/4)):(max_index_temp+int64(3*t/4)),1);
            [max_value,max_index] = max(spike);
            [min_value,min_index] = min(spike);
            base_index = find(spike>parameters.floor & spike<parameters.ceil);
            start_index = find(base_index<max_index);
            mid_index = find(base_index>max_index & base_index<min_index);
            end_index = find(base_index>min_index);
        
            %if isempty(after_index)||isempty(before_index)
                %after_index
                %before_index
                %mid_index
                %figure;
             %plot(spike);
            %end
        
            if min_index<max_index || isempty(end_index)      %�󷽳���overlap �����������źţ�
                %figure;
                %plot(X(i:i+2*t));
                spike =  X(i:i+2*t,1);
                data.waveforms_abnormal = [data.waveforms_abnormal;spike'];
                data.features_abnormal = [data.features_abnormal;2];
                data.spiketimes_abnormal = [data.spiketimes_abnormal;i];
                i = i + 2*t + 1;
                continue;
            end
        
            if isempty(mid_index)
                mid_index = (max_index+min_index)/2;
            else
                mid_index = median(base_index(mid_index));
            end
            
            
        
            if isempty(start_index)
                %figure;
                %plot(X(i-100:i+100));
            
                spike =  X(i-t:i+t,1);
                data.waveforms_abnormal = [data.waveforms_abnormal;spike'];
                data.features_abnormal = [data.features_abnormal;1];        %overlap,��ǰ
                data.spiketimes_abnormal = [data.spiketimes_abnormal;i];
                i = i + t + 1;
                continue;
            end
        
            first_index = max(base_index(start_index));
        
            last_index = min(base_index(end_index));
            feature_2(1) = (mid_index-first_index)/10;             %�е�����
            feature_2(2) = (last_index-first_index)/10;            %βֵ����
            feature_2(3) = max_value;                              %����ֵ
            feature_2(4) = (max_index-first_index)/10;             %����ֵ����
            feature_2(5) = min_value;                              %����ֵ
            %feature_2(6) = (min_index-first_index)/10;             %����ֵ����
            feature_2(6) = min_index/10;
            data.features2 = [data.features2;feature_2];
            i = i+max_index+int64(3*t/4) + 1;
            data.waveforms2 = [data.waveforms2;spike'];
            spike_index = max_index+i;                       %����ֵ������ʱ��������
            data.spiketimes2_max = [data.spiketimes2_max;spike_index];
            
            spiketimes2 = max_index_temp-int64(t/4):1:max_index_temp+int64(3*t/4);
            data.spiketimes2 = [data.spiketimes2;spiketimes2];
        
        end
    end
    i = i+1;
end

end