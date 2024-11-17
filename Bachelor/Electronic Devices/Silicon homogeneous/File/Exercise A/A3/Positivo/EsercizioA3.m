close all,
clear all,
clc

% Script for importing results

delimiterIn = ','; % Data delimiter
headerlinesIn = 4; % Number of header lines in the file

filename = 'ConductionBandPotential.txt'; % Name of the file to be imported 
A = importdata(filename,delimiterIn,headerlinesIn); % Save the imported data in the variable A
pos_CB = A.data(:,1); % Save in a separate vector the abscissa values
CB = A.data(:,2); % Save in a separate vector the ordinate values

filename = 'ElectrostaticPotential.txt';
A = importdata(filename,delimiterIn,headerlinesIn);
pos_pot = A.data(:,1);
pot = A.data(:,2);

filename = 'nQuasiFermiLevel.txt';
A = importdata(filename,delimiterIn,headerlinesIn);
pos_qfn = A.data(:,1);
qfn = A.data(:,2);

filename = 'TotalCurrent.txt';
A = importdata(filename,delimiterIn,headerlinesIn);
pos_TotalCurrent = A.data(:,1);
TotalCurrent = A.data(:,2);

filename = 'ValenceBandPotential.txt';
A = importdata(filename,delimiterIn,headerlinesIn);
pos_VB = A.data(:,1);
VB = A.data(:,2);

filename = 'ivI1.txt';
A = importdata(filename,delimiterIn,headerlinesIn);
Vsemic_300K = A.data(:,1);
Isemic_300K = A.data(:,2);

%% Plot
figure,plot(pos_pot,pot,'b','LineWidth',1.5)
grid on
title('Electrostatic Potential @1V,300K')
xlabel('Position [\mum]')
ylabel('Electrostatic Potential, [V]')

figure
plot(pos_CB,CB,'r',pos_VB,VB,'b',pos_qfn,-qfn,'g-.',pos_pot,-pot,'k:','LineWidth',1.5)
grid on
title('Energy Band Diagram n-doped silicon @1V,300K')
legend('Conduction Band','Valence Band','n Quasi Fermi Level','Intrinsic Fermi Level')
xlabel('Position [\mum]')
ylabel('Energy [eV]')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nella figura seguente vi Ã¨ la Total Current, ovvero la corrente lungo il
% semiconduttore che nel plot di PADRE viene espressa in AMPERE. In realtÃ 
% c'Ã¨ un errore: quella che vediamo nel grafico non Ã¨ una corrente ma una
% densitÃ  di corrente espressa in A/cm^2.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
plot(pos_TotalCurrent,TotalCurrent,'LineWidth',1.5)
grid on
title('Corrente totale silicio drogato-p @0.8V,300K')
xlabel('Posizione[\mum]')
ylabel('Corrente totale [A]')

TotalCurrent_Simulation = TotalCurrent(1); % A

figure
plot(Vsemic_300K,Isemic_300K,'Linewidth',1.5)
grid on
title('Semiconductor Current as a function of the Applied Bias @300K')
xlabel('Applied Bias [V]')
ylabel('Current [A]')

filename = 'ElectricField.txt';
A = importdata(filename,delimiterIn,headerlinesIn);
pos_EF = A.data(:,1);
Fie = A.data(:,2);

figure 
plot(pos_EF,-Fie,'r','LineWidth',1.5)
grid on
title("Eletric Field @0V,300K")
xlabel('Position [\mum]')
ylabel('Campo elettrico [Vcm^-1]')




%% T=600 K
filename = 'ivI1.txt';
A = importdata(filename,delimiterIn,headerlinesIn);
Vsemic_600K = A.data(:,1);
Isemic_600K = A.data(:,2);

figure
plot(Vsemic_300K,Isemic_300K,'Linewidth',1.5)
hold on
plot(Vsemic_600K,Isemic_600K,'Linewidth',1.5)
grid on
legend('T=300 K','T=600 K')
title('Semiconductor Current as a function of the Applied Bias')
xlabel('Applied Bias [V]')
ylabel('Current [A]')
