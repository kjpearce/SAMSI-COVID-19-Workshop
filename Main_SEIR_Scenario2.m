%%%%%%%%% Main File (Scenario 2) : SEIR-based model for COVID-19 (See: Perkins, T.A., España, G.
%%%%%%%%%                                             Optimal Control of the COVID-19 Pandemic with Non-pharmaceutical Interventions. 
%%%%%%%%%                                             Bull Math Biol 82, 118 (2020). https://doi.org/10.1007/s11538-020-00795-y)
%%%%%%%%% Created by : Kate Pearce
%%%%%%%%%              SAMSI Workshop on Mathematical Modeling, May 16-17, 2021

%%%%%%%%% 
%%%%%%%%% Simulating scenarios of COVID-19 spread in North Carolina
%%%%%%%%%

%%%%%%%%%
%%%%%%%%% SCENARIO 2: Run AFTER Main_SEIR_Baseline.m 
%%%%%%%%% 

clearvars -except newSubFolder 

%%%%%%%%% Initial conditions (normalized by total population of NC)

S0 = 0.5;          %%% half the population assumed susceptible at pandemic "mid-point"
V0 = 0;            %%% vaccinated
E0 = 0.001*S0;     %%% exposed
H0 = 1000/10.49e6; %%% hospitalized
I0 = 10*H0;        %%% infected (symptomatic)
A0 = 0.10*I0;      %%% infected (asymptomatic)

X0 = [S0; V0; E0; A0; I0; H0]; 

%%%%%%%%% Parameter values (Scenario 2)

mu     = 0.0116/365;
delta  = 0.0116/365;
beta   = 0.686*1.1; %%% Scenario 2
sigma  = 0.82;
gamma  = 0.29;
kappa  = 0.0735;  
alpha  = 0.5;
rho    = 0.2;
eta    = 0.17;
nu     = 0;
ep     = 0;
tau_nu = 0;

params = [mu; delta; beta; nu; ep; sigma; gamma; kappa; alpha; rho; eta; tau_nu];

[t,y]  = SEIRmodel(X0, params);          %%% numerical ODE solution

figure(6)
plot(t, 10.49e6*y(:,3:6), 'LineWidth',3) %%% scale back to population size
set(gca,'FontSize',18)
axis([0 400 0 inf])
legend('E','A','I','H')
xlabel('Days Elapsed since Sept 2020')
ylabel('Number of People')
title('Scenario 2')
saveas(gcf, [newSubFolder '/Scenario2_1.png'])

figure(7)
plot(t, 10.49e6*y(:,3:6), 'LineWidth',3) 
set(gca,'FontSize',18)
axis([0 400 0 6e4])
legend('E','A','I','H')
xlabel('Days Elapsed since Sept 2020')
ylabel('Number of People')
title('Scenario 2: Zoomed In')
saveas(gcf, [newSubFolder '/Scenario2_2.png'])

