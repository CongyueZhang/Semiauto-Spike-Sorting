function wavelets_filter(data)
% 获取噪声信号
for i = 1 : size(data.waveforms,1)
sig = data.waveforms(i,:);

% 信号的分解  
[c,l]=wavedec(sig,4,'db4');

%提取四层细节分量和近似分量
a1=appcoef(c,l,'db4',1);
d1=detcoef(c,l,1);
a2=appcoef(c,l,'db4',2);
d2=detcoef(c,l,2);
a3=appcoef(c,l,'db4',3);
d3=detcoef(c,l,3);
a4=appcoef(c,l,'db4',4);
d4=detcoef(c,l,4);

% 重构小波分解向量，其中第一层的细节分量被置零
dd1=zeros(size(d1));
dd2=zeros(size(d2)); 
%dd3=zeros(size(d3));
c1=[a4 d4 d3 dd2 dd1];
aa1=waverec(c1,l,'db4');

% 作图  
figure;
subplot(211);   
plot(sig)
title('原始噪声信号');  
subplot(212);
plot(aa1,'b')
title('1层的细节分量置零后的重构信号')

pause;
end
end