function [X,USindex,ESindex] = dataLoad(path)

X = cell(1,8);
USindex = [];
ESindex = [];
files = dir(fullfile(path,'*.abf'));
length = 0;     %记录当前信号长度（应对某一通道中途关闭的情况）

%{
%按名称排序
xlsfiles={files.name};
[~,idx]=sort(xlsfiles);
files = files(idx);
%}

%按时间排序
files = files(~[files.isdir]);
[~,idx] = sort([files.datenum]);
files = files(idx);

[~,~,info] = abfload(strcat(path,files(1).name),'info');
sampleRate = info.si;          %保持抽样率一致，暂时未补齐相关代码。

for file = files'                                                       %遍历path目录下的.abf文件
    [abf,si,h] = abfload(strcat(path,file.name),'channels','a');  
    length = length + h.lActualAcqLength;
    if contains(str,'_')
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
        X{ChName{2}} = [X{ChName{2}};abf(i)];
        if size(X{ChName{2}})<length
            X{ChName{2}(end+1:length)} = zeros(length-size(X{ChName{2}}),1);
        end
    end
    
    if strcmp(flag,'US')
        %{
        %插值
        t1 = (1:size(abf,1))';
        t2 = (1:0.5:size(abf,1)+0.5)';
        abf = interp1(t1,abf,t2,'spline');
        %}
        
        USperiod = find(abf(end)>0.5);              %若插值，find前要乘以一个倍数
        tempUSIndex = size(X,1) + USperiod;         %算出这些点在总数据中的坐标
        %StartIndex = min(StartIndex);
        USindex = [USindex tempUSIndex];
    end
    
    if strcmp(flag,'ES')
        %USindex = [USindex;size(X_old,1)+1000;]; 
        ESperiod = find(abf(end)>0.1, 1 );
        tempESindex = size(X,1) + ESperiod;
        ESindex = [ESindex tempESindex];
        continue
    end
    
    %{
    %sweep记录
    if strcmp(char(file_info(2,1)),'US1')
        abfUS = abfload(strcat(path,file.name),'channels',{'IN 5'});
        t1 = [];
        tUS = [];
        for i = 1:size(abf,3)
            t1 = [t1;abf(:,:,i)];
            %tUS = [tUS;abfUS(:,:,i)];
            %tempUSIndex = size(X,1) +i*size(abf1,1) + find(tUS>0.5);
            tempUSIndex = size(X,1) +2*i*size(abf,1) + 2 * find(abfUS(:,:,i)>0.5);%插值
            %if size(tempUSIndex,1)<1500
                %tempUSIndex = tempUSIndex(1:1010);
            %end
            USindex = [USindex tempUSIndex];
        end
        
        abf = t1;
        
        %插值
        t1 = (1:size(abf,1))';
        t2 = (1:0.5:size(abf,1)+0.5)';
        %abf3 = interp1(abf2,t,'spline');
        abf = interp1(t1,abf,t2,'spline');
    end
    %}
      
end

end