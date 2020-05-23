function sorting_visualization(path,data)
global colors
f = figure;
spikes_length = size(data.waveforms,1);
n = max(data.idx);
hold on;

for i = 1:n
    n_index = data.idx == i;
    plot(data.waveforms(n_index,:)','color',colors(i,:));
    %pause
    hold on;
end

%axis([0 spikes_length max(max(data.waveforms)) min(min(data.waveforms))]);
xlabel('分类结果');

DirectoryPath =[path '/Result/Image'];
whereToStore=fullfile(DirectoryPath,'分类结果.png');
saveas(f,whereToStore);

end