function spikes_visualization(spikes,n)
sel = randperm(size(spikes,2));
sel = sel(1:n);
figure;
spikes_length = size(spikes,1);
for i = 1:n
subplot(n^0.5,n^0.5,i);
plot(spikes(:,sel(i)));
axis([0 spikes_length min(spikes(:,sel(i))) max(spikes(:,sel(i)))]);
if i == 23
    xlabel( '随机选出25个波形展示');
end
end
end