function View_only_x_in_data(option)
%只显示选中的clusters，而不显示其他的spikes
%% 将spikes在data中标红
global colors;
global parameters;
global data;
global X;
global ch;
global data_path;

DirectoryPath = fullfile(data_path,['Result\Image\ch' num2str(ch-1)]);

spike_length = size(data.waveforms{ch},2);

if isempty(data.spiketimes_all{ch})
    data.spiketimes_all{ch} = zeros(size(data.waveforms{ch},1),spike_length);
    for i = 1:size(data.spiketimes{ch},1)
        data.spiketimes_all{ch}(i,:) = (data.spiketimes{ch}(i)-floor(0.5 * spike_length):(data.spiketimes{ch}(i) + floor(0.5 * spike_length)));
    end
    data.spiketimes_all{ch} = data.spiketimes_all{ch} / 10^4;
end

t = (0.0001:0.0001:parameters.length/10^4);

f = figure;
if size(option,1) == 1            %标红option
    index = find(data.idx{ch} == option);
    for i = 1:1:size(index,1)
        hold on;
        plot(data.spiketimes_all{ch}(index(i),:),data.waveforms{ch}(index(i),:),'color',colors(option,:));
    end
    hold on;
    plot([t(1);t(end)],[0;0],'color','#0072BD');
    axis tight;
    xlabel('Time(s)');
    ylabel('Voltage(mV)');
    
    whereToStore=fullfile(DirectoryPath,['View_only_Cluster' num2str(option-1) '_in_data.png']);
    saveas(f,whereToStore);
    
else                %标红cluster option，cluster option有多个
    str_name = [];
    for i = 1:size(option,1)
        index = find(data.idx{ch} == option(i));
        for j = 1:size(index,1)
            hold on;
            plot(data.spiketimes_all{ch}(index(j),:),data.waveforms{ch}(index(j),:),'color',colors(option(i),:));
        end
        str_name = [str_name num2str(option(i)-1) '_'];
    end
    hold on
    plot([t(1);t(end)],[0;0],'color','#0072BD');
    %axis auto;
    axis tight;
    xlabel('Time(s)');
    ylabel('Voltage(mV)');
    
    whereToStore=fullfile(DirectoryPath,['View_only_Cluster' str_name '_in_data.png']);
    saveas(f,whereToStore);
    
end

hold on;
plot(t,parameters.ceil * ones(parameters.length,1),'magenta');
hold on;
plot(t,parameters.floor * ones(parameters.length,1),'magenta');
hold on;
trigger_visualization(data.trigger_Index,min(X{ch}),max(X{ch}));
end