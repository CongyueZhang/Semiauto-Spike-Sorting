% �����ǰ����ִ�иú���
function UI_line_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
global ButtonDown pos1;  %����ȫ�ֱ���
ButtonDown=[];   %�������Ƿ��Ѿ����¡�1��ʾ���£������ʾ���δ����
pos1=[];   %���������ʱλ��
guidata(hObject, handles);


% ��갴��ʱִ�иú���
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)

global ButtonDown pos1;
if strcmp(get(gcf,'SelectionType'),'normal')   %������µ��������strcmp�ж��ַ����Ƿ���ͬ
ButtonDown=1;  %�������Ѿ�����
pos1=get(handles.axes1,'CurrentPoint');   %��ʱ������ĵ�ǰλ��
set(handles.text2,'String',num2str(pos1(1,1)));
end


% ����ƶ�ʱ��ִ�иú���
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)

global ButtonDown pos1; 
if ButtonDown==1   %�������Ѿ�����
    pos=get(handles.axes1,'CurrentPoint');   
    line([pos1(1,1) pos(1,1)],[pos1(1,2) pos(1,2)],'LineWidth',4);  %��ֱ��, pos��һ��һ�ж��еľ���pos(1,1)��ʾ����ĵ�һ�е�һ�е�Ԫ�ء�
    pos1=pos;  %����������ʱλ��
end


% ����ɿ�ʱ��ִ�иú���
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)

global ButtonDown pos1;  %����ɿ��󣬳�ʼ��������ȫ�ֱ���
ButtonDown=[];
pos1=[];