function [X,length,Max,Min,mu] = preprocessing(X,m,alpha)
%% ================== Part 1: ���Ƚ�ȡ ===================
length = size(X,1);
length = length - rem(length,m);  
X = X(1:length);                                    %��X�ĳ��Ƚ�ȡ��m�ı���
%X = X(1:5000); 
%% ================== Part 2: ����У�� ===================
for i = 1 : m : length-m+1
    x = X(i:i+m-1);
    avg = median(x);
    X(i:i+m-1) = bsxfun(@minus,x,avg);              
end

%d1 = designfilt('bandpassiir','FilterOrder',20, ...
%         'HalfPowerFrequency1',50,'HalfPowerFrequency2',700,'SampleRate',10000);
%X = filtfilt(d1,X);


%X=ms_bandpass_filter(X,struct('samplerate',10000,'freq_min',100,'freq_max',600,'width_max',500));

%% ================== Part 3: ��ֵ��ȡ ===================
[p,value] = histcounts(X);
[~,mu_index] = max(p);
mu = value(mu_index);
sigma = var(value);
Max = mu+sigma*alpha;
Min = mu-sigma*alpha;

%[p1,value1] = histcounts(X);
%[A,mu1_index] = max(p1);
%mu1 = value1(mu1_index)
%sigma1 = var(value1)
%Max1 = mu1+sigma1/alpha;
%Min1 = mu1-sigma1/alpha;
%zero_index = find(X>Min1 & X<Max1);

%X(zero_index) = mu1;
%subplot(3,1,3);
%plot(X);
%axis([0 length -0.3 0.3]);
%xlabel('����ȥ���ѡ�����ź�');


end