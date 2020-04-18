function [X,parameters] = preprocessing(X,step,parameters,k)
%% ================== Part 1: ���Ƚ�ȡ ===================
parameters.length = size(X,1);
parameters.length = parameters.length - rem(parameters.length,step);  
X = X(1:parameters.length);                                    %��X�ĳ��Ƚ�ȡ��m�ı���
%% ================== Part 2: ����У�� ===================

%�ŵ㣺���ı䲨��
%ȱ�㣺����С���Ȳ���
for i = 1 : step : parameters.length-step+1
    x = X(i:i+step-1);
    avg = median(x);
    X(i:i+step-1) = bsxfun(@minus,x,avg);              
end


%��Բ�˲�
%X = fix_filter(X)';

%�˲�����
%d1 = designfilt('bandpassiir','FilterOrder',20, ...
%         'HalfPowerFrequency1',50,'HalfPowerFrequency2',700,'SampleRate',10000);
%X = filtfilt(d1,X);


%X=ms_bandpass_filter(X,struct('samplerate',10000,'freq_parameters.floor',100,'freq_parameters.ceil',600,'width_parameters.ceil',500));

%% ================== Part 3: ��ֵ��ȡ ===================
%[p,value] = histcounts(X);
%[~,midline_index] = max(p);
parameters.midline = 0;
sigma = median(abs(X))/0.6745;
parameters.ceil = parameters.midline+k*sigma;
parameters.floor = parameters.midline-k*sigma;

end