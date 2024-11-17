close all
clear all
clc

% Parametri e Dati
K =  16;
nBit = 4;
x = linspace(0,15,K);
y_data_old = [0.08 0.165 0.288 0.442 0.601 0.757 0.878 1.034 1.266 1.423 1.545 1.702 1.858 2.015 2.139 2.295];
y_data = [0.056 0.148 0.269 0.423 0.579 0.733 0.854 1.008 1.236 1.390 1.511 1.665 1.821 1.975 2.096 2.25];
y_data = -y_data;

% Retta di regressione
Sx = sum(x);
Sy = sum(y_data);
Sq = sum(x.^2);
P = sum(x.*y_data);

m_1 = (P-(Sx*Sy/K))/(Sq-(Sx*Sx/K));
q_1 = (Sy-(m_1*Sx))/K;

y_1 = m_1*x + q_1;

% Retta ideale
Va_max = -((5*5.6*(K-1))/((2^(nBit-1))*22));
m = Va_max/(K-1);
y = m*x;

% Errore guadagno
alpha = (atan(m)*180)/pi;
alpha_1 = (atan(m_1)*180)/pi;
Eg = ((alpha_1-alpha)/abs(alpha))*100;

% Errore offset
Eo = q_1;

% Errore INL
INL = abs(y_1)-abs(y_data);

% Errore DNL
A_dm = abs((y_1(16)-y_1(1))/15);
DNL = zeros(1,16);
for i = 1:16
    if i == 1
        %DNL(i) = y_data(i)-A_dm;
        DNL(i) = INL(i);
    else
        DNL(i) = abs((y_data(i)-y_data(i-1)))-A_dm;
    end
end

% plotting retta di regressione
figure('Name','Retta di regressione','NumberTitle','off')
plot(x,y_1,'blue')
hold on 
scatter(x,y_data,'+','red')
grid on
title('Retta di regressione')
xlabel('Conteggio in base 10')
ylabel('V_a     [V]')
xlim([-1 16])
ylim([-2.5 0.2])
legend('Retta di regressione','punti misurati')
hold off

% plotting INL e DNL
figure('Name','Errore non linearità assoluto','NumberTitle','off')
stem(x,INL,'blue')
grid on
title('Errore non linearità assoluto')
xlabel('Conteggio in base 10')
ylabel('INL')
xlim([-1 16])
ylim([-0.08 0.08])


figure('Name','Errore non linearità differenziale','NumberTitle','off')
stem(x,DNL,'blue')
grid on
title('Errore non linearità differenziale')
xlabel('Conteggio in base 10')
ylabel('DNL')
xlim([-1 16])
ylim([-0.09 0.09])


