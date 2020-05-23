function [X,parameters] = preprocessing(X,step,parameters,k)
%% ================== Part 1: ���Ƚ�ȡ ===================

parameters.length = size(X,1);
parameters.length = parameters.length - rem(parameters.length,step);  
X = X(1:parameters.length);                                    %��X�ĳ��Ƚ�ȡ��m�ı���

%% ================== Part 2: ����У�� ===================
%�ŵ㣺���ı䲨��
%ȱ�㣺����С���Ȳ���

%{
for i = 1 : step : parameters.length-step+1
    x = X(i:i+step-1);
    avg = median(x);
    X(i:i+step-1) = bsxfun(@minus,x,avg);              
end
%}


bpFilt = designfilt('bandpassiir','FilterOrder',2, ...
         'HalfPowerFrequency1',10,'HalfPowerFrequency2',700, ...
         'SampleRate',10000);
X = filtfilt(bpFilt,X);


%% ================== Part 3: ��ֵ��ȡ ===================
%[p,value] = histcounts(X);
%[~,midline_index] = max(p);
parameters.midline = 0;
sigma = median(abs(X))/0.6745;
parameters.ceil = parameters.midline+k*sigma;
parameters.floor = parameters.midline-k*sigma;

end