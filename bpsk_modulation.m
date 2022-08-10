clc;
clear all;
close all;

data = [1 0 0 1 1 0 1 1 1 0]; %input binary data

data = data.';

Fc = 10000; %Carrier frequency
Eb = 1; %Energy of the signal
T = 1/Fc; %Period of the signal

Fs = Fc*100; %Sampling frequency
dt = 1/Fs; 
StopTime = length(data) * T; 
t = (0:dt:StopTime-dt)';

s = square_wave(data, Eb, T, t); %generating square wave from input data

y = modulation(s, Fc, t);
r = ft_awgn(y, 0, 10*log10(Eb/T));
%r = ft_awgn(y, 0, Eb);
output = demodulation(r, Fc, t);

m = square_wave(output, Eb, T, t);

figure;
%plotting input data as square waveform
subplot(4,1,1);
plot(t, s, 'LineWidth', 2);
title('Input');
xlabel('Time(seconds)');
ylabel('Amplitude');

%plotting modulated signal
subplot(4,1,2);
plot(t, y, 'LineWidth', 2);
title('Modulated signal');
xlabel('Time(seconds)');
ylabel('Amplitude');

%plotting received signal (signal with gaussian noise)
subplot(4,1,3);
plot(t, r, 'LineWidth', 1);
title('Received signal (signal with gaussian noise)');
xlabel('Time(seconds)');
ylabel('Amplitude');

%plotting input data as square waveform
subplot(4,1,4);
plot(t, m, 'LineWidth', 2);
title('Output');
xlabel('Time(seconds)');
ylabel('Amplitude');

zoom xon;

%representing binary data sequence as square waveform
function s = square_wave(data, Eb, T, t)
    for i = 1:length(data) 
        if data(i) == 0
            data(i) = -1;
        end
    end
    s = data(fix(t / T) + 1) .* sqrt(Eb); %square wave representation of input data
end

function y = modulation(s, Fc, t)
    T = 1/Fc;
    p = cos(2*pi*Fc*t) .* sqrt(2/T); %basis function
    y = s.*p;
end

function dem = demodulation(r, Fc, t) 
    T = 1/Fc;
    Fs = Fc*100;
    dem = zeros(1, length(r)/(T*Fs));
    p = cos(2*pi*Fc*t) .* sqrt(2/T); %basis function
    rbb = r.*p;
    for i=1:length(rbb)/(T*Fs)
        lowerbnd = (i - 1)* T * Fs + 1;
        upperbnd = i * T * Fs;
        dem(i) =  sum(rbb(floor(lowerbnd):floor(upperbnd))) >= 0; %integration over period
    end
end

function k = ft_awgn(y, snr, pwr) %implementation of additive white gaussian noise channel
    pnoise = pwr - snr;
    p = power(10, pnoise / 10);
    k = y + sqrt(p) .* randn(length(y), 1); %creating gaussian noise and adding it to the signal
end
