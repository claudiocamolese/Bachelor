clc
clear all
close all

%% parameters
Tmin=0;      % Lower limit of observation time-window [sec]
Tmax = 100;  % Upper limit of observation time-window [sec]
fsam = 100;  % Sampling frequency
fA = 1;      % Frequency of signal A
fB = 2;      % Frequency of signal B
fC = 3;      % Frequency of signal C
Ts=1/fsam;   % sampling time (i.e., time resolution) - [seconds]
N=Tmax*fsam; % Block size (total number of samples)

%% Random phases
% Generate random phases
phiA = rand * 2*pi; %random phase A
phiB = rand * 2*pi; %random phase B
phiC = rand * 2*pi; %random phase C

%% Time axis
t = Tmin:Ts:Tmax-Ts; % time axis

%% Generate the signal x(t)
xA = sin(2*pi*fA*t + phiA); % sinusoidal signal A
xB = sin(2*pi*fB*t + phiB); % sinusoidal signal B
xC = sin(2*pi*fC*t + phiC); % sinusoidal signal C
x = xA + xB + xC;           % sum of the signals

%% Plot x(t) on the time axis
figure
plot(t, x); % creates a Cartesian plot using time axis as x-axis and signal values as y-axis 
xlabel('Time (s)');
ylabel('x(t)');
title('Plot of x(t)');
xlim([0, 10]);  % Limit the plot to the first 10 seconds
grid on
%% Compute the Fourier transform of x(t)
X = fft(x)*Ts; % FFT spectrum of the rectangular pulse

%% Frequency axis
N = length(x);
f = linspace(-fsam/2, fsam/2, N); % frequency axis

%% Plot |X(f)| on the frequency axis (for -10 ≤ f < +10)
figure;

plot(f,abs(fftshift(X)),'LineWidth',2);
xlabel('Frequency in (Hz)');
ylabel('|X(f)|');
title('Magnitude Spectrum of x(t)');
xlim([-10 10]);
grid on 

%%  DESIGN FILTERS
% low pass filter Ha(f)
figure;
HA=zeros(size(f));
f_plot = f;
inda =f_plot>-1.2 & f_plot<1.2; 
HA(inda) = 1;
subplot (3,1,1)
plot(f_plot, HA)
xlabel('frequency f') 
ylabel('|H_{A}(f)|') 
title('Frequency Response of Low-Pass Filter H_{A}(f)');
ylim([-1,2])
xlim([-10,10])
grid on

%% band pass filter HB(f)
% Design a band-pass filter Hb(f) to isolate the sinusoidal signal sB with frequency fB
Hb = zeros(size(f));

for i= 1:length(f)
    if f(i)>=-fB-0.5 && f(i)<=fB+0.5
        Hb(i)=1;
    else
        Hb(i)=0;
    end
end

HB = Hb-HA;
% indb = (f > -fB-0.5) & (f < fB+0.5);
% HB(indb) = 1;

% Plot the frequency response of the band-pass filter
subplot(3,1,2)
plot(f, HB);
xlabel('Frequency (Hz)');
ylabel('|H_{B}(f)|');
title('Frequency Response of Band-Pass Filter H_{B}(f)');
ylim([-0.1, 1.1]);
xlim([-10 10]);
grid on;

%% High-pass filter Hc(f) to isolate the sinusoidal signal sC with frequency fC
Hc = ones(size(f));
HC = Hc-Hb;
% indc = f > 3 & f<-3; % Assuming you want to pass frequencies near fC and attenuate others
% HC(indc) = 1;

%% Plot the frequency response of the high-pass filter
subplot(3, 1, 3);
plot(f, HC);
xlabel('Frequency (Hz)');
ylabel('|H_{C}(f)|');
title('Frequency Response of High-pass Filter H_{C}(f)');
ylim([-1, 2]);
xlim([-10 10]);
grid on;

% obtain YA(f)
YA = fftshift(HA).*(X);% two-sided amplitude spectrum
YB = fftshift(HB).*(X);% two-sided amplitude spectrum
YC = fftshift(HC).*(X);% two-sided amplitude spectrum

% Compute the inverse Fourier transform to obtain yA(t)
yA = ifft(YA)*fsam;
yB = ifft(YB)*fsam;
yC = ifft(YC)*fsam;

%% Plots of the signal A
figure 
hold on 
box on 
grid on

subplot (2,3,2) % Plot of x(t) signal spectrum |X(f)|
xlabel('f(Hz)',LineWidth=1.5)
ylabel('|X(f)|',LineWidth=1.5)
plot(f,fftshift(abs(X)),"Linewidth",1,"Color","r");
title('Spectrum of x(t)')
xlim([-5 5])
ylim([0 60])
grid on

subplot (2,3,4) %Plot of Low Pass Filter |H_{A}|
plot(f,HA,"LineWidth",1,"Color","r");
title('Low Pass Filter')
xlabel('f(Hz)',LineWidth=1.5)
ylabel('|H_{A}| (f)',LineWidth=1.5)
xlim([-5 5])
ylim([-1 2])
grid on

subplot (2,3,5) %Plot of |Y_{A}|
plot(f,abs(fftshift(YA)),"LineWidth",1,"Color","r");
title('Filtered Spectrum')
xlabel('f(Hz)',LineWidth=1.5)
ylabel('|Y_{A}| (f)',LineWidth=1.5)
xlim([-5 5])
ylim([0 60])
grid on

subplot (2,3,3) %Plot of the original signal
plot(t,x,"LineWidth",1);
title('original signal')
xlabel('t(s)',LineWidth=1.5)
ylabel('x(t)',LineWidth=1.5)
xlim([0 2.5]);
ylim([-2.5 2.5]);
grid on

subplot (2,3,6) % Plot of the filtered signal
plot(t,yA,"LineWidth",1);
title('filtered signal')
xlabel('t(s)',LineWidth=1.5)
ylabel('y_{A}(t)',LineWidth=1.5)
xlim([0 10]);
ylim([-1 1]);
grid on


%% Plots of the signal B
figure 
hold on 
box on 
grid on

% Plot of x(t) signal spectrum |X(f)|
subplot (2,3,2)
xlabel('f(Hz)',LineWidth=1.5)
ylabel('|X(f)|',LineWidth=1.5)
plot(f,fftshift(abs(X)),"Linewidth",1,"Color","r");
title('Spectrum of x(t)')
xlim([-5 5])
ylim([0 60])
grid on

%Plot of the original signal
subplot (2,3,3)
plot(t,x,"LineWidth",1);
title('original signal')
xlabel('t(s)',LineWidth=1.5)
ylabel('x(t)',LineWidth=1.5)
xlim([0 2.5]);
ylim([-2.5 2.5]);
grid on

%Plot of Low Pass Filter |H_{B}|
subplot (2,3,4)
plot(f,HB,"LineWidth",1,"Color","r");
title('Band Pass Filter')
xlabel('f(Hz)',LineWidth=1.5)
ylabel('|H_{B}| (f)',LineWidth=1.5)
xlim([-5 5])
ylim([-1 2])
grid on

%Plot of |Y_{B}|
subplot (2,3,5)
plot(f,abs(fftshift(YB)),"LineWidth",1,"Color","r");
title('Filtered Spectrum')
xlabel('f(Hz)',LineWidth=1.5)
ylabel('|Y_{B}| (f)',LineWidth=1.5)
xlim([-5 5])
ylim([0 60])
grid on

% Plot of the filtered signal
subplot (2,3,6)
plot(t,yB,"LineWidth",1);
title('filtered signal')
xlabel('t(s)',LineWidth=1.5)
ylabel('y_{B}(t)',LineWidth=1.5)
xlim([0 5]);
ylim([-1 1]);
grid on

%% Plots of the signal C
figure 
hold on 
box on 
grid on

% Plot of x(t) signal spectrum |X(f)|
subplot (2,3,2)
xlabel('f(Hz)',LineWidth=1.5)
ylabel('|X(f)|',LineWidth=1.5)
plot(f,fftshift(abs(X)),"Linewidth",1,"Color","r");
title('Spectrum of x(t)')
xlim([-5 5])
ylim([0 60])
grid on

%Plot of the original signal
subplot (2,3,3)
plot(t,x,"LineWidth",1);
title('original signal')
xlabel('t(s)',LineWidth=1.5)
ylabel('x(t)',LineWidth=1.5)
xlim([0 2.5]);
ylim([-2.5 2.5]);
grid on

%Plot of Low Pass Filter |H_{C}|
subplot (2,3,4)
plot(f,HC,"LineWidth",1,"Color","r");
title('High Pass Filter')
xlabel('f(Hz)',LineWidth=1.5)
ylabel('|H_{C}| (f)',LineWidth=1.5)
xlim([-10 10])
ylim([-1 2])
grid on

%Plot of |Y_{C}|
subplot (2,3,5)
plot(f,abs(fftshift(YC)),"LineWidth",1,"Color","r");
title('Filtered Spectrum')
xlabel('f(Hz)',LineWidth=1.5)
ylabel('|Y_{C}| (f)',LineWidth=1.5)
xlim([-5 5])
ylim([0 60])
grid on

% Plot of the filtered signal
subplot (2,3,6)
plot(t,yC,"LineWidth",1);
title('filtered signal')
xlabel('t(s)',LineWidth=1.5)
ylabel('y_{C}(t)',LineWidth=1.5)
xlim([0 5]);
ylim([-1 1]);
grid on

%% Plot the original and filtered signals for comparison(check)
%COMPARISON PLOT FOR A
figure;
plot(t, xA, 'b', t, yA, 'r--');% Plot of original and filtered signal A 
xlabel('Time (s)');
ylabel('Amplitude');
title('Comparison of Original and Filtered Signals for sA(t)');
legend('sA(t)','yA(t)');
xlim([0 5]);
grid on;

%COMPARISON PLOT FOR B
figure;
plot(t, xB, 'b', t, yB, 'r--');
xlabel('Time (s)');
ylabel('Amplitude');
title('Comparison of Original and Filtered Signals for sB(t)');
legend('sB(t)', 'yB(t)');
xlim([0 5]);
grid on;

%COMPARISON PLOT FOR C
figure;
plot(t, xC, 'b', t, yC, 'r--');
xlabel('Time (s)');
ylabel('Amplitude');
title('Comparison of Original and Filtered Signals for sC(t)');
legend('sC(t)', 'yC(t)');
xlim([0 5]);
grid on;