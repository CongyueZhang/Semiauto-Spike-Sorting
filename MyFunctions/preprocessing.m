function [X] = preprocessing(X,step,k)
global parameters;
for i = parameters.channel
    if ~isempty(X{i})
        %% ================== Part 1: 基线校正 ===================
        %{
        parameters.length = size(X{i},1);
        parameters.length = parameters.length - rem(parameters.length,step);
        X{i} = X{i}(1:parameters.length);                                    %将X的长度截取成m的倍数

        %优点：不改变波形
        %缺点：仍有小幅度波动
        
        for i = 1 : step : parameters.length-step+1
            x = X{i}(i:i+step-1);
            avg = median(x);
            X{i}(i:i+step-1) = bsxfun(@minus,x,avg);
        end
        %}
        %10~700Hz的零相位带通滤波器
        bpFilt = designfilt('bandpassiir','FilterOrder',2, ...
            'HalfPowerFrequency1',10,'HalfPowerFrequency2',700, ...
            'SampleRate',10000);
        X{i} = filtfilt(bpFilt,X{i});
        %% ================== Part 3: 阈值提取 ===================
        parameters.midline = 0;
        sigma = median(abs(X{i}))/0.6745;
        parameters.ceil = parameters.midline+k*sigma;
        parameters.floor = parameters.midline-k*sigma;
    end
end
end