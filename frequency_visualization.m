function frequency_visualization(path,idx2,idx3,spikes_2,spikes_3,spike_indexes_2,spike_indexes_3,abnormal_indexes,length,USindex,ESindex)

%%  总体放电频率图
%n = max(idx1);
n_number = [];
figure;
step = 2;
for i = 0.001:step:length/10^4-step
    n_index1 = find(spike_indexes_2/10^4>=i & spike_indexes_2/10^4<i+step);
    n_index2 = find(spike_indexes_3/10^4>=i & spike_indexes_3/10^4<i+step);
    n_index3 = find(abnormal_indexes/10^4>=i & abnormal_indexes/10^4<i+step);
    n_index = size(n_index1,1) + size(n_index2,1) + size(n_index3,1);
    n_number = [n_number;n_index];
end
x = 0.001:step:length/10^4-step;
trigger_visualization(USindex,ESindex,0,max(n_number));
hold on;
plot(x,n_number,'LineWidth',1.5);
axis([0 length/10^4 0 max(n_number)]);
xlabel('放电频率图（次/2s）');

%% 分类后的放电频率图

n = max(idx2);
colors = distinguishable_colors(n,'w');
spikes_length2 = size(spikes_2,1);
for i = 2:1:n
    thisIndex = find(idx2 == i);
    n_number = [];
    for j = 0.001:step:length/10^4-step
        n_index = find(spike_indexes_2(thisIndex)/10^4>=j & spike_indexes_2(thisIndex)/10^4<j+step);
        n_number = [n_number;size(n_index,1)];
    end
    f = figure;
    subplot(2,1,1);
    plot(spikes_2(:,thisIndex),'color',colors(i,:));
    axis([0 spikes_length2 min(min(spikes_2(:,thisIndex))) max(max(spikes_2(:,thisIndex)))]);
    subplot(2,1,2);
    frequency = n_number/step;
    plot(x,frequency);
    trigger_visualization(USindex,ESindex,0,max(frequency));
    axis([0 length/10^4 0 max(frequency)]);
    xlabel('放电频率图（次/2s）');

    DirectoryPath =[path '/Result/Image'];
    whereToStore=fullfile(DirectoryPath,['第' num2str(i-1) '根纤维的放电频率.png']);
    saveas(f,whereToStore);

    %延时标注
    %for j = 1:size(USindex,2)
    %    US_firstIndex = USindex(1,j);
    %    first_index1 = find(spike_indexes_2(thisIndex)>US_firstIndex);
    %    first_index2 = min(first_index1);
    %    first_index = double(spike_indexes_2(thisIndex(first_index2)))/10^4;
    %    if isempty(first_index)
    %        continue;
    %    end
    %    hold on;
    %    txt = ['\leftarrowFirst spike:' num2str(first_index) 's'];
    %    scatter(first_index,0,'o','m');
    %    text(double(first_index),0,txt);
    %    US_firstIndex = double(US_firstIndex)/10^4;
    %    txt = ['US:' num2str(US_firstIndex) 's \rightarrow'];
    %    scatter(US_firstIndex,0,'x','MarkerEdgeColor',[0 0.4470 0.7410]	);
    %    text(US_firstIndex,0,txt,'HorizontalAlignment','right');
    %    txt = ['delay:' num2str(double(double(first_index)-double(US_firstIndex))) 's'];
    %    text(double(first_index),max(n_number)/2,txt)
    %end
   
end

%figure
%for i = 1:1:n
%    thisIndex = find(idx2 == i);
%    
%end

end