clear all 
close all
clc
format long e

delimiterIn = ','; 
headerlinesIn = 4; 

filename = 'ElectronConcentration.txt'; % Name of the file to be imported 
B = importdata(filename,delimiterIn,headerlinesIn);% Save the imported data in the variable A
pos_Elec=B.data(:,1);
elec_pos = B.data(:,2); % Save in a separate vector the ordinate values

filename = 'ElectronConcentration-0.5.txt'; % Name of the file to be imported 
C = importdata(filename,delimiterIn,headerlinesIn); % Save the imported data in the variable A
elec_neg = C.data(:,2); % Save in a separate vector the ordinate values % um

figure
plot(pos_Elec,elec_pos,'g',pos_Elec,elec_neg,'r','Linewidth',1.5)
grid on
title('Concentrazione elettroni a diversi potenziali sotto illuminazione')
legend('0.5 V','-0.5 V')
xlabel('Posizione [\mum]')
ylabel('Concentrazione elettroni [cm^{-3}]')


filename = 'HoleChargeConcentration.txt'; % Name of the file to be imported 
B = importdata(filename,delimiterIn,headerlinesIn);% Save the imported data in the variable A
a=B.data(:,1);
b = B.data(:,2); % Save in a separate vector the ordinate values

filename = 'HoleChargeConcentration-0.5.txt'; % Name of the file to be imported 
C = importdata(filename,delimiterIn,headerlinesIn); % Save the imported data in the variable A
c = C.data(:,2); % Save in a separate vector the ordinate values % um

figure
plot(a,b,'g',a,c,'r','Linewidth',1.5)
grid on
title('Concentrazione lacune a diversi potenziali sotto illuminazione')
legend('0.5 V','-0.5 V')
xlabel('Posizione [\mum]')
ylabel('Concentrazione lacune [cm^{-3}]')