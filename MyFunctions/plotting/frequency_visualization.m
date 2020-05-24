function frequency_visualization(path,data,length,Clusters2draw)
global colors;
%%  总体放电频率图
%n = max(idx1);
step = 1;   
t = 0.001:step:length/10^4-step;

if Clusters2draw == 0
    
n_number = [];
figure;
   
for i = 0.001:step:length/10^4-step
    n_index = find(data.spiketimes/10^4>=i & data.spiketimes/10^4<i+step);
    n_number = [n_number;size(n_index,1)];
end
trigger_visualization(data.USindex,data.ESindex,0,max(n_number));
hold on;
plot(t,n_number,'LineWidth',1.5,'Color','#0072BD');
axis([0 length/10^4 0 max(n_number)]);
xlabel('放电频率图（次/s）');



%% 分类后的放电频率图
else

n = size(Clusters2draw,1);

spikes_length = size(data.waveforms,2);
for i = 1:n
    thisIndex = find(data.idx == Clusters2draw(i));
    n_number = [];
    for j = 0.001:step:length/10^4-step
        n_index = find(data.spiketimes(thisIndex)/10^4>=j & data.spiketimes(thisIndex)/10^4<j+step);
        n_number = [n_number;size(n_index,1)];
    end
    f = figure;
    subplot(2,1,1);
    plot(data.waveforms(thisIndex,:)','color',colors(Clusters2draw(i),:));
    axis([0 spikes_length min(min(data.waveforms(thisIndex,:))) max(max(data.waveforms(thisIndex,:)))]);
    subplot(2,1,2);
    frequency = n_number/step;
    plot(t,frequency);
    trigger_visualization(data.USindex,data.ESindex,0,max(frequency));
    axis([0 length/10^4 0 max(frequency)]);
    xlabel('放电频率图（次/s）');

    DirectoryPath =[path '/Result/Image'];
    whereToStore=fullfile(DirectoryPath,['第' num2str(Clusters2draw(i)-1) '根纤维的放电频率.png']);
    saveas(f,whereToStore);
end

end
%{
    %延时标注
    %for j = 1:size(data.USindex,2)
    %    US_firstIndex = data.USindex(1,j);
    %    first_index1 = find(data.spiketimes(thisIndex)>US_firstIndex);
    %    first_index2 = min(first_index1);
    %    first_index = double(data.spiketimes(thisIndex(first_index2)))/10^4;
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
%}
end