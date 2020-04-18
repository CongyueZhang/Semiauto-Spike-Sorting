function Spikesinterp()
global data;

oldspikes = data.waveforms2;
data.waveforms2 = zeros(size(oldspikes,1),5 * size(oldspikes,2));
told = 1:1:size(oldspikes,2);
tnew = 0.2:0.2:size(oldspikes,2);

for i = 1:size(oldspikes,1)
    data.waveforms2(i,:) = interp1(told,oldspikes(i,:),tnew,'spline');
end

end