function Mark_x_all_in_data(option)
%% ��spikes��data�б��
global colors;
global parameters;
global data;
global X;
figure;
t = (0.0001:0.0001:parameters.length/10^4);
plot(t,X,'color','#0072BD');
hold on;
plot(t,parameters.ceil * ones(parameters.length,1),'magenta');
hold on;
plot(t,parameters.floor * ones(parameters.length,1),'magenta');
hold on;
trigger_visualization(data.USindex,data.ESindex,min(X),max(X));

try data.spiketimes_all;
    
catch
    data.spiketimes_all = zeros(size(data.waveforms,1),size(data.waveforms,2));
    for i = 1:size(data.spiketimes,1)
        data.spiketimes_all(i,:) = (data.spiketimes(i)-floor(0.5 * size(data.waveforms,2)):(data.spiketimes(i) + floor(0.5 * size(data.waveforms,2))));
    end
    data.spiketimes_all = data.spiketimes_all / 10^4;
end

if size(option,1) == 1            %���option
    if option
        index = find(data.idx == option);
       
        for i = 1:1:size(index,1)
            hold on;
            plot(data.spiketimes_all(index(i),:),data.waveforms(index(i),:),'color',colors(option,:));
        end
        axis([0 parameters.length/10^4 min(X) max(X)]);
        xlabel('Time(s)');
        ylabel('Voltage(mV)');
    else            %���ȫ��spikes
        for i = 1:1:size(data.spiketimes,1)
            hold on;
            plot(data.spiketimes_all(i,:),data.waveforms(i,:),'r');
        end
        axis([0 parameters.length/10^4 min(X) max(X)]);
        xlabel('Time(s)');
        ylabel('Voltage(mV)');
    end
else                %���cluster option��cluster option�ж��
    for i = 1:size(option,1)
        index = find(data.idx == option(i));
        for j = 1:size(index,1)
            hold on
            plot(data.spiketimes_all(index(j),:),data.waveforms(index(j),:),'color',colors(option(i),:));
        end
    end
    axis([0 parameters.length/10^4 min(X) max(X)]);
    xlabel('Time(s)');
    ylabel('Voltage(mV)');
end

end