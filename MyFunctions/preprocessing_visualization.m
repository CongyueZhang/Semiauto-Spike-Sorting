function preprocessing_visualization(path,X_old,X_new,length,USindex,ESindex,Max,Min,mu)

f = figure;

t = (0.0001:0.0001:size(X_old,1)/10^4)';
subplot(2,1,1); 
plot(t,X_old);
axis([0 length/10^4 min(X_old) max(X_old)]);
title('原始信号');
xlabel('Time(s)');
ylabel('Voltage(mV)')

t = (0.0001:0.0001:length/10^4)';
subplot(2,1,2);
trigger_visualization(USindex,ESindex,min(X_new),max(X_new));
hold on;
plot(t,X_new);
hold on;
plot(t,Max * ones(length,1),'magenta');
hold on;
plot(t,Min * ones(length,1),'magenta');
axis([0 length/10^4 min(X_new) max(X_new)]);
title('基线校正后的信号');
xlabel('Time(s)');
ylabel('Voltage(mV)')

DirectoryPath =[path '/Result/Image'];
if ~exist(DirectoryPath, 'dir')
    mkdir(DirectoryPath)
end
whereToStore=fullfile(DirectoryPath,'预处理.png');
saveas(f,whereToStore);

%subplot(2,1,2);
%zero_index = find(X_new>Min & X_new<Max);
%X_new(zero_index) = mu;
%plot(t,X_new);
%axis([0 length/10^4 min(X_new) max(X_new)]);
%title('筛选出的信号');
%xlabel('Time(s)');
%ylabel('Voltage(mV)')


end