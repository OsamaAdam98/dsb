clc;
clear;

[audio, Fs] = audioread('eric.wav');
s = length(audio)/Fs;
t = linspace(0, s, s*Fs+1);
Fs1 = linspace(-Fs/2, Fs/2, s*Fs+1);

d = designfilt('lowpassfir', 'FilterOrder', 8000, 'CutoffFrequency', 4000, 'SampleRate', Fs);
filteredSig = filter(d, audio);
Y = fft(filteredSig);

audiowrite('filteredSig.wav', filteredSig, Fs);

figure;subplot(2, 1, 1)
plot(t, audio);
title('Before Filter')
subplot(2, 1, 2);
plot(t, filteredSig);
title('After Filter');

figure;
subplot(2, 1, 1);
plot(Fs1, real(fftshift(fft(audio))));
title('Before Filter');
subplot(2, 1, 2);
plot(Fs1, real(fftshift(Y)));
title('After Filter');

% filteredSig = real(ifft(filteredSig));

mse = immse(filteredSig, audio);

Fc = 100e3;
message = resample(filteredSig, 5 * Fc, Fs);
Fs = 5*Fc;
s = length(message)/Fs;
t = linspace(0, s, s*Fs);
Fs1 = linspace(-Fs/2, Fs/2, s*Fs);

audiowrite('message.wav', message, Fs);

% DSB-SC

modulatedSCSig = dsbSCMod(message, Fc, t);

figure; 
subplot(2,1,1);
plot(t, modulatedSCSig);
title('DSB-SC Time Domain')
subplot(2,1,2); 
plot(Fs1, real(fftshift(fft(modulatedSCSig))));
title('DSB-SC Frequency Domain')

% DSB-TC

modulatedTCSig = dsbTCMod(message, Fc, t);

figure;
subplot(2, 1, 1);
plot(t, modulatedTCSig);
title('DSB-TC Time Domain');
subplot(2, 1, 2);
plot(Fs1, real(fftshift(fft(modulatedTCSig))));
title('DSB-TC Frequency Domain');

envelopeTC = abs(hilbert(modulatedTCSig));
audiowrite('envelopeTC.wav', envelopeTC, Fs);
envelopeSC = abs(hilbert(modulatedSCSig));
audiowrite('envelopeSC.wav', envelopeSC, Fs);

figure;
subplot(2, 1, 1);
plot(t, envelopeTC);
title('Transmitted Carrier Envelope');
subplot(2, 1, 2);
plot(Fs1, real(fftshift(fft(envelopeTC))));
title('Transmitted Carrier Envelope Spectrum');

figure;
subplot(2, 1, 1);
plot(t, envelopeSC);
title('Suppressed Carrier Envelope');
subplot(2, 1, 2);
plot(Fs1, real(fftshift(fft(envelopeSC))));
title('Suppressed Carrier Envelope Spectrum');

coherentSC = coherentDetector(modulatedSCSig, Fs, t);
audiowrite('coherentSC.wav', coherentSC, Fs);

figure;
plot(Fs1, real(fftshift(fft(coherentSC))));





