%��ȡ����
addpath('.\Functions');
addpath('.\MyFunctions');

path = 'E:\�����̼�\US RECORD\12_28\E1_processing\';

global data;
global parameters;
parameters =[];

[X_old,data.USindex,data.ESindex] = dataLoad(path);       %��ȡ���ݣ����dataLoad Function


%�˲�����
X_filtered = fix_filter(X_old);

step = 500;    %step
k = 5;
[X,parameters] = preprocessing(X_old,step,parameters,k);    %����Ԥ����

X_filtered = X_filtered(1:parameters.length);

f = figure;

t = (0.0001:0.0001:size(X_old,1)/10^4)';
subplot(2,1,1); 
plot(t,X_old,'color','#0072BD');
axis([0 parameters.length/10^4 min(X_old) max(X_old)]);
title('ԭʼ�ź�');
xlabel('Time(s)');
ylabel('Voltage(mV)')

t = (0.0001:0.0001:parameters.length/10^4)';
subplot(2,1,2);
trigger_visualization(data.USindex,data.ESindex,min(X),max(X));
hold on;
plot(t,X,'color','#0072BD');
axis([0 parameters.length/10^4 min(X) max(X)]);
title('����У������ź�');
xlabel('Time(s)');
ylabel('Voltage(mV)')




f = figure;

t = (0.0001:0.0001:parameters.length/10^4)';
subplot(2,1,1); 
plot(t,X_filtered,'color','#0072BD');
hold on;
plot(t,parameters.ceil * ones(parameters.length,1),'magenta');
hold on;
plot(t,parameters.floor * ones(parameters.length,1),'magenta');
axis([0 parameters.length/10^4 min(X) max(X)]);
title('����λ�˲�����');
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
title('�����Ļ���У������');
xlabel('Time(s)');
ylabel('Voltage(mV)')


