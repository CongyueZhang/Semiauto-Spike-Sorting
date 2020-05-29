function X = dataLoad(path)
global parameters;
global data;

parameters.channel =[];
path = [path '\'];
X = cell(1,8);
data.USindex = [];
data.ESindex = [];
files = dir(fullfile(path,'*.abf'));
length = 0;     %��¼��ǰ�źų��ȣ�Ӧ��ĳһͨ����;�رյ������

%{
%����������
xlsfiles={files.name};
[~,idx]=sort(xlsfiles);
files = files(idx);
%}

%��ʱ������
files = files(~[files.isdir]);
[~,idx] = sort([files.datenum]);
files = files(idx);

[~,~,info] = abfload(strcat(path,files(1).name),'info');
sampleRate = info.si;          %���ֳ�����һ�£���ʱδ������ش��롣

for file = files'                                                       %����pathĿ¼�µ�.abf�ļ�
    [abf,si,h] = abfload(strcat(path,file.name),'channels','a');  
    length = length + h.lActualAcqLength;
    
    % ��ֵ
    t1 = (1 : si/sampleRate : si/sampleRate*size(abf,1))';
    t2 = (1:1:si/sampleRate*size(abf,1))';
    
    abf_inter = zeros(size(t2,1),size(h.recChNames,1));
    for i = 1:size(h.recChNames,1)
        %��ֵ
        abf_inter(:,i) = interp1(t1,abf(:,i),t2,'spline');
    end
    abf = abf_inter;
    
    if contains(file.name,'_')
        file_info = split(file.name,'_');
        
        if strcmp(char(file_info(2,1)),'US')
            flag = 'US';
            ChNumber = size(h.recChNames,1)-1;
        end
        if strcmp(char(file_info(2,1)),'ES')
            flag = 'ES';
            ChNumber = size(h.recChNames,1)-1;
        end
    else
        flag = 'gapfree';
        ChNumber = size(h.recChNames,1);
    end

    for i = 1:ChNumber
        ChName = split(h.recChNames{i},' ');
        ChIdx = str2num(ChName{2}) + 1;
        if ~sum(contains(string(parameters.channel),int2str(ChIdx)))
            parameters.channel = [parameters.channel ChIdx];
        end
        
        X{ChIdx} = [X{ChIdx};abf(:,i)];
        if size(X{ChIdx},1)<length
            X{ChIdx}(end+1:length) = zeros(length-size(X{ChIdx},1),1);
        end
    end
    
    if strcmp(flag,'US')
        %{
        %��ֵ
        t1 = (1:size(abf,1))';
        t2 = (1:0.5:size(abf,1)+0.5)';
        abf = interp1(t1,abf,t2,'spline');
        %}
        
        USperiod = find(abf(:,end)>0.5);              %����ֵ��findǰҪ����һ������
        tempUSIndex = length + USperiod;         %�����Щ�����������е�����
        %StartIndex = min(StartIndex);
        data.USindex = [data.USindex tempUSIndex];
    end
    
    if strcmp(flag,'ES')
        %data.USindex = [data.USindex;size(X_old,1)+1000;]; 
        ESperiod = find(abf(end,i)>0.1, 1 );
        tempESindex = length + ESperiod;
        data.ESindex = [data.ESindex tempESindex];
        continue;
    end
    
    %{
    %sweep��¼
    if strcmp(char(file_info(2,1)),'US1')
        abfUS = abfload(strcat(path,file.name),'channels',{'IN 5'});
        t1 = [];
        tUS = [];
        for i = 1:size(abf,3)
            t1 = [t1;abf(:,:,i)];
            %tUS = [tUS;abfUS(:,:,i)];
            %tempUSIndex = size(X,1) +i*size(abf1,1) + find(tUS>0.5);
            tempUSIndex = size(X,1) +2*i*size(abf,1) + 2 * find(abfUS(:,:,i)>0.5);%��ֵ
            %if size(tempUSIndex,1)<1500
                %tempUSIndex = tempUSIndex(1:1010);
            %end
            data.USindex = [data.USindex tempUSIndex];
        end
        
        abf = t1;
        
        %��ֵ
        t1 = (1:size(abf,1))';
        t2 = (1:0.5:size(abf,1)+0.5)';
        %abf3 = interp1(abf2,t,'spline');
        abf = interp1(t1,abf,t2,'spline');
    end
    %}
      
end
parameters.length = length;
end