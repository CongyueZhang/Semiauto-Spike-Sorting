function View_only_x_in_data(option)
%只显示选中的clusters，而不显示其他的spikes
%% 将spikes在data中标红
global colors;
global parameters;
global data;
global X;
spike_length = size(data.waveforms,2);

try data.spiketimes_all;
catch
    data.spiketimes_all = zeros(size(data.waveforms,1),spike_length);
    for i = 1:size(data.spiketimes,1)
        data.spiketimes_all(i,:) = (data.spiketimes(i)-floor(0.5 * spike_length):(data.spiketimes(i) + floor(0.5 * spike_length)));
    end
    data.spiketimes_all = data.spiketimes_all / 10^4;
end

t = (0.0001:0.0001:parameters.length/10^4);

figure;
if size(option,1) == 1            %标红option
    index = find(data.idx == option);
    for i = 1:1:size(index,1)
        hold on;
        plot(data.spiketimes_all(index(i),:),data.waveforms(index(i),:),'color',colors(option,:));
    end
    hold on;
    plot([t(1);t(end)],[0;0],'color','#0072BD');
    axis auto;
    xlabel('Time(s)');
    ylabel('Voltage(mV)');
else                %标红cluster option，cluster option有多个
    for i = 1:size(option,1)
        index = find(data.idx == option(i));
        for j = 1:size(index,1)
            hold on;
            plot(data.spiketimes_all(index(j),:),data.waveforms(index(j),:),'color',colors(option(i),:));
        end
    end
    hold on
    plot([t(1);t(end)],[0;0],'color','#0072BD');
    axis auto;
    xlabel('Time(s)');
    ylabel('Voltage(mV)');
end

hold on;
plot(t,parameters.ceil * ones(parameters.length,1),'magenta');
hold on;
plot(t,parameters.floor * ones(parameters.length,1),'magenta');
hold on;
trigger_visualization(data.USindex,data.ESindex,min(X),max(X));

end