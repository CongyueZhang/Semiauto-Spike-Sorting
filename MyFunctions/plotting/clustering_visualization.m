function clustering_visualization(spikes)

spikes_length = size(spikes,2);
spikes_max = max(spikes,[],'all');
spikes_min = min(spikes,[],'all');

figure;
for i = 1:size(spikes,1)
    plot(spikes(i,:),'color','#0072BD');
    hold on;
    axis([0 spikes_length spikes_min spikes_max]);
end


end