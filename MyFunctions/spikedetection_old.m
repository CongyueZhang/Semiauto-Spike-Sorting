function spikedetection_old(X,t,parameters)
%% ===================阈值搜索、特征判断、特征提取 ===================
%此算法假设噪声全在阈值里，没有考虑噪声意外超出阈值的情况

global data;

i = t;
over_index = size(X,1)-2*t-2;

%阈值搜索
while i < over_index
    if(X(i)<parameters.floor || X(i)>parameters.ceil)                                                 %超出噪声范围，说明附近有信号
        [value,index] = min(X(i:i+int64(3*t/4)));
        if value > parameters.floor
        [~,index] = max(X(i:i+int64(3*t/4)));
        end
        spike =  X((i+index-int64(t/3)):(i+index+int64(t/3)),1);
        [~,max_index_temp] = max(spike);
        max_index_temp = i+index-int64(t/3)+max_index_temp;
        [~,min_index_temp] = min(spike);
        min_index_temp = i+index-int64(t/3)+min_index_temp;       %在总时间轴上的位置
        
        if(max_index_temp<i||min_index_temp<i)      %前方overlap
            spike = X(i-t:i+t,1);
            data.waveforms_abnormal = [data.waveforms_abnormal;spike'];
            data.features_abnormal = [data.features_abnormal;1];
            data.spiketimes_abnormal = [data.spiketimes_abnormal;i];
            i = i+t+1;
            continue;
        end
        
        %正1负正2
        if max_index_temp>min_index_temp                                            
            spike =  X((min_index_temp-int64(t/2)):(min_index_temp+int64(t/2)),1);
            [min_value,min_index] = min(spike);
            [max_value1,max_index1] = max(spike(1:min_index));       %正1（前面的正）       
            [max_value2,max_index2] = max(spike(min_index:end));       %正2（后面的正）
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
        
            if min_index>max_index2 || isempty(end_index)           %后方overlap
                %figure;
                %plot(X(i:i+2*t));
                spike =  X(i:i+2*t,1);
                data.waveforms_abnormal = [data.waveforms_abnormal;spike'];
                data.features_abnormal = [data.features_abnormal;2];
                data.spiketimes_abnormal = [data.spiketimes_abnormal;i];
                i = i + 2 * t + 1;
                continue;
            end
        
            if isempty(start_index)                 %前方overlap
                %figure;
                %plot(X(i-100:i+100));
                
                spike =  X(i-t:i+t,1);
                data.waveforms_abnormal = [data.waveforms_abnormal;spike'];
                data.features_abnormal = [data.features_abnormal;1];
                data.spiketimes_abnormal = [data.spiketimes_abnormal;i];
                i = i + t + 1;
                continue;
            end
        
            first_index = max(base_index(start_index));       %注意补充考虑max_value1<parameters.ceil → first_index>max_index1 的情况
        
            if max_value1<parameters.ceil/2
                max_value1 = 0;
                max_index1 = first_index;
            end
            
            last_index = min(base_index(end_index));
            feature_3(1) = max_value1;                        %正1峰值
            feature_3(2) = (max_index1-first_index)/10;       %正1峰值坐标
            feature_3(3) = max_value2;                        %正2峰值
            feature_3(4) = (max_index2-first_index)/10;      %正2坐标
            feature_3(5) = min_value;                         %负峰值
            feature_3(6) = (min_index-first_index)/10;        %负峰值坐标
            feature_3(7) = (last_index-first_index)/10;       %尾值坐标
            data.features3 = [data.features3;feature_3];
            i = i+min_index+int64(t/2);
            data.waveforms3 = [data.waveforms3;spike'];
            spike_index = min_index+i;                       %正峰值在整体时间轴坐标
            data.spiketimes3_max = [data.spiketimes3_max;spike_index];
            
            spiketimes3 = min_index_temp-int64(t/2):1:min_index_temp+int64(t/2);
            data.spiketimes3 = [data.spiketimes3;spiketimes3];
            
        end
        
        if max_index_temp<min_index_temp         %先正后负
            
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
        
            if min_index<max_index || isempty(end_index)      %后方出现overlap （高正幅度信号）
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
                data.features_abnormal = [data.features_abnormal;1];        %overlap,在前
                data.spiketimes_abnormal = [data.spiketimes_abnormal;i];
                i = i + t + 1;
                continue;
            end
        
            first_index = max(base_index(start_index));
        
            last_index = min(base_index(end_index));
            feature_2(1) = (mid_index-first_index)/10;             %中点坐标
            feature_2(2) = (last_index-first_index)/10;            %尾值坐标
            feature_2(3) = max_value;                              %正峰值
            feature_2(4) = (max_index-first_index)/10;             %正峰值坐标
            feature_2(5) = min_value;                              %负峰值
            %feature_2(6) = (min_index-first_index)/10;             %负峰值坐标
            feature_2(6) = min_index/10;
            data.features2 = [data.features2;feature_2];
            i = i+max_index+int64(3*t/4) + 1;
            data.waveforms2 = [data.waveforms2;spike'];
            spike_index = max_index+i;                       %正峰值在整体时间轴坐标
            data.spiketimes2_max = [data.spiketimes2_max;spike_index];
            
            spiketimes2 = max_index_temp-int64(t/4):1:max_index_temp+int64(3*t/4);
            data.spiketimes2 = [data.spiketimes2;spiketimes2];
        
        end
    end
    i = i+1;
end

end