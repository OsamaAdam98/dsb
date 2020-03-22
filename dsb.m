clc;
clear;

[audio, Fs] = audioread('eric.wav');
s = length(audio)/Fs;
t = linspace(0, s, s*Fs+1);
Fs1 = linspace(-Fs, Fs, s*Fs+1);

%Y = fft(audio);
%filteredSig = Y;
%filteredSig(4001: end - 4001) = 0;

d = designfilt('lowpassfir', 'Filterorder', 8000, 'CutoffFrequency', 2000, 'SampleRate', Fs);
filteredSig = filter(d,audio);
Y = fft(filteredSig);
% sound(filteredSig, Fs);

figure;
subplot(2, 1, 1)
plot(t, audio);
title('Before Filter')
subplot(2, 1, 2);
plot(t, filteredSig);
title('After Filter');

figure;
subplot(2, 1, 1)
plot(Fs1, real(fftshift(fft(audio))));
title('Before Filter')
subplot(2, 1, 2);
plot(Fs1, real(fftshift(Y)));
title('After Filter');

% audiowrite('filteredSig.wav', real(ifft(filteredSig)), Fs);
filteredSig = ifft(filteredSig);

% mse = sqrt(filteredSig - audio);

Fc = 20e3;

message = filteredSig;

suppressedCarrier = modulate(fft(message), Fc, Fs, 'am');
transCarrier = modulate(fft(message), Fc, Fs, 'amdsb-tc');

figure;
subplot(2, 1, 1);
plot(Fs1, real(fftshift(fft(suppressedCarrier))));
title('DSB-SC');
subplot(2, 1, 2);
plot(Fs1, real(fftshift(fft(transCarrier))));
title('DSB-TC');
xlimit(-1, 1);


