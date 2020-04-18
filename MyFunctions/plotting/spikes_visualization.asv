function spikes_visualization(X,data,parameters,option)
%% 将spikes标红
figure;
t = (0.0001:0.0001:parameters.length/10^4);
plot(t,X);
hold on;
plot(t,parameters.ceil * ones(parameters.length,1),'magenta');
hold on;
plot(t,parameters.floor * ones(parameters.length,1),'magenta');

if option
    t = double(data.spiketimes)/10000;
    for i = 1:1:size(data.spiketimes,2)
        hold on;
        plot(t(:,i),data.waveforms(:,i),'r');
    end
    axis([0 parameters.length/10^4 min(X) max(X)]);
    title('基线校正后的信号');
    xlabel('Time(s)');
    ylabel('Voltage(mV)')
else
    for i = 1:1:size(data.spiketimes,2)
        hold on;
        plot(t(:,i),data.waveforms(:,i),'r');
    end
    axis([0 parameters.length/10^4 min(X) max(X)]);
    title('基线校正后的信号');
    xlabel('Time(s)');
    ylabel('Voltage(mV)')
end

%% 随机展示n个
%sel = randperm(size(spikes,2));
%sel = sel(1:n);
%figure;
%spikes_length = size(spikes,1);
%for i = 1:n
%subplot(n^0.5,n^0.5,i);
%plot(spikes(:,sel(i)));
%axis([0 spikes_length min(spikes(:,sel(i))) max(spikes(:,sel(i)))]);
%if i == 23
%    xlabel( '随机选出25个波形展示');
%end
%end

end