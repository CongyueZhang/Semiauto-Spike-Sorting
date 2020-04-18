function [features] = featureExtraciton(data,parameters)
    
N = floor(log2(size(waveforms,2)));
[aux, L] = wavedec(waveforms(1,:),N,'haar');
waveforms_WV=nan(size(waveforms,1), length(aux));           %waveforms_WV  每一行是个vector，每一列是一种特征值
for i=1:size(waveforms,1)
    [waveforms_WV(i,:), L] = wavedec(waveforms(i,:),N,'haar');
end

% zcoring the wavelet coefficients
norm_components = zscore(waveforms_WV);
norm_components(isnan(norm_components)) = 0;

nof_wv = size(waveforms_WV,2);      %一个vector里有多少特证数
sep_metric = nan(nof_wv,4);         
param = @(x) [Ipeak(x) Iinf(x)];

gaussMultiFitPDF = nan(nof_wv,1000);
bins = nan(nof_wv,1000);

for wavelet_i = 1:nof_wv
    
    componentvalues = norm_components(:,wavelet_i);
    
    ngauss = parameters.maxGauss;
    flag = 1;
    while flag
        try
            
            UnimodalFit = ...
                gm_EM(componentvalues,ngauss,...
                'options',parameters.optgmfit,...
                'replicates',parameters.nof_replicates,...
                'rep_param',param);
            
            bins(wavelet_i,:) = linspace(min(componentvalues),max(componentvalues),1000);
            gaussMultiFitPDF(wavelet_i,:) = gm_pdf(UnimodalFit,bins(wavelet_i,:)');     %每一行是一种特征值
            sep_metric(wavelet_i,1:3) = median(UnimodalFit.param,1);
            
            flag = 0;
        catch errorinfo
            ngauss = ngauss-1;
            if ngauss<1
                flag = 0;
%                 display(errorinfo.message)
            end
        end
    end
end



end