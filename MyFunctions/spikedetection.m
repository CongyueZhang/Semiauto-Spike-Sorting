function [spikes_2,spikes_3,spike_indexes_2,spike_indexes_3,abnormal_indexes,features_2,features_3,abnormal_spikes,abnormal_features] = spikedetection(X,t,Max,Min)
spikes_2 = [];
spikes_3 = [];
features_2 = [];
features_3 = [];
spike_indexes_2 = [];
spike_indexes_3 = [];
abnormal_spikes = [];
abnormal_features = [];
abnormal_indexes = [];


%% ===================��ֵ�����������жϡ�������ȡ ===================
%���㷨��������ȫ����ֵ�û�п����������ⳬ����ֵ�����

i = t;
over_index = size(X,1)-2*t-2;

%��ֵ����
while i < over_index
    if(X(i)<Min || X(i)>Max)                                                 %����������Χ��˵���������ź�
        [value,index] = min(X(i:i+int64(3*t/4)));
        if value > Min
        [~,index] = max(X(i:i+int64(3*t/4)));
        end
        spike =  X((i+index-int64(t/3)):(i+index+int64(t/3)),1);
        [max_value,max_index_temp] = max(spike);
        max_index_temp = i+index-int64(t/3)+max_index_temp;
        [min_value,min_index_temp] = min(spike);
        min_index_temp = i+index-int64(t/3)+min_index_temp;       %����ʱ�����ϵ�λ��
        
        if(max_index_temp<i||min_index_temp<i)      %ǰ��overlap
            spike = X(i-t:i+t,1);
            abnormal_spikes = [abnormal_spikes spike];
            abnormal_features = [abnormal_features;1];
            abnormal_indexes = [abnormal_indexes;i];
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
            base_index = find(spike>Min & spike<Max);
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
                abnormal_spikes = [abnormal_spikes spike];
                abnormal_features = [abnormal_features;2];
                abnormal_indexes = [abnormal_indexes;i];
                i = i + 2 * t + 1;
                continue;
            end
        
            if isempty(start_index)                 %ǰ��overlap
                %figure;
                %plot(X(i-100:i+100));
                
                spike =  X(i-t:i+t,1);
                abnormal_spikes = [abnormal_spikes spike];
                abnormal_features = [abnormal_features;1];
                abnormal_indexes = [abnormal_indexes;i];
                i = i + t + 1;
                continue;
            end
        
            first_index = max(base_index(start_index));       %ע�ⲹ�俼��max_value1<Max �� first_index>max_index1 �����
        
            if max_value1<Max/2
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
            features_3 = [features_3;feature_3];
            i = i+min_index+int64(t/2);
            spikes_3 = [spikes_3 spike];
            spike_index = min_index+i;                       %����ֵ������ʱ��������
            spike_indexes_3 = [spike_indexes_3;spike_index];
            
        end
        
        if max_index_temp<min_index_temp         %������
            
            spike =  X((max_index_temp-int64(t/4)):(max_index_temp+int64(3*t/4)),1);
            [max_value,max_index] = max(spike);
            [min_value,min_index] = min(spike);
            base_index = find(spike>Min & spike<Max);
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
                abnormal_spikes = [abnormal_spikes spike];
                abnormal_features = [abnormal_features;2];
                abnormal_indexes = [abnormal_indexes;i];
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
                abnormal_spikes = [abnormal_spikes spike];
                abnormal_features = [abnormal_features;1];        %overlap,��ǰ
                abnormal_indexes = [abnormal_indexes;i];
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
            feature_2(6) = (min_index-first_index)/10;             %����ֵ����
            features_2 = [features_2;feature_2];
            i = i+max_index+int64(3*t/4) + 1;
            spikes_2 = [spikes_2 spike];
            spike_index = max_index+i;                       %����ֵ������ʱ��������
            spike_indexes_2 = [spike_indexes_2;spike_index];
        
        end
    end
    i = i+1;
end

end