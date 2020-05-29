function [X] = preprocessing(X,step,k)
global parameters;
for i = parameters.channel
    if ~isempty(X{i})
        %% ================== Part 1: ����У�� ===================
        %{
        parameters.length = size(X{i},1);
        parameters.length = parameters.length - rem(parameters.length,step);
        X{i} = X{i}(1:parameters.length);                                    %��X�ĳ��Ƚ�ȡ��m�ı���

        %�ŵ㣺���ı䲨��
        %ȱ�㣺����С���Ȳ���
        
        for i = 1 : step : parameters.length-step+1
            x = X{i}(i:i+step-1);
            avg = median(x);
            X{i}(i:i+step-1) = bsxfun(@minus,x,avg);
        end
        %}
        %10~700Hz������λ��ͨ�˲���
        bpFilt = designfilt('bandpassiir','FilterOrder',2, ...
            'HalfPowerFrequency1',10,'HalfPowerFrequency2',700, ...
            'SampleRate',10000);
        X{i} = filtfilt(bpFilt,X{i});
        %% ================== Part 3: ��ֵ��ȡ ===================
        parameters.midline = 0;
        sigma = median(abs(X{i}))/0.6745;
        parameters.ceil = parameters.midline+k*sigma;
        parameters.floor = parameters.midline-k*sigma;
    end
end
end