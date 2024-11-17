clc
clear all
close all

% T ini 23.8
% T fin


% dati
Ra = 671.58;
Rb = 118724;
Rc_div = 830.9+0.25;
% Rc = (1.0022 * Rc_div) + 5.3878
Rc = (1.0010 * Rc_div) + 6.2745;
Rx = Rc*(Ra/Rb)

Val = 30;


% calcolo incertezze R
delta_Ra = (0.00010*Ra+0.00001*1000)...         % strum 1
    + ((0.0000060*Ra+0.000001*1000)*5)...       % strum 2 temp
    + ((200*10^(-6)*Ra*5))...                   % stato temp
    + (0.01);                                   % lettura


delta_Rb = (0.00010*Rb+0.00001*1000)...         % strum 1
    + ((0.0000060*Rb+0.000001*1000)*5)...       % strum 2 temp
    + ((200*10^(-6)*Rb*5))...                   % stato temp
    + (10);                                   % lettura

delta_Rc = 1.2147;                              % dal lab 1


eps_Rx_R = ((delta_Ra/Ra) + (delta_Rb/Rb) + (delta_Rc/Rc))...   % incertezze varie R
    + 0;                                          
    
delta_Rx = (eps_Rx_R*Rx) + 0.2 + 0.125 +...   % incertezze R, contatti e galvanometro
    ((35*10^(-6)*Rx*5))...                    % stato temp Rx 
    + ((4*0.05)/Val)                          % incertezza sens ponte


 
% calcolo incertezza sensibilta' ponte

Veq = Val * ((Rb/(Ra+Rb))-(Rc/(Rx+Rc)));
delta_Veq = Val*((Rc*Rx) / ((Rx+Rc)^2))*(delta_Rx/Rx);
sens = Val*((Rc) / ((Rx+Rc)^2));
sens_sp = (delta_Rc/Rc)/(1/1);

