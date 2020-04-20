% 窗体打开前，先执行该函数
function UI_line_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
global ButtonDown pos1;  %声明全局变量
ButtonDown=[];   %标记鼠标是否已经按下。1表示按下，否则表示鼠标未按下
pos1=[];   %存放鼠标的临时位置
guidata(hObject, handles);


% 鼠标按下时执行该函数
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)

global ButtonDown pos1;
if strcmp(get(gcf,'SelectionType'),'normal')   %如果按下的是左键。strcmp判断字符串是否相同
ButtonDown=1;  %标记鼠标已经按下
pos1=get(handles.axes1,'CurrentPoint');   %临时存放鼠标的当前位置
set(handles.text2,'String',num2str(pos1(1,1)));
end


% 鼠标移动时，执行该函数
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)

global ButtonDown pos1; 
if ButtonDown==1   %如果鼠标已经按下
    pos=get(handles.axes1,'CurrentPoint');   
    line([pos1(1,1) pos(1,1)],[pos1(1,2) pos(1,2)],'LineWidth',4);  %画直线, pos是一个一行二列的矩阵，pos(1,1)表示矩阵的第一行第一列的元素。
    pos1=pos;  %更新鼠标的临时位置
end


% 鼠标松开时，执行该函数
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)

global ButtonDown pos1;  %鼠标松开后，初始化这两个全局变量
ButtonDown=[];
pos1=[];