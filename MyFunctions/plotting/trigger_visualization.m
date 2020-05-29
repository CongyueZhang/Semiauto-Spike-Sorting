function trigger_visualization(USindex,ESindex,Min,Max)

hold on;
for i = 1:size(USindex,2)
X = USindex(:,i);
Y = Max*ones(size(USindex,1),1);
area(X/10^4,Y,'EdgeColor','red','FaceColor','red');
Y = Min*ones(size(USindex,1),1);
area(X/10^4,Y,'EdgeColor','red','FaceColor','red');
end

hold on 
for i = 1:size(ESindex,2)
Y = Max*ones(size(ESindex,1),1);
X = ESindex(:,i);
area(X/10^4,Y,'EdgeColor','blue','FaceColor','blue');
Y = Min*ones(size(ESindex,1),1);
area(X/10^4,Y,'EdgeColor','blue','FaceColor','blue');
end

end