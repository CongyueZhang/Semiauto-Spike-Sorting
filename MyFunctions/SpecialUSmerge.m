%[X_old]=abfload('E:\�����̼�\US RECORD\12_28\E1\19d28017.abf');    %����.abf�ļ�
X_old = [];
USindex = [];
path = 'E:\�����̼�\US RECORD\12_28\E1_1\';
files = dir(fullfile(path,'*.abf'));
for file = files'
    file_info = split(file.name,'_');
    abf1 = abfload(strcat(path,file.name),'channels',{'IN 0'});
    if strcmp(char(file_info(3,1)),'US')
        abfUS = abfload(strcat(path,file.name),'channels',{'IN 5'});
        t1 = [];
        tUS = [];
        for i = 1:size(abf1,3)
            t1 = [t1;abf1(:,:,i)];
            tUS = [tUS;abfUS(:,:,i)];
            StartIndex = size(X_old,1) +i*size(abf1,1) + find(tUS>0.5);
            StartIndex = min(StartIndex);
            USindex = [USindex;StartIndex]
        end
        abf1 = t1;
    end
    X_old = [X_old;abf1];
   
end

step = 500;    %step
fprintf('\n\n����Ԥ�������\n\n');
[X,length] = preprocessing(X_old,step);    %����Ԥ����

%save('sample','X','-ascii','-double','-tabs'); % M is the matrix 
