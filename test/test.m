path = 'E:\³¬Éù´Ì¼¤\US RECORD\12_28\test\Result\Data';
files = dir(fullfile(path,'*.mat'));

for file = files'
    if strcmp(file.name,'data.mat')
        load(fullfile(path,file.name),'data');
        load(fullfile(path,file.name),'parameters');
        load(fullfile(path,file.name),'X');
    end
end