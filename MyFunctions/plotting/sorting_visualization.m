function sorting_visualization(path,data)
f = figure;
spikes_length = size(data.waveforms,1);
n = max(data.idx);
hold on;
colors = distinguishable_colors(n,'w');

for i = 1:n
    n_index = data.idx == i;
    plot(data.waveforms(n_index,:)','color',colors(i,:));
    %pause
    hold on;
end

%axis([0 spikes_length max(max(data.waveforms)) min(min(data.waveforms))]);
xlabel('������');

DirectoryPath =[path '/Result/Image'];
whereToStore=fullfile(DirectoryPath,'������.png');
saveas(f,whereToStore);

end