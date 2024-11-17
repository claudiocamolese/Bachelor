close all
clear all
clc

%% parameters
fs=100;
Ts=1/fs;
T=1;
num_sim= 1e5;
%% time axis
t=0:Ts:T-Ts;
N=length(t); %number of samples

%% signal
A=sqrt(2);
f1=1;
s=A*sin(2*pi*f1*t);
energy_time_axis= sum(s.^2)*Ts;  % mdp rule time axis
p_s = (A^2/2); %signal power 

%% noise
SNR_dB=5; %DB
SNR= 10^(SNR_dB/10); %converts
p_n= p_s/SNR; %noise power
n= sqrt(p_n)*randn(1,N); %noise
r=n+s; %signal plus noise

%% plot
figure
box on
hold on
title(['r(t)=s(t)+n(t)   ', 'SNR=', num2str(SNR_dB)]);
plot(t,r)
plot(t,s)
xlabel('time',LineWidth=1.5)
ylabel('r',LineWidth=1.5)
axis([0 1 -8 8]);

%% correlation
vector= 1:num_sim;
for i=vector
    n= sqrt(p_n)*randn(1,N); %noise
    r=s+n; %create total signal
    %compute the energy in order to normalize
    E_n= sum(n.^2)*Ts; %energy of the noise
    E_r= sum(r.^2)*Ts; %energy of the total signal
    norm_n= n/sqrt(E_n); %normalized to have unitary energy
    norm_r= r/sqrt(E_r);%normalized to have unitary energy
    Gamma_H0(i)= abs(sum(norm_n.*s)*Ts); %compute gammma_H0
    Gamma_H1(i)= abs(sum(norm_r.*s)*Ts); %compute gamma
end

%% plot correlation
figure
box on
hold on
title({'Correlation: simulations outcomes' , ['SNR = ',num2str(SNR_dB),' dB']});
xlabel("number of simulation")
ylabel("\Gamma")
plot(vector, Gamma_H0, "Color","r")
plot(vector, Gamma_H1, "Color","b")

axis([0 num_sim 0 1])
legend("H0", "H1")

%% plot histogram
figure
hold on
box on
histogram(Gamma_H0, "Normalization","probability","FaceColor","r")
histogram(Gamma_H1, "Normalization","probability","FaceColor","b")
legend("H0", "H1")
title({'Correlation:pdf of \Gamma under H_{0} and H_{1}' , ['SNR = ',num2str(SNR_dB),' dB']});
%axis([0 0.65 0 0.045])

%% probability
tmin=min(Gamma_H0);
tmax=max(Gamma_H1);
N_bins=100;
t=linspace(tmax,tmin,N_bins);

for i= 1:N_bins
    if(length(find(Gamma_H0>=t(i)))<30)
        P_fa(i) = 0;
    else
        P_fa(i) = length(find(Gamma_H0 >= t(i)))/num_sim;
    end

%missed detection probability : Pmd = Pr (Γ < t| H1)
    if (length(find(Gamma_H1<t(i)))<30)
        P_md(i) = 0;
    else
        P_md(i)  = length(find(Gamma_H1 < t(i)))/num_sim;
    end
end

figure;
semilogy(t,P_fa,"r");
hold on
semilogy(t, P_md,"b");
xlabel('threshold t');
ylabel('P_{fa}, P_{md}');
title({"Correlation:P{fa} and P_{md} vs. threshold" , ['SNR = ',num2str(SNR_dB),' dB']});
legend("P_{fa}","P_{md}")
grid on;

%% ROC
Pd=(1-P_md);
figure
semilogx(P_fa,Pd, "g", "LineWidth",2);
xlabel("P_{fa}")
ylabel("P_d")
title({"ROC curve" , ['SNR = ',num2str(SNR_dB),' dB']});
legend("correlation ROC")
grid on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Repeat Exercise with Energy Test

%% parameters
fs = 100;
Ts = 1/fs;
T = 1;
num_sim = 1e5;

%% time axis
t = 0:Ts:T-Ts;
N = length(t); % number of samples

%% signal
A = sqrt(2);
f1 = 1;
s = A * sin(2*pi*f1*t);
energy_time_axis = sum(s.^2)*Ts;  % energy over the time axis

%% noise
SNR_dB = -10; % dB
SNR = 10^(SNR_dB/10); % convert to linear scale
p_s = (A^2)/2; % signal power
p_n = p_s / SNR; % noise power
n = sqrt(p_n) * randn(1, N); % noise
r = n + s; % signal plus noise

%% plot
figure
box on
hold on
title(['r(t) = s(t) + n(t)', ', SNR = ', num2str(SNR_dB), ' dB']);
plot(t, r)
plot(t, s)
xlabel('time', 'LineWidth', 1.5)
ylabel('r', 'LineWidth', 1.5)
axis([0 1 -8 8]);

%% energy test
vector = 1:num_sim;
for i = vector
    n = sqrt(p_n) * randn(1, N); % noise
    r = s + n; % create total signal
    E_n = sum(n.^2) * Ts; % energy of the noise
    E_r = sum(r.^2) * Ts; % energy of the total signal
    Energy_H0(i) = E_n; % energy under H0
    Energy_H1(i) = E_r; % energy under H1
end

%% plot energy values
figure
box on
hold on
title({'Energy Test: Simulation Outcomes', ['SNR = ', num2str(SNR_dB), ' dB']});
xlabel("number of simulation")
ylabel("Energy")
plot(vector, Energy_H0, "Color", "r")
plot(vector, Energy_H1, "Color", "b")
axis([0 num_sim 0 max(max(Energy_H0), max(Energy_H1))])
legend("H0", "H1")

%% plot histograms
figure
hold on
box on
histogram(Energy_H0, "Normalization", "probability", "FaceColor", "r")
histogram(Energy_H1, "Normalization", "probability", "FaceColor", "b")
legend("H0", "H1")
title({'Energy Test: PDF of Energy under H_{0} and H_{1}', ['SNR = ', num2str(SNR_dB), ' dB']});

%% probability
tmin = min(Energy_H0);
tmax = max(Energy_H1);
N_bins = 100;
t = linspace(tmax, tmin, N_bins);

for i = 1:N_bins
    if (length(find(Energy_H0 >= t(i))) < 30)
        P_fa(i) = 0;
    else
        P_fa(i) = length(find(Energy_H0 >= t(i))) / num_sim;
    end
    
    if (length(find(Energy_H1 < t(i))) < 30)
        P_md(i) = 0;
    else
        P_md(i) = length(find(Energy_H1 < t(i))) / num_sim;
    end
end

%% plot probabilities
figure;
semilogy(t, P_fa, "r");
hold on
semilogy(t, P_md, "b");
xlabel('threshold t');
ylabel('P{fa}, P_{md}');
title({"Energy Test: P{fa} and P_{md} vs. Threshold", ['SNR = ', num2str(SNR_dB), ' dB']});
legend("P_{md}", "P_{fa}")
grid on;

%% ROC
Pd = (1 - P_md);
figure
semilogx(P_fa, Pd, "g", "LineWidth", 2);
xlabel("P_{fa}")
ylabel("P_d")
title({"Energy Test: ROC Curve", ['SNR = ', num2str(SNR_dB), ' dB']});
legend("Energy ROC")
grid on
