path = 'E:\³¬Éù´Ì¼¤\US RECORD\12_28\test\';
files = dir(fullfile(path,'*.abf'));

files = files(~[files.isdir]);
[~,idx] = sort([files.datenum]);
files = files(idx);
file = files(2);

[abf,si,h] = abfload(strcat(path,file.name),'channels','a');

size(h.recChNames,1)
