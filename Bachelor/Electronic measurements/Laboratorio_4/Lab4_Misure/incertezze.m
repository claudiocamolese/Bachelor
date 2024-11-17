% calcoli incertezze Lab4

%% Vref = 5
clc
clear all
close all

Nadc = 586; 
Vref = 5;
s = 10*10^(-3);
R = 1800;

V0 = Nadc * (Vref/1024);
T = (V0 / s) - 273.15
A = (V0 / s);

eps_Vref = 5   % da pdf
eps_Nadc = 2/1024
eps_s = 2/T
eps_A = eps_Vref + eps_Nadc + eps_s;
delta_T = (eps_A / 100) * A

I = (Vref - V0) / R;
P = I * V0;
Ar = 165 * P    % 165 C/W da pdf


%% Vref misurata
clc
clear all
close all

Nadc = 586; 
Vref = 5.1064;
s = 10*10^(-3);
R = 1800;

V0 = Nadc * (Vref/1024);
T = (V0 / s) - 273.15
A = (V0 / s);

delta_Vref = (0.000035*Vref+0.000005*10) + 3*(0.000005*Vref+0.000001*10) + 0.0003;
eps_Vref = delta_Vref / Vref;   % da pdf
eps_Nadc = 2/1024;
eps_s = 2/T;
eps_A = eps_Vref + eps_Nadc + eps_s;
delta_T = (eps_A / 100) * A

I = (Vref - V0) / R;
P = I * V0;
Ar = 165 * P    % 165 C/W da pdf

%% messa a punto
clc
clear all
close all

Nadc = 586; 
Vref = 5.1064;
s = 10*10^(-3);
R = 1800;
Tsens = 20.9;

V0 = Nadc * (Vref/1024);
B = (Tsens + 273.15 ) * 1024 / Nadc
T = (Nadc / 1024) * B - 273.15
A = (V0 / s);

eps_Nadc = 2/1024;
eps_s = 2/T;

delta_Tsens = 0.1;
eps_B = (delta_Tsens / (Tsens + 273.15))+eps_Nadc;
delta_B = eps_B*B;
eps_A = eps_B + eps_Nadc;

delta_Vref = (0.000035*Vref+0.000005*10) + 3*(0.000005*Vref+0.000001*10) + 0.0003;
eps_Vref = delta_Vref / Vref;   % da pdf
delta_T = eps_A * T

I = (Vref - V0) / R;
P = I * V0;
Ar = 165 * P    % 165 C/W da pdf




