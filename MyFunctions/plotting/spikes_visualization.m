function spikes_visualization(option)
%% 将spikes在data中标红
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

t = zeros(size(data.waveforms,1),size(data.waveforms,2));

for i = 1:size(data.spiketimes,1)
    t(i,:) = (data.spiketimes(i)-floor(0.5 * size(data.waveforms,2)):(data.spiketimes(i) + floor(0.5 * size(data.waveforms,2))));
end

t = t / 10^4;

if size(option,1) == 1            %标红option
    if option
        index = find(data.idx == option);
        for i = 1:1:size(index,1)
            hold on;
            plot(t(index(i),:),data.waveforms(index(i),:),'color',colors(i,:));
        end
        axis([0 parameters.length/10^4 min(X) max(X)]);
        xlabel('Time(s)');
        ylabel('Voltage(mV)');
    else            %标红全部spikes
        for i = 1:1:size(data.spiketimes,1)
            hold on;
            plot(t(i,:),data.waveforms(i,:),'r');
        end
        axis([0 parameters.length/10^4 min(X) max(X)]);
        xlabel('Time(s)');
        ylabel('Voltage(mV)');
    end
else                %标红cluster option，cluster option有多个
    for i = 1:size(option,1)
        index = find(data.idx == option(i));
        for j = 1:size(index,1)
            hold on
            plot(t(index(j),:),data.waveforms(index(j),:),'color',colors(option(i),:));
        end
    end
    axis([0 parameters.length/10^4 min(X) max(X)]);
    xlabel('Time(s)');
    ylabel('Voltage(mV)');
end

end