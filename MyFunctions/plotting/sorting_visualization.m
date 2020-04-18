function sorting_visualization(path,data)
f = figure;
spikes_length = size(data.waveforms2,1);
spikes_max = max(data.features2(:,3));
spikes_min = min(data.features2(:,5));
n = max(data.idx2);
hold on;
colors = distinguishable_colors(n,'w');

for i = 1:n
    n_index1 = data.idx2 == i;
    plot(data.waveforms2(n_index1,:),'color',colors(i,:));
    axis([0 spikes_length spikes_min spikes_max]);
    %pause
    hold on;
end
xlabel('分类结果');

DirectoryPath =[path '/Result/Image'];
whereToStore=fullfile(DirectoryPath,'分类结果.png');
saveas(f,whereToStore);

end