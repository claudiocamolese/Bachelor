close all,
clear all,
clc
%% 600 K!!!!!
% Script for importing results

delimiterIn = ','; % Data delimiter
headerlinesIn = 4; % Number of header lines in the file

filename = 'ConductionBandPotential.txt'; % Name of the file to be imported 
A = importdata(filename,delimiterIn,headerlinesIn); % Save the imported data in the variable A
pos_CB = A.data(:,1); % Save in a separate vector the abscissa values
CB = A.data(:,2); % Save in a separate vector the ordinate values

filename = 'ElectronConcentration.txt';
A = importdata(filename,delimiterIn,headerlinesIn);
pos_Elec = A.data(:,1);
Elec = A.data(:,2);

filename = 'ElectrostaticPotential.txt';
A = importdata(filename,delimiterIn,headerlinesIn);
pos_pot = A.data(:,1);
pot = A.data(:,2);

filename = 'HoleChargeConcentration.txt';
A = importdata(filename,delimiterIn,headerlinesIn);
pos_Hole = A.data(:,1);
Hole = A.data(:,2);

filename = 'pQuasiFermiLevel.txt';
A = importdata(filename,delimiterIn,headerlinesIn);
pos_qpf = A.data(:,1);
qfp = A.data(:,2);

filename = 'ValenceBandPotential.txt';
A = importdata(filename,delimiterIn,headerlinesIn);
pos_VB = A.data(:,1);
VB = A.data(:,2);

% Plot
figure,plot(pos_pot,pot,'b','LineWidth',1.5)
grid on
title('Electrostatic Potential @0V,600K')
xlabel('Position [\mum]')
ylabel('Electrostatic Potential, [V]')

figure
plot(pos_CB,CB,'r',pos_VB,VB,'b',pos_qpf,qfp,'g-.',pos_pot,-pot,'k:','LineWidth',1.5)
grid on
title('Diagramma a bande di energia silicio dopato-p @0V,600K')
legend('Banda di conduzione','Banda di valenza','p Quasi livelli di Fermi','Livello intrinseco di Fermi')
xlabel('Posizione [\mum]')
ylabel('Energy [eV]')

Ef_m_Ev_Simulation = qfp(1)-VB(1); % eV

figure,semilogy(pos_Hole,Hole,'b',pos_Elec,Elec,'r','LineWidth',1.5)
grid on
legend('Hole concentration','Electron Concentration')
title('Electron and hole concentrations p-doped silicon @0V,600K')
xlabel('Position [\mum]')
ylabel('Carriers concentration, [cm^{-3}]')

pp0_Simulation = Hole(1); % cm^-3
np0_Simulation = Elec(1); % cm^-3
