function spikes_visualization(option)
% option ~= 0 时，在data中标红cluster option
% option == 0 时，在data中标红所有spikes
%% 将spikes在data中标红
global parameters;
global data;
global X;
figure;
t = (0.0001:0.0001:parameters.length/10^4);
plot(t,X);
hold on;
plot(t,parameters.ceil * ones(parameters.length,1),'magenta');
hold on;
plot(t,parameters.floor * ones(parameters.length,1),'magenta');
hold on;
trigger_visualization(data.USindex,data.ESindex,min(X),max(X));
hold on;
t = double(data.spiketimes)/10000;

if option           %标红cluster option
    plot(t(data.idx == option,:)',data.waveforms(data.idx == option,:)','r');
    axis([0 parameters.length/10^4 min(X) max(X)]);
    title('基线校正后的信号');
    xlabel('Time(s)');
    ylabel('Voltage(mV)')
else                %标红所有cluster
    for i = 1:1:size(data.spiketimes,1)
        hold on;
        plot(t(i,:),data.waveforms(i,:),'r');
    end
    axis([0 parameters.length/10^4 min(X) max(X)]);
    title('基线校正后的信号');
    xlabel('Time(s)');
    ylabel('Voltage(mV)')
end

end