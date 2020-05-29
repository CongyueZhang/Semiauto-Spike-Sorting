function clustering_GMMs()
global data;
global parameters;
%clustering_visualization(data.waveforms2);

%prompt = ['�����ֵΪ���ݷ��࣬����������ΪӦ�÷ֳ��ĸ�����'];
%k = input(prompt);
k = 8;

for ch = parameters.channel
    data.idx{ch} = zeros(size(data.waveforms{ch},1),1);
    %{
    gm = fitgmdist(data.features,k);
    data.idx = cluster(gm,data.features);
    %figure
    %gscatter(data.features2(:,5),data.features2(:,6),idx)
    sorting_visualization(path,data);
    %}
    data.idx{ch} = kmeans(data.features{ch},k);
    %sorting_visualization(path,data);
    
    %{
    for i = 1:max(idx1)
        clustering_visualization(data.waveforms2(idx1 == i,:));
        prompt = ['����Сֵ&��Сֵ����Ϊ���ݷ��࣬����������ΪӦ�÷ֳ��ĸ�����'];
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
end