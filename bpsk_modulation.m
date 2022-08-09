%clc;
%clear all;
%close all;

data = [1 0 0 1 1 0 1 1 1 0] %input binary data

data = data.'

Fc = 100 %Carrier frequency
Eb = 50 %Energy of the signal
T = 1/Fc %Period of the signal

Fs = Fc*100; %Sampling frequency
dt = 1/Fs; 
StopTime = length(data) * T; 
t = (0:dt:StopTime-dt)';

for i = 1:length(data) %nrz process
    if data(i) == 0
        data(i) = -1;
    end
end

y = modulation(data, Fc, t, Eb);
%k = awgn(y, 1, 10*log10(Eb/T));
r = ft_awgn(y, 1, Eb);
output = demodulation(r,Fc, t);

figure;
plot(t, r, 'LineWidth', 1);
zoom xon;

function y = modulation(data, Fc, t, Eb)
    T = 1/Fc;
    s = data(fix(t / T) + 1) * sqrt(Eb); %representation of input data under time domain
    p = cos(2*pi*Fc*t) * sqrt(2/T); %basis function
    y = times(s,p);
end

function dem = demodulation(r, Fc, t) 
    T = 1/Fc;
    Fs = Fc*20;
    dem = zeros(1, length(r)/(T*Fs));
    p = cos(2*pi*Fc*t) * sqrt(2/T); %basis function
    rbb = r.*p;
    for i=1:length(rbb)/(T*Fs)
        lowerbnd = (i - 1)* T * Fs + 1;
        upperbnd = i * T * Fs;
        dem(i) =  sum(rbb(floor(lowerbnd):floor(upperbnd))) >= 0; %integration
    end
end

function k = ft_awgn(y, snr, Eb)
    snrl = 10.^(snr./10);
    p = Eb / (2 * snrl);
    k = y + sqrt(p) * randn(length(y), 1);
end
