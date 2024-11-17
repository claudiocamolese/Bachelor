clc
clear all 
close all


%% import audio file 
[s,fs] = audioread("audio.wav");
%to play the audio 
% playObj = audioplayer(s,fs);
% playblocking(playObj);
%% FFT of the signal
Ts= 1/fs;
N = length(s);
T = 10;
fres = fs/N;
t = 0:Ts:T-Ts;
f=-fs/2:fres:fs/2-fres; 

S=fft(s)*Ts;

%% spectrogram  1
Nfft =  2^14;
N_overlap = 8000;
window = hamming (10000);

[S1,f1,t1] = spectrogram (s, window, N_overlap, Nfft, fs, 'centered', 'yaxis');

%% spectogram shifted
s2 = shiftPitch (s, 3);
[S2,f2,t2] = spectrogram (s2, window, N_overlap, Nfft, fs, 'centered', 'yaxis');

%% plots
% sgnal in the time domain
figure
hold on
box on 
grid on
plot(t,s);
title('A major scale');
xlabel('t [s]');
ylabel('amplitude');

% analysis of the magnitude (focus on the range up to 800 Hz)
figure
hold on
box on 
grid on
plot(f,abs(fftshift(S)));
title('abs(S)');
xlabel('ff');
xlim ([-800 , 800])

% spectrogram of the original audio
figure 
hold on 

imagesc (t1,f1,abs(S1) * Ts);
h = colorbar;
axis xy;
title("Spectrogram")
xlabel('time [s]')
ylabel('frequency [Hz]' )
ylabel (h, 'abs(S)')
ylim ([0 800])
xlim([0 9])


% spectrogram of the shifted signal
figure 
hold on 

imagesc (t2,f2,abs(S2) * Ts);
h = colorbar;
axis xy;
title("Spectrogram: signal after shiftPitch ")

xlabel('t(s)')
ylabel('f (Hz)' )
ylabel (h, 'abs(S)')
ylim ([0 800])
xlim([0 9])
