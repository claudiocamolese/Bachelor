clc
clear all
close all

%% parameters
fs=100; 
Ts=1/fs;
T = 30;
t = 0:Ts:T-Ts;
first_sample = 10*fs;
final_sample = T*fs + first_sample - 1;
N= T/Ts;
fres = fs/N;
f=-fs/2:fres:fs/2-fres; 

%% TASK 1  import datas 
filename = 'pulse.txt';
delimiterIn = ' ';
headerlinesIn = 1;
Data_struct = importdata(filename,delimiterIn,headerlinesIn);
Led_R = Data_struct.data(first_sample:final_sample, 1);
Led_IR = Data_struct.data(first_sample:final_sample,2);

%Since findpeaks need a vector 1xn as argument, we need to do the transpose of the signals
Led_R = Led_R';
Led_IR=Led_IR';

%Fourier 
S_Led_R = fft(Led_R)*Ts;
S_Led_IR = fft(Led_IR)*Ts;

%% TASK2 Low pass filter - muscolar movement 
low_pass_filter= rectangular(f,3);

% cleaning the input signals
S_Led_R_clean = fftshift(low_pass_filter).*S_Led_R;
S_Led_IR_clean=fftshift(low_pass_filter).*S_Led_IR;
Led_R_clean= ifft(S_Led_R_clean).*fs;
Led_IR_clean= ifft(S_Led_IR_clean).*fs;

%% TASK3 plot 
%to have more zoomed images we definire
max_R = max(Led_R);
min_R =min(Led_R);
max_IR = max(Led_IR);
min_IR = min(Led_IR);

figure
hold on
box on

% ORIGINAL RED SIGNAL
subplot(2,2,1)
plot(t,Led_R,"r");
axis ([0 T min_R max_R])
title('Original Red Signal');
xlabel('Time [s]',LineWidth=1.5)

% CLEANED RED SIGNAL
subplot(2,2,2)
plot(t,Led_R_clean,"r");
axis ([0 T min_R max_R])
title('Red Signal after low pass');
xlabel('Time [s]',LineWidth=1.5)

% ORIGINAL INFRARED SIGNAL
subplot(2,2,3)
plot(t,Led_IR,"b");
axis ([0 T min_IR max_IR])
title('Original Infrared Signal');
xlabel('Time [s]',LineWidth=1.5)

% CLEANED INFRARED SIGNAL
subplot(2,2,4)
plot(t,Led_IR_clean,"b");
axis ([0 T min_IR max_IR])
title('Infrared Signal after low pass');
xlabel('Time [s]',LineWidth=1.5)

%% Saturation TASK4

%Peaks

%RED SIGNAL

[pks1,locs1]=findpeaks(Led_R_clean,t);
[pks2,locs2]=findpeaks(-Led_R_clean,t);
pks2=-pks2;
HH1=interp1(locs1,pks1,t,'spline');
HH2=interp1(locs2,pks2,t,'spline');

%INFRARED SIGNAL
[pks3,locs3]=findpeaks(Led_IR_clean,t);
[pks4,locs4]=findpeaks(-Led_IR_clean,t);
pks4=-pks4;
HH3=interp1(locs3,pks3,t,'spline');
HH4=interp1(locs4,pks4,t,'spline');


%Iac is the variations between the max and the min values (HH(n)-HH(n+1)),
%while Idc is the value of the min value. So we convert given formula in:
%then we take the mean value in order to have a global extimation
R_average = mean(((HH1-HH2)./HH2)./((HH3-HH4)./HH4));
saturation =110 - 25 * R_average;

% PLOT INTERPOLATED CURVES  
figure

subplot (2,1,1)
hold on
plot(t,Led_R_clean,"black");
plot(t,HH1,'r')
plot(t,HH2,'r')
title('RED');


subplot (2,1,2)
plot(t,Led_IR_clean,"black");
hold on
plot(t,HH3,'r')
plot(t,HH4,'r')
title(['INFRARED SPO_{2} = ', num2str(saturation), '%']);
grid on
xlabel('f(Hz)')

%% TASK5 High_pass filtering - breathe movements
breathe=0.5;
high_pass_filter= 1-rectangular(f,breathe); %instead of creating a new function, we can use the low-pass filter

%cleaning the signals from breathe movements
%we compute as we did before but, this time, with high pass filter
S_Led_R = fft(Led_R_clean)*Ts;
S_Led_R_clean = fftshift(high_pass_filter).*S_Led_R;
Led_R_clean= ifft(S_Led_R_clean).*fs;


%% TASK6 Average pulse rate 
[pks5,locs5]=findpeaks(Led_R_clean,t);
BPM= 60/(mean(diff(locs5)));  
% plot - BPM
figure
hold on
findpeaks(Led_R_clean,t)
plot(t,Led_R_clean,"b")
title(['filtered red signal - BPM = ', num2str(BPM,4)]);
xlabel('Time [s]')
xlim([0 30])

%% TASK7 Alternative pulse rate computation
index_min = find(f == 1);
index_max = find(f == 1.5);
frequency_segment = f(index_min : index_max);

magnitude = abs(fftshift(S_Led_R_clean));

max_peak = max(magnitude(index_min : index_max));
index_peak = find(magnitude(index_min : index_max) == max_peak);
BPM2 = 60 * frequency_segment(index_peak);


% PLOT FILTERED RED SIGNAL IN FREQUENCY

figure
plot(f*60, magnitude);
title(['filtered signal - frequency axis - BPM = ' , num2str(BPM2,4)] );
grid on
xlim([60 90])

%% Spectrogram
% Pad the LedR signal with zeros
LedR = [Led_R_clean zeros(1, 4 *N)];

% Define the spectrogram parameters
nfft = N / 2;
n_overlap = nfft - 1;
window = ones(1, nfft);

% Compute the spectrogram
[S2,f2,t2] = spectrogram(LedR, window, n_overlap, nfft, fs, 'centered', 'yaxis');

% Create the figure and plot the spectrogram
figure;
imagesc(t2,60 * (f2 - fres), abs(S2) * Ts); 
axis xy;
ylim([60 80]);
xlim([7.5 30]);

% Add colorbar and labels
h = colorbar;
xlabel('Time [s]');
ylabel('frequency [Hz]');
ylabel(h, 'abs(S)');
title('Spectrogram');