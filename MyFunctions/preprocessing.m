function [X,parameters] = preprocessing(X,step,parameters,k)
%% ================== Part 1: 长度截取 ===================

parameters.length = size(X,1);
parameters.length = parameters.length - rem(parameters.length,step);  
X = X(1:parameters.length);                                    %将X的长度截取成m的倍数

%% ================== Part 2: 基线校正 ===================
%优点：不改变波形
%缺点：仍有小幅度波动

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


%% ================== Part 3: 阈值提取 ===================
%[p,value] = histcounts(X);
%[~,midline_index] = max(p);
parameters.midline = 0;
sigma = median(abs(X))/0.6745;
parameters.ceil = parameters.midline+k*sigma;
parameters.floor = parameters.midline-k*sigma;

end