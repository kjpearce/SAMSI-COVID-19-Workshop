%%%%%%%%% Main File (Scenario 1) : SEIR-based model for COVID-19 (See: Perkins, T.A., España, G.
%%%%%%%%%                                             Optimal Control of the COVID-19 Pandemic with Non-pharmaceutical Interventions. 
%%%%%%%%%                                             Bull Math Biol 82, 118 (2020). https://doi.org/10.1007/s11538-020-00795-y)
%%%%%%%%% Created by : Kate Pearce
%%%%%%%%%              SAMSI Workshop on Mathematical Modeling, May 16-17, 2021

%%%%%%%%% 
%%%%%%%%% Simulating scenarios of COVID-19 spread in North Carolina
%%%%%%%%%

%%%%%%%%%
%%%%%%%%% SCENARIO 1: Run AFTER Main_SEIR_Baseline.m 
%%%%%%%%% 

clearvars -except newSubFolder 

%%%%%%%%% Initial conditions (normalized by total population of NC)

S0 = 1*.5;  
V0 = 0;
E0 = 0.001*S0;
H0 = 1000/10.49e6;
I0 = 10*H0;
A0 = 0.10*I0;

X0 = [S0; V0; E0; A0; I0; H0];


%%%%%%%%% Parameter values (Scenario 1)

mu     = 0.0116/365;
delta  = 0.0116/365;
beta   = 0.686;
sigma  = 0.82;
gamma  = 0.29;
kappa  = 0.0735;
alpha  = 0.5;
rho    = 0.2;
eta    = 0.17;
nu     = 0.006; %%% Scenario 1
ep     = 0.95;  %%% Scenario 1
tau_nu = 120;   %%% Scenario 1

params = [mu; delta; beta; nu; ep; sigma; gamma; kappa; alpha; rho; eta; tau_nu];

[t,y]  = SEIRmodel(X0, params);          %%% numerical ODE solution

figure(3)
plot(t, 10.49e6*y(:,3:6), 'LineWidth',3) %%% scale back to population size
set(gca,'FontSize',18)
axis([0 400 0 0.006*10.49e6])
legend('E','A','I','H')
xlabel('Days Elapsed since Sept 2020')
ylabel('Number of People')
title('Scenario 1')
saveas(gcf, [newSubFolder '/Scenario1_1.png'])

figure(4)
plot(t, 10.49e6*y(:,3:6), 'LineWidth',3)
set(gca,'FontSize',18)
axis([0 400 0 0.0035*10.49e6])
legend('E','A','I','H')
xlabel('Days Elapsed since Sept 2020')
ylabel('Number of People')
title('Scenario 1: Zoomed In')
saveas(gcf, [newSubFolder '/Scenario1_2.png'])

figure(5)
plot(t, 10.49e6*y(:,2), 'LineWidth', 3) %%% Hint: What is this plotting? 
set(gca,'FontSize',18)
axis([0 400 0 inf])
xlabel('Days Elapsed since Sept 2020')
ylabel('Number of People')
title('Scenario 1')
saveas(gcf, [newSubFolder '/Scenario1_3.png'])