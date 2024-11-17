%Laboratorio misure 1
clear all;
close all;
clc

% data

% ascisse tra x_min e x_max a step costante
% per provare y = y_3 mettere x_min = 50 e x_max = 850
x_min = 450;
x_max = 950;
step = 50;
x = (x_min:step:x_max);

% per prova con dati noti pt1
% x_min = 0;
% x_max = 450;
% step = 50;
% x = (x_min:step:x_max);

% ordinate
y_1 = [0.384, 52.629, 103.07, 155.146, 205.681, 256.702, 306.567, 356.124, 405.369, 456.238, 505.171, 557.087, 606.790, 657.484, 707.680, 757.280, 807.505, 856.916, 905.579, 955.849]; 
% prova con dati noti pt2
y_2 = [0.654, 50.784, 101.61, 151.71, 202.99, 253.84, 305.14, 355.97, 406.73, 456.91];	
y_3 = [55.629, 105.07, 155.146, 205.681, 256.702, 306.567, 356.124, 405.369, 456.238, 506.171, 557.087, 606.790, 657.484, 707.680, 757.280, 807.505, 856.916, 906.579, 956.849]; 
y_4 = [456.238, 506.171, 557.087, 606.790, 657.484, 707.680, 757.280, 807.505, 856.916, 906.579, 956.849]; 
y = y_4;

% interpolating function

% grade
n = 1;
coeff = polyfit(x,y,n);
m = coeff(1)
q = coeff(2)

% values of interpolating function
z = polyval(coeff,x);

% max deviation
% finding max deviation, sign and position
diff = y-z;
error_max = max(abs(diff))
x_error_max = find(abs(diff) == error_max);
s = sign(diff(x_error_max));
% std deviation (i guess)
deviation = std(diff);

% calculating uncertainties
strum_deviation = ((0.010*0.01*max(y))+(0.001*0.01*1000)) + ((0.0006*0.01*max(y))+(0.0001*0.01*1000))*5.2;  
state_deviation = 20*10^(-6)*max(y)*5;
inter_deviation = error_max;
read_deviation = 0.01+0.25;
hyster = 0;     % trasccurabile
deviations = [strum_deviation, state_deviation, inter_deviation, read_deviation];
tot_deviation = sum(deviations)
tot_deviation_pcent = tot_deviation/max(y)*100

% plotting
tiledlayout(2,1)

figure (1)
%top plot
nexttile
plot(x,y,'b-x')
title('Interpolation function')
axis ([(x_min - step) (x_max + step) (min(y) - max(y)*0.2) (max(y) + max(y)*0.2)])

% bottom plot
nexttile
stem(x,y-z,'r')
title("interpolation error")
axis ([(x_min - step) (x_max + step) (min(y-z) - max(y-z)*0.2) (max(y-z) + max(y-z)*0.2)])
hold on
plot(x_error_max*step,s*error_max,'b-x')
hold off

% deviation chart
figure (2)
names = ["strumentale","stato sistema","interpolazione","lettura"];
tbl = table(names, deviations);
piechart(tbl,"deviations","names")


