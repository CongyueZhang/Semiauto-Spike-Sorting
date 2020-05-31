function trigger_visualization(trigger_Index,Min,Max)
global parameters;
hold on;
for i = 1:size(trigger_Index,2)
    if contains(parameters.name(i),'US')
        X = trigger_Index{:,i};
        Y = Max*ones(size(trigger_Index{i},1),1);
        text(X/10^4,Y,parameters.name(i));
        area(X/10^4,Y,'EdgeColor','red','FaceColor','red');
        Y = Min*ones(size(trigger_Index{i},1),1); 
        area(X/10^4,Y,'EdgeColor','red','FaceColor','red');
    end
    hold on 
    if contains(parameters.name(i),'ES')
        Y = Max*ones(size(trigger_Index{i},1),1);
        X = trigger_Index{:,i};
        text(X/10^4,Y,parameters.name(i));
        area(X/10^4,Y,'EdgeColor','blue','FaceColor','blue');
        Y = Min*ones(size(trigger_Index{i},1),1);
        area(X/10^4,Y,'EdgeColor','blue','FaceColor','blue');
    end
end

end