function preprocessing_visualization(path,X_old,X)
global parameters;
global data;

f = figure;

t = (0.0001:0.0001:size(X_old,1)/10^4)';
subplot(2,1,1); 
plot(t,X_old,'color','#0072BD');
axis([0 parameters.length/10^4 min(X_old) max(X_old)]);
title('原始信号');
xlabel('Time(s)');
ylabel('Voltage(mV)')

t = (0.0001:0.0001:parameters.length/10^4)';
subplot(2,1,2);
trigger_visualization(data.USindex,data.ESindex,min(X),max(X));
hold on;
plot(t,X,'color','#0072BD');
hold on;
plot(t,parameters.ceil * ones(parameters.length,1),'magenta');
hold on;
plot(t,parameters.floor * ones(parameters.length,1),'magenta');
axis([0 parameters.length/10^4 min(X) max(X)]);
title('基线校正后的信号');
xlabel('Time(s)');
ylabel('Voltage(mV)')

DirectoryPath =[path '/Result/Image'];
if ~exist(DirectoryPath, 'dir')
    mkdir(DirectoryPath)
end
whereToStore=fullfile(DirectoryPath,'预处理.png');
saveas(f,whereToStore);

end