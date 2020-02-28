function sorting_visualization(idx1,spikes,features)

spikes_length = size(spikes,1);
spikes_max = max(features(:,3));
spikes_min = min(features(:,5));
n = max(idx1);
hold on;
colors = distinguishable_colors(n,'w');

for i = 2:n
    n_index1 = find(idx1 == i);
    plot(spikes(:,n_index1),'color',colors(i,:));
    axis([0 spikes_length spikes_min spikes_max]);
    %pause
    hold on;
end
xlabel('分类结果');

end