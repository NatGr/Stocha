% function which plots the fft of a sound, based on code coming from https://nl.mathworks.com/help/matlab/ref/fft.html
function [] = fftPlot(file)
[sound, fs] = audioread(file);
duration = length(sound);
Y = fft(sound);

P2 = abs(Y/duration);
P1 = P2(1:duration/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = fs*(0:(duration/2))/duration;
plot(f,P1) 
axis([0 8000 0 inf])
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')
end