close all
clear all
clc

tau_p=1e-6; % Lifetime constant for holes, s
kB=1.380649e-23;% % Boltzmann constant, J./K
qel=1.602176634e-19; % Elementary charge, C
T=300; % Temperature, K
Vt=kB*T/qel; % V
mu_n=831.0986; % Hole mobility, cm^2/V/s
mu_p=308.4246;
Dn=mu_n*Vt; % Hole diffusivity,  cm^2/s
Dp=mu_p*Vt;
Ln=sqrt(Dn*tau_p)*1e4; % um 
Lp=sqrt(Dp*tau_p)*1e4;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HOLES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% L=50 um
delimiterIn = ','; % Data delimiter
headerlinesIn = 4; % Number of header lines in the file
filename = 'ElectronConcentrationa.txt';
A = importdata(filename,delimiterIn,headerlinesIn);
pos_Medium = A.data(:,1);
Hole_Medium = A.data(:,2);

figure
plot(pos_Medium,Hole_Medium,'LineWidth',1.5)
grid on
xlabel('Posizione [\mum]')
ylabel('Concentrazione elettroni [cm^{-3}]')
title('Concentrazione elettroni sotto illuminazione')

% Comparision with analytical formulas
% Medium semiconductor
L=375; % um
x=linspace(0,L,200); % um
pp_n0=max(Hole_Medium); % cm^-3
n_p0= 494.3674813573;
n_p_Medium_Analytic=pp_n0.*sinh((L-x)./Ln)./sinh(L./Ln)+n_p0;

figure
plot(pos_Medium,Hole_Medium,'b-*','LineWidth',1.5)
hold on
grid on
plot(x,n_p_Medium_Analytic,'r','LineWidth',1.5)
legend('Simulazione','Formula analitica')
xlabel('Posizione [\mum]')
ylabel('Concentrazione elettroni [cm^{-3}]')
title('Concentrazione elettroni sotto illuminazione')

%% L=50 um
delimiterIn = ','; % Data delimiter
headerlinesIn = 4; % Number of header lines in the file
filename = 'HoleChargeConcentrationa.txt';
A = importdata(filename,delimiterIn,headerlinesIn);
pos_Medium = A.data(:,1);
Hole_Medium = A.data(:,2);

figure
plot(pos_Medium,Hole_Medium,'LineWidth',1.5)
grid on
xlabel('Position [\mum]')
ylabel('Hole Concentration [cm^{-3}]')
title('Hole Concentration Under Illumination for L=50 \mum')

% Comparision with analytical formulas
% Medium semiconductor
L=375; % um
x=linspace(0,L,200); % um
pp_n0=max(Hole_Medium); % cm^-3
p_n0=9e+16;
p_n_Medium_Analytic=pp_n0.*sinh((L-x)./Lp)./sinh(L./Lp)+p_n0;

figure
plot(pos_Medium,Hole_Medium,'b-*','LineWidth',1.5)
hold on
grid on
plot(x,p_n_Medium_Analytic,'r','LineWidth',1.5)
legend('Simulazione','Formula analitica')
xlabel('Position [\mum]')
ylabel('Hole Concentration [cm^{-3}]')
title('Concentrazione lacune')
