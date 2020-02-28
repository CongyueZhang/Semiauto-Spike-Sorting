path = 'E:\超声刺激\US RECORD\12_24\E1_processing\';
[X_old,USindex,ESindex] = dataLoad(path);

%% ================== Part 1: Preprocessing ===================
step = 100;    %step
fprintf('\n\n进行预处理操作\n\n');
%alpha = 1/2.5;     %E1参数
%alpha = 1.5;       %E2参数
%alpha = 2.3;        %12_24 E2参数
%alpha = 37;        %12_24 E3参数
alpha = 8;        %12_24 E1参数
[X,length,Max,Min,mu] = preprocessing(X_old,step,alpha);    %调用预处理
preprocessing_visualization(path,X_old,X,length,USindex,ESindex,Max,Min,mu);

%% ================== Part 2: Spikes detection ===================
t = 9;   %spike的长度，单位ms
[spikes_2,spikes_3,spike_indexes_2,spike_indexes_3,abnormal_indexes,features_2,features_3,abnormal_spikes,abnormal_features] = spikedetection(X,t*10,Max,Min);
n = 25;
%spikes_visualization(spikes,n);

%% ================== Part 3: Spikes sorting ===================
idx2 = [];
idx3 = [];
if isempty(features_2) == 0

features_old = features_2;
%scale
v = max(max(features_2(:,3)),max(features_2(:,5)));
%v = max(max(features(:,1)));

%alpha = t*10/3/v;  %E1
%alpha = t*10/3/v;  %E2
%alpha = t*10/2/v;   %12_24  E2  E3
alpha = t*10/0.9/v;   %12_24  E1

features_2(:,3) = alpha/2*features_2(:,3);
%features_2(:,5) = 1.5*alpha*features_2(:,5);    %E1 E2
features_2(:,5) = alpha*features_2(:,5);    %12_24 E1 E2 E3
%features_2(:,6) = 6*features_2(:,6);   %E1 E2
features_2(:,6) = 1.6*features_2(:,6);

%[clustCent,idx1,cluster2dataCell] = MeanShiftCluster(features',2);
%idx2 = DBSCAN(features_2,0.8,6);    %E1
%idx2 = DBSCAN(features_2,1,6);     %E2
%idx2 = DBSCAN(features_2,1.2,4);      %12_24 E2 E3
idx2 = DBSCAN(features_2,2.5,4);      %12_24 E1

idx2 = idx2 + 1;
sorting_visualization(path,idx2,spikes_2,features_old);
end


if isempty(features_3) == 0

features_old = features_3;
%scale
v = max(max(features_3(:,3)),max(features_3(:,5)));
%v = max(max(features(:,1)));
features_3(:,3) = alpha*features_3(:,3);
features_3(:,5) = alpha*features_3(:,5);
%features_2(:,5) = features_2(:,5);

%[clustCent,idx1,cluster2dataCell] = MeanShiftCluster(features',2);
idx3 = DBSCAN(features_3,1,4);
idx3 = idx3 + 1;
sorting_visualization(idx1,spikes_3,features_old);
end


frequency_visualization(path,idx2,idx3,spikes_2,spikes_3,spike_indexes_2,spike_indexes_3,abnormal_indexes,length,USindex,ESindex);


%Max = 0;
%for i = 1:n
%    n_index1 = find(idx1 == i);
%    if features(n_index1(1),1)>Max
%        Max = n_max;
%    end
%end

%for i = 1:n
%    n_index1 = find(idx1 == i);
%    if features(n_index1(1),1)<Max/3
%        idx1(n_index1) = n+1;
%    end
%end
