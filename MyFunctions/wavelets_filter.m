function wavelets_filter(data)
% ��ȡ�����ź�
for i = 1 : size(data.waveforms,1)
sig = data.waveforms(i,:);

% �źŵķֽ�  
[c,l]=wavedec(sig,4,'db4');

%��ȡ�Ĳ�ϸ�ڷ����ͽ��Ʒ���
a1=appcoef(c,l,'db4',1);
d1=detcoef(c,l,1);
a2=appcoef(c,l,'db4',2);
d2=detcoef(c,l,2);
a3=appcoef(c,l,'db4',3);
d3=detcoef(c,l,3);
a4=appcoef(c,l,'db4',4);
d4=detcoef(c,l,4);

% �ع�С���ֽ����������е�һ���ϸ�ڷ���������
dd1=zeros(size(d1));
dd2=zeros(size(d2)); 
%dd3=zeros(size(d3));
c1=[a4 d4 d3 dd2 dd1];
aa1=waverec(c1,l,'db4');

% ��ͼ  
figure;
subplot(211);   
plot(sig)
title('ԭʼ�����ź�');  
subplot(212);
plot(aa1,'b')
title('1���ϸ�ڷ����������ع��ź�')

pause;
end
end