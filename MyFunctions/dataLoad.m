function [X,USindex,ESindex] = dataLoad(path)

X = [];
USindex = [];
ESindex = [];
files = dir(fullfile(path,'*.abf'));
%����������
%xlsfiles={files1.name};
%[~,idx]=sort(xlsfiles);
%files = files1(idx);

for file = files'                                                       %����pathĿ¼�µ�.abf�ļ�
    file_info = split(file.name,'_');
    abf1 = abfload(strcat(path,file.name),'channels',{'IN 0'});     
    if strcmp(char(file_info(2,1)),'US')
        %USindex = [USindex;size(X_old,1)+1000;];
        
        %��ֵ
        abf2 = abf1;
        t = 1.5:size(abf1,1)+0.5;
        abf3 = interp1(abf2,t,'spline');
        for j = 2:2:2*size(abf1,1)
            abf1(j-1) = abf2(j/2);
            abf1(j) = abf3(j/2);
        end
        
        abfUS = abfload(strcat(path,file.name),'channels',{'IN 5'});    
        %USperiod = find(abfUS>0.5);                             %�ҵ�IN 5ͨ����ֵ>0.5�ĵ������ļ��е�����
        
        USperiod = 2 * find(abfUS>0.5);         %��ֵ
        tempUSIndex = size(X,1) + USperiod;                         %�����Щ�����������е�����
        %StartIndex = min(StartIndex);
        USindex = [USindex tempUSIndex];
    end
    
    if strcmp(char(file_info(2,1)),'US1')
        abfUS = abfload(strcat(path,file.name),'channels',{'IN 5'});
        t1 = [];
        tUS = [];
        for i = 1:size(abf1,3)
            t1 = [t1;abf1(:,:,i)];
            %tUS = [tUS;abfUS(:,:,i)];
            %tempUSIndex = size(X,1) +i*size(abf1,1) + find(tUS>0.5);
            tempUSIndex = size(X,1) +2*i*size(abf1,1) + 2 * find(abfUS(:,:,i)>0.5);%��ֵ
            if size(tempUSIndex,1)>1010
                tempUSIndex = tempUSIndex(1:1010);
            end
            USindex = [USindex tempUSIndex];
        end
        
        abf1 = t1;
        
        %��ֵ
        abf2 = abf1;
        t = 1.5:size(abf1,1)+0.5;
        abf3 = interp1(abf2,t,'spline');
        for j = 2:2:2*size(abf1,1)
            abf1(j-1) = abf2(j/2);
            abf1(j) = abf3(j/2);
        end
        
    end
    
    if strcmp(char(file_info(2,1)),'ES.abf')
        %USindex = [USindex;size(X_old,1)+1000;]; 
        ESperiod = min(find(abf1>0.1));
        tempESindex = size(X,1) + ESperiod;
        ESindex = [ESindex tempESindex];
        continue
    end
    
    X = [X;abf1];
      
end

end