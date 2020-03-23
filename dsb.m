clc;
clear;

[audio, Fs] = audioread('eric.wav');
s = length(audio)/Fs;
t = linspace(0, s, s*Fs+1);
Fs1 = linspace(-Fs/2, Fs/2, s*Fs+1);

d = designfilt('lowpassfir', 'Filterorder', 8000, 'CutoffFrequency', 4000, 'SampleRate', Fs);
%filteredSig = filtfilt(d, audio);
filteredSig = filter(d, audio);
Y = fft(filteredSig);
%sound(filteredSig, Fs);

figure;subplot(2, 1, 1)
plot(t, audio);
title('Before Filter')
subplot(2, 1, 2);
plot(t, filteredSig);
title('After Filter');

figure;subplot(2, 1, 1)
plot(Fs1, real(fftshift(fft(audio))));
title('Before Filter')
subplot(2, 1, 2);
plot(Fs1, real(fftshift(Y)));
title('After Filter');

%audiowrite('filteredSig.wav', real(ifft(filteredSig)), Fs);
%filteredSig = real(ifft(filteredSig));

%mse = sqrt(filteredSig - audio);

Fc = 100e3;
message = resample(filteredSig, 5 * Fc, Fs);
Fs = 5*Fc;
s = length(message)/Fs;
t = linspace(0, s, s*Fs);
Fs1 = linspace(-Fs/2, Fs/2, s*Fs);
C = cos(2*pi*Fc*t);
A = 515*2;

%DSB-SC
ModuledSig = message.*transpose(C);
figure; subplot(2,1,1);
plot(t, ModuledSig);
K = real(fftshift(fft(ModuledSig)));
subplot(2,1,2); plot(Fs1, K);