clc;
clear;

[audio, Fs] = audioread('eric.wav');
s = length(audio)/Fs; 
t = linspace(0, s, s*Fs+1);
Fs1 = linspace(-Fs/2, Fs/2, s*Fs+1);

d = designfilt('lowpassfir', 'FilterOrder', 8000, 'CutoffFrequency', 4000, 'SampleRate', Fs);
filteredSig = filter(d, audio); % Low pass filter
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

mse = immse(filteredSig, audio); % Mean-Square Error

Fc = 100e3;
message = resample(filteredSig, 5 * Fc, Fs); % Upsampling signal to 5 * Fc
Fs = 5*Fc;
s = length(message)/Fs;
t = linspace(0, s, s*Fs);
Fs1 = linspace(-Fs/2, Fs/2, s*Fs);

audiowrite('message.wav', message, Fs);

% DSB-SC

modulatedSCSig = dsbSCMod(message, Fc, t); % DSC-SC Modulation

figure; 
subplot(2,1,1);
plot(t, modulatedSCSig);
title('DSB-SC Time Domain')
subplot(2,1,2); 
plot(Fs1, real(fftshift(fft(modulatedSCSig))));
title('DSB-SC Frequency Domain')

% DSB-TC

modulatedTCSig = dsbTCMod(message, Fc, t); % DSC-TC Modulation

figure;
subplot(2, 1, 1);
plot(t, modulatedTCSig);
title('DSB-TC Time Domain');
subplot(2, 1, 2);
plot(Fs1, real(fftshift(fft(modulatedTCSig))));
title('DSB-TC Frequency Domain');

% Envelope Detection

envelopeTC = abs(hilbert(modulatedTCSig)); % DSB-TC envelope detection
audiowrite('envelopeTC.wav', envelopeTC, Fs);

envelopeSC = abs(hilbert(modulatedSCSig)); % DSB-SC envelope detection
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

envelopeTC10SNR = awgn(envelopeTC, 10);

figure;
subplot(2, 1, 1);
plot(t, envelopeTC10SNR);
title('Transmitted Carrier Envelope 10 SNR');
subplot(2, 1, 2);
plot(Fs1, real(fftshift(fft(envelopeTC10SNR))));
title('Transmitted Carrier Envelope Spectrum 10 SNR');

envelopeTC30SNR = awgn(envelopeTC, 10);

figure;
subplot(2, 1, 1);
plot(t, envelopeTC30SNR);
title('Transmitted Carrier Envelope 30 SNR');
subplot(2, 1, 2);
plot(Fs1, real(fftshift(fft(envelopeTC30SNR))));
title('Transmitted Carrier Envelope Spectrum 30 SNR');

% Coherent Detection

coherentSC = coherentDetector(modulatedSCSig, Fc, t); % DSB-SC coherent det
audiowrite('coherentSC.wav', coherentSC, Fs);
coherentTC = coherentDetector(modulatedTCSig, Fc, t); % DSB-TC coherent det
audiowrite('coherentSC.wav', coherentTC, Fs);

figure;
subplot(2, 1, 1);
plot(t, coherentTC);
title('Transmitted Carrier Coherent')
subplot(2, 1, 2);
plot(Fs1, real(fftshift(fft(coherentTC))));
title('Transmitted Carrier Coherent Spectrum');

figure;
subplot(2, 1, 1);
plot(t, coherentSC);
title('Suppressed Carrier Coherent')
subplot(2, 1, 2);
plot(Fs1, real(fftshift(fft(coherentSC))));
title('Suppressed Carrier Coherent Spectrum');

coherentSC10SNR = awgn(coherentSC, 10);

figure;
subplot(2, 1, 1);
plot(t, coherentSC10SNR);
title('Suppressed Carrier Coherent 10 SNR')
subplot(2, 1, 2);
plot(Fs1, real(fftshift(fft(coherentSC10SNR))));
title('Suppressed Carrier Coherent Spectrum 10 SNR');


coherentSC30SNR = awgn(coherentSC, 30);

figure;
subplot(2, 1, 1);
plot(t, coherentSC30SNR);
title('Suppressed Carrier Coherent 30 SNR')
subplot(2, 1, 2);
plot(Fs1, real(fftshift(fft(coherentSC30SNR))));
title('Suppressed Carrier Coherent Spectrum 30 SNR');

corruptedSC = coherentDetector(modulatedSCSig, 100.1e3, t); % DSB-SC coherent det

figure;
subplot(2, 1, 1);
plot(t, corruptedSC);
title('Suppressed Carrier Coherent 100.1KHz')
subplot(2, 1, 2);
plot(Fs1, real(fftshift(fft(corruptedSC))));
title('Suppressed Carrier Coherent Spectrum 100.1KHz');





