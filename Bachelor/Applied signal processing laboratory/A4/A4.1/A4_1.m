clear all
close all
clc

%% parameters
A1=1;
f1=1;
A2=2;
f2=4;
fs=100; 
Ts=1/fs;
T = 100;
t = 0:Ts:T-Ts;
N= T/Ts;
fres = fs/N;
f=-fs/2:fres:fs/2-fres; 

%% signals
phi1 = rand * 2*pi; %random phase A
phi2 = rand * 2*pi; %random phase B
s1=A1*cos(2*pi*f1*t+phi1);
s2=A2*cos(2*pi*f2*t + phi2);
s=s1+s2;

%% Fourier s
S = fft(s);         
M = abs(S*Ts);      
MM = fftshift(M);

%% plot
figure

subplot(2,1,1)
plot(t,s)
title("s(t)")
xlabel("time",LineWidth=1.5)
ylim([-3 3])

subplot(2,1,2)
plot(f,MM)
title("abs(S(f))")
xlabel("f")
ylim([0 100])

%% s' 
P= rectangular(t,T/2);
s_first=P.*s1 + (1-P).*s2;

%% Fourier s'
S_first = fft(s_first);         
M_first = abs(S_first*Ts);      
MM_first = fftshift(M_first);

%% Plot
figure

subplot(2,1,1)
plot(t,s_first)     
title("s'(t)")
xlabel("time")
subplot(2,1,2)
plot(f,MM_first);
title("abs(S'(f))")
xlabel("f")

figure 
plot(f,MM_first)
hold on
plot(f,MM)
title("abs(S(f)) comparison")
xlabel("f")
legend("spettro s'","spettro s")

%% spectrogram of s and s_first
N_FFT=N/2;
N_overlap=0;
window=ones(1,N_FFT);
[S2,f2,t2]=spectrogram(s,window,N_overlap,N_FFT,fs,"centered","yaxis");
[S3,f3,t3]=spectrogram(s_first,window,N_overlap,N_FFT,fs,"centered","yaxis");

%% plot spectrograms
figure  
imagesc(t2,f2,abs(S2)*Ts)
h = colorbar;
axis xy;
ylim ([0 10]);
title("Spectrogram")
xlabel("time [s]")
ylabel("frequency [Hz]")
ylabel (h,"abs(S)")

figure
imagesc(t3,f3,abs(S3)*Ts)
h = colorbar;
axis xy;
ylim ([0 10]);
title("Spectrogram")
xlabel("time [s]")
ylabel("frequency [Hz]")
ylabel (h,"abs(S)")

