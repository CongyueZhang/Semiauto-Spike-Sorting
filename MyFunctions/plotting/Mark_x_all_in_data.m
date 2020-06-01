function Mark_x_all_in_data(option)
%% 将spikes在data中标红
global colors;
global parameters;
global data;
global X;
global ch;
global data_path;

f = figure;
DirectoryPath = fullfile(data_path,['Result\Image\ch' num2str(ch-1)]);

t = (0.0001:0.0001:parameters.length/10^4);
plot(t,X{ch},'color','#0072BD');
hold on;
plot(t,parameters.ceil * ones(parameters.length,1),'magenta');
hold on;
plot(t,parameters.floor * ones(parameters.length,1),'magenta');
hold on;
trigger_visualization(data.trigger_Index,min(X{ch}),max(X{ch}));

if isempty(data.spiketimes_all{ch})
    data.spiketimes_all{ch} = zeros(size(data.waveforms{ch},1),size(data.waveforms{ch},2));
    for i = 1:size(data.spiketimes{ch},1)
        data.spiketimes_all{ch}(i,:) = (data.spiketimes{ch}(i)-floor(0.5 * size(data.waveforms{ch},2)):(data.spiketimes{ch}(i) + floor(0.5 * size(data.waveforms{ch},2))));
    end
    data.spiketimes_all{ch} = data.spiketimes_all{ch} / 10^4;
end

if size(option,1) == 1            %标红option
    if option
        index = find(data.idx{ch} == option);
       
        for i = 1:1:size(index,1)
            hold on;
            plot(data.spiketimes_all{ch}(index(i),:),data.waveforms{ch}(index(i),:),'color',colors(option,:));
        end
        %axis([0 parameters.length/10^4 min(X{ch}) max(X{ch})]);
        axis tight;
        xlabel('Time(s)');
        ylabel('Voltage(mV)');
        
        whereToStore=fullfile(DirectoryPath,['Mark_Cluster' num2str(option) '_in_data.png']);
        saveas(f,whereToStore);
    else            %标红全部spikes
        for i = 1:1:size(data.spiketimes{ch},1)
            hold on;
            plot(data.spiketimes_all{ch}(i,:),data.waveforms{ch}(i,:),'r');
        end
        %axis([0 parameters.length/10^4 min(X{ch}) max(X{ch})]);
        axis tight;
        xlabel('Time(s)');
        ylabel('Voltage(mV)');

        whereToStore=fullfile(DirectoryPath,['Mark_all_in_data.png']);
        saveas(f,whereToStore);
    end
else                %标红cluster option，cluster option有多个
    str_name = [];
    for i = 1:size(option,1)
        index = find(data.idx{ch} == option(i));
        for j = 1:size(index,1)
            hold on
            plot(data.spiketimes_all{ch}(index(j),:),data.waveforms{ch}(index(j),:),'color',colors(option(i),:));
        end
        str_name = [str_name num2str(option(i)-1) '_'];
    end
    %axis([0 parameters.length/10^4 min(X{ch}) max(X{ch})]);
    axis tight;
    xlabel('Time(s)');
    ylabel('Voltage(mV)');
    
    whereToStore=fullfile(DirectoryPath,['Mark_Cluster' str_name '_in_data.png']);
    saveas(f,whereToStore);
end
end