function preprocessing_visualization(X_old,X)
global parameters;
global data;
global data_path;
global ch;

f = figure;
DirectoryPath = fullfile(data_path,['Result\Image\ch' num2str(ch-1)]);

t = (0.0001:0.0001:size(X_old,1)/10^4)';
subplot(2,1,1); 
plot(t,X_old,'color','#0072BD');
%axis([0 parameters.length/10^4 min(X_old) max(X_old)]);
axis tight;
title('原始信号');
xlabel('Time(s)');
ylabel('Voltage(mV)')

t = (0.0001:0.0001:parameters.length/10^4)';
subplot(2,1,2);
trigger_visualization(data.trigger_Index,min(X),max(X));
hold on;
plot(t,X,'color','#0072BD');
hold on;
plot(t,parameters.ceil * ones(parameters.length,1),'magenta');
hold on;
plot(t,parameters.floor * ones(parameters.length,1),'magenta');
%axis([0 parameters.length/10^4 min(X) max(X)]);
axis tight;
title('基线校正后的信号');
xlabel('Time(s)');
ylabel('Voltage(mV)')


whereToStore=fullfile(DirectoryPath,'preprocessing.png');
saveas(f,whereToStore);

end