%% Clean workspace
clearvars        % Deletes all the variables in the current workspace
close all force  % Closes all the MATLAB windows except for the IDE     
clc              % Clean the Command Window (but not the hystory)

%% Define simulation parameters for rectangular pulse
A = 2; % rect. pulse amplitude
T = 1; % rect. pulse duration [sec]
Tmin = 0; % Lower limit of observation time-window [sec]
Tmax = 10*T; % Upper limit of observation time-window [sec]
fs=1e4;  % sampling frequency - [samples/second]
Ts=1/fs;  % sampling time (i.e., time resolution) - [seconds]
f0=1/T;

%% create Cartesian time/frequency axes (according to simulation parameters) 
t=Tmin:Ts:Tmax-Ts;  % time axis
N = Tmax*fs; % Total number of samples in time axis
NT = T*fs; % Number of samples of rectangular pulse

fres=fs/N;          % frequency spacing/resolution (depends only on the observation time T_{max})
f=0:fres:fs-fres;   % frequency axis
ff=f-fs/2;          % symmetric frequency axis (fundamental interval)

%% Task 2: design the rectangular pulse with amplitude A and duration T on the defined time axis
s = zeros(1,N);
s(1:NT)=A;

%% Energy
energy_analytically= (A^2)*T; %TRUE
energy_time_axis= sum(s.^2)*Ts;  % mdp rule time axis
% E_tpz_t = (Ts/2)*(s(1)^2+s(end)^2+2*sum(s(2:end-1).^2)) % trapezoidal rule time axis 

%% Fourier
S = fft(s);         % FFT spectrum of the rectangular pulse
M = abs(S*Ts);      % magnitude of the fft spectrum
MM = fftshift(M);   % two-sided amplitude spectrum (even function of frequency) --> show the amplitude spectrum in [-fs/2:fs/2-fres]
energy_freq_axis=sum(abs(M).^2)*fres;

%% Task 3: plot the signal [time-domain]
figure('Name','Signal plot [Time domain] and Double-sided amplitude spectrum [frequency domain]') % creates an empty figure with title
subplot(2,1,1)
plot(t,s,'b','LineWidth',2)  % creates a Cartesian plot using time axis as x-axis and signal values as y-axis 

%% Plot
% Retrieve hanlde of Cartesian axes in current figure
ax = gca;

% Set labels to the current axes
xlabel(ax,'Time [s]')
ylabel(ax,'s(t)')

% Set title to the current axes
title(ax,sprintf('s = Ap_T(t) ; A = %d, T = %d, Epulse = %d, Etime-axis =%d',A,T,energy_analytically,energy_time_axis))

% Display axes grid lines 
grid(ax,"minor")

% Set axes fontsize
ax.FontSize = 16;
 
subplot(2,1,2)
plot(ff,MM,'r','LineWidth',2)

ax = gca;
xlabel(ax,'frequency [Hz]');
ylabel(ax,'|S(f)|');
grid(ax,"minor")
ax.FontSize = 16;
xlim([-20 +20])
title(ax,sprintf('Double-sided amplitude spectrum; Epulse = %d, Efreq-axis =%d',energy_analytically,energy_freq_axis))

%% Lobes
K=100;
samples_lobe=f0/fres;
lobes=(1:K);
energy_lobe= zeros(1,K);
interval=M(1:samples_lobe);
tot= 2 * (sum(abs(interval).^2)*fres) - abs(interval(1)).^2 * fres;
energy_lobe(1) = tot;

for i=1:(K-1)
    interval= M(i*samples_lobe+1 : (i+1) * samples_lobe);
    tot=tot+ 2*sum(abs(interval).^2)*fres;
    energy_lobe(i+1)=tot;
end

%% 10 lobes
figure
grid on
hold on
box on
plot(lobes(1:10), energy_lobe(1:10)/energy_freq_axis, '-o', 'LineWidth', 1.5);
title({['A=', num2str(A), ' T=', num2str(T)]});
xlabel('Number of lobes', 'LineWidth', 1.5)
ylabel('Energy percentage', 'LineWidth', 1.5)

%% 100 lobes
figure
grid on
hold on
box on
plot(lobes,energy_lobe/energy_freq_axis,"LineWidth",1.5);
title({['A=', num2str(A),' T=',num2str(T)]});
xlabel('number of lobes',LineWidth=1.5)
ylabel('Energy percentage',LineWidth=1.5)
axis([10 K energy_lobe(10)/energy_freq_axis 1]) %for zooming the plot