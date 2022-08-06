data = [1 0 0 1 1 0 1].' %input binary data

Fc = 50000 %Carrier frequency
Eb = 1 %Energy of the signal
T = 1/Fc %Period of the signal

Fs = Fc*50; %Sampling frequency
dt = 1/Fs; 
StopTime = length(data) * T; 
t = (0:dt:StopTime-dt)';

for i = 1:length(data)
    if data(i) == 0
        data(i) = -1;
    end
end

y = modulation(data, Fc, t, Eb);

figure;
plot(t, y, 'LineWidth', 3);
zoom xon;

function y = modulation(data, Fc, t, Eb)
    T = 1/Fc;
    s = data(fix(t / T) + 1) * sqrt(Eb); %s is the representation of the input data under time domain
    p = cos(2*pi*Fc*t) * sqrt(2/T); %basis function
    y = times(s,p);
end