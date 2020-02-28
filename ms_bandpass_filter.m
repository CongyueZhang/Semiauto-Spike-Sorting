function Y=ms_bandpass_filter(X,opts)
%MS_FILTER - Bandpass filter using smooth roll-offs in Fourier space
%
%Consider using mscmd_bandpass_filter
%
% Syntax:  [Y] = ms_bandpass_filter(X,opts)
%
% Inputs:
%    X - MxN array of raw data
%    opts.samplerate - the sampling frequency corresponding to X, e.g.
%                      30000
%    The following are optional:
%    opts.freq_min - the lower end of the bandpass filter (Hz)
%                    (use zero or omit this option for pure low-pass)
%    opts.freq_max - the upper end of the bandpass filter (Hz)
%                    (use zero or omit this option for pure high-pass)
%    opts.width_max - width for upper end roll-off (Hz), default 1000
%
% Outputs:
%    Y - MxN array of filtered data
%
% Example:
%    Y=ms_bandpass_filter(X,struct('samplerate',30000,'freq_min',300,'freq_max',6000));
%
% Other m-files required: none
%
% See also: mscmd_bandpass_filter, spikespy

% Author: Jeremy Magland and Alex Barnett
% Oct 2015; Last revision: 13-Feb-2016
% name changed to ms_bandpass_filter on 3/18/16 - jfm
% ahb 6/10/16 improved low-pass via erf, killing zero freq, upper wid opt,
% better opts handling, self-test.

if nargin==0, test_bandpass_filter; return; end

if ~isfield(opts,'freq_max'), opts.freq_max = []; end
if ~isfield(opts,'freq_min'), opts.freq_min = []; end
if ~isfield(opts,'width_max'), opts.width_max = 1e3; end
Y=freqfilter(X,opts.samplerate,opts.freq_min,opts.freq_max,opts.width_max);
end

function X = freqfilter(X,fs,flo,fhi,fwid)
% A snapshot of ahb's freqfilter on 5/22/2015
% SS_FREQFILTER - filter rows of X using smooth roll-offs in Fourier space
%
% X = freqfilter(X,fs,flo,fhi) where X is M*N matrix returns a matrix of same
%  size where each row has been filtered in a bandpass filter with soft rolloffs
%  from flo to fhi (in Hz). fs is the sampling freq in Hz. If flo is empty,
%  a lo-pass is done; if fhi is empty, a hi-pass.
%
% Note: MATLAB's fft is single-core even though claims multicore, for fft(X,[],2)
%  only. fft(X) is multicore.
%
% Hidden parameters: fwid - width of roll-off (Hz). todo: make options.
%
% todo: This could act on EC data object instead?
%
% Barnett 11/14/14.
% 3/11/15: transpose to fft cols (is multicore), blocking (was slower!)
% 6/10/16: better definitions of filter function, w/ -3dB points

if nargin<3, flo = []; end
if nargin<4, fhi = []; end
if nargin<5, fwid = 1e3; end
if ~isempty(fhi) & ~isempty(flo) & fhi<=flo, warning('fhi<=flo: are you sure you want this??'); end
if flo<=0, warning('flo should be positive'); end
if fhi<=0, warning('fhi should be positive'); end

[M N] = size(X);

% -------- do it in blocks (power of 2 = efficient for FFT) ... NB not padded
Nbig = inf; %2^22;      % inf: never uses blocking
if N>2*Nbig
  pad = 1e3;   % only good if filters localized in time (smooth in k space)
  B = Nbig-2*pad;  % block size
  Xpre = zeros(M,pad);
  ptr = 0;
  while ptr+B<N  % so last block can be at most 2B wide
    if ptr+2*B<N, j = ptr+(1:B+pad);
    else, j = ptr+1:N; end  % final block is to end of data
    Y = [Xpre X(:,j)];  % for all but last time Y has Nbig cols, fast
    Xpre = X(:,ptr+B+(-pad+1:0));  % before gets overwritten get next left-pad
    size(Y)
    Yf = freqfilter(Y,fs,flo,fhi);
    X(:,j) = Yf(:,pad+1:end); % right-pad region will get overwritten, fine
    ptr = ptr + B;
  end
  return              % !
end                   % todo: figure out why this was slower than unblocked
                      % even for Nbig = 2^22
% ---------

pad = 1e4;   % enough for our filters
X = [zeros(M,pad) X zeros(M,pad)]; N = size(X,2);  % remove end effects

T = N/fs;  % total time
df = 1/T;  % freq grid including negative ones...
if mod(N,2)==0, f=df*[0:N/2 -N/2+1:-1];else, f=df*[0:(N-1)/2 -(N-1)/2:-1]; end

a = ones(size(f));
filt = 1+0*f;          % act on a unit filter amplitude array
if ~isempty(flo)
  relwid = 3.0;                         % parameter: kills low freqs by 1e-5
  filt = filt .* (1+erf(relwid*(abs(f)-flo)/flo))/2;
  filt(1) = 0;    % kill DC exactly
end
if ~isempty(fhi)
  filt = filt .* (1-erf((abs(f)-fhi)/fwid))/2;
end

% filter: FFT fast along fast
% storage direction, transposing at input & output
filt = sqrt(filt);         % so 0.5 in the filter func becomes -3dB
X = ifft(bsxfun(@times, fft(X'), filt'))'; 

X = X(:,pad+1:end-pad);    % take only central bit

end

%%%%%%%%%%%%%%% Routines for testing (ahb).......................
function Y = run_mscmd(X,o)        % runs mscmd freq filter
d = [tempdir,'/mountainlab'];
if ~exist(d), mkdir(d); end
in = [d,'/bptest_in.mda'];
out = [d,'/bptest_out.mda'];
writemda(X,in,'float32');
if ~isfield(o,'freq_max'), o.freq_max=0; end  % required opts
if ~isfield(o,'freq_min'), o.freq_min=0; end
mscmd_bandpass_filter(in,out,o);
Y = readmda(out);
end

function test_bandpass_filter   % AHB 6/10/16
o.samplerate = 2e4;      % in Hz
X = randn(5,2e6);         % C++ chunk size is 1e6, BTW
%X = 0*X; X(1,1) = 1;   % delta func variant
% check the power spectra...
wid = 100;               % PS smoothing in Hz
figure; subplot(2,1,1);
showpowerspectrum(X,o.samplerate,wid); hold on;
o.freq_min = 300;        % high-pass only
tic; Y = ms_bandpass_filter(X,o); toc
Yc = run_mscmd(X,o);
fprintf('max diff btw matlab and C: %.3g\n',max(max(abs(Y-Yc))))
pad = 2e3;   % empirical # timepts
fprintf('max diff btw matlab and C ignoring end bits: %.3g\n',max(max(abs(Y(:,pad:end-pad)-Yc(:,pad:end-pad)))))
showpowerspectrum(Y,o.samplerate,wid,'r-');
o.freq_max = 6000;       % band-pass
tic; Y = ms_bandpass_filter(X,o); toc
Yc = run_mscmd(X,o);
fprintf('max diff btw matlab and C ignoring end bits: %.3g\n',max(max(abs(Y(:,pad:end-pad)-Yc(:,pad:end-pad)))))
showpowerspectrum(Y,o.samplerate,wid,'k-');
vline([o.freq_min,o.freq_max]);                      % check the -3dB pts
o.freq_min = [];         % low-pass only
tic; Y = ms_bandpass_filter(X,o); toc
Yc = run_mscmd(X,o);
fprintf('max diff btw matlab and C ignoring end bits: %.3g\n',max(max(abs(Y(:,pad:end-pad)-Yc(:,pad:end-pad)))))
showpowerspectrum(Y,o.samplerate,wid,'g-');
set(gca,'yscale','linear');

subplot(2,1,2); % check the impulse responses...
X = zeros(1,1e4); X(10) = 1.0;
j = 1:100;
t = j/o.samplerate;
plot(t,X(j),'.-'); xlabel('time (s)');
hold on;
o.freq_max = []; o.freq_min = 300;        % high-pass only
Y = ms_bandpass_filter(X,o);
plot(t,Y(j),'r.-');
o.freq_max = 6000;       % band pass
Y = ms_bandpass_filter(X,o);
plot(t,Y(j),'k.-');
o.freq_min = [];        % low-pass only
Y = ms_bandpass_filter(X,o);
plot(t,Y(j),'g.-');
end
