function clustering_GMMs(data,path)

%clustering_visualization(data.waveforms2);

prompt = ['以最大值为依据分类，请输入你认为应该分出的个数：'];
k = input(prompt);

gm = fitgmdist([data.features2(:,5) data.features2(:,6)],k);
idx = cluster(gm,[data.features2(:,5) data.features2(:,6)]);
figure
gscatter(data.features2(:,5),data.features2(:,6),idx)

%{
for i = 1:max(idx1)
    clustering_visualization(data.waveforms2(idx1 == i,:));
    prompt = ['以最小值&最小值坐标为依据分类，请输入你认为应该分出的个数：'];
    k = input(prompt);
    idx2 = kmeans([data.features2(:,5) data.features2(:,6)],k);
    
    n = max(data.idx2);
    for j = 1:size(idx2,2)
        data.idx2(idx1(idx2 == j) == i) = n + j;
    end
end

sorting_visualization(path,data);
%}
end