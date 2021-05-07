%%%%%%%%% Main File (Baseline) : SEIR-based model for COVID-19 (See: Perkins, T.A., España, G.
%%%%%%%%%                                             Optimal Control of the COVID-19 Pandemic with Non-pharmaceutical Interventions. 
%%%%%%%%%                                             Bull Math Biol 82, 118 (2020). https://doi.org/10.1007/s11538-020-00795-y)
%%%%%%%%% Created by : Kate Pearce
%%%%%%%%%              SAMSI Workshop on Mathematical Modeling, May 16-17, 2021

%%%%%%%%% 
%%%%%%%%% Simulating scenarios of COVID-19 spread in North Carolina
%%%%%%%%%

%%%%%%%%%
%%%%%%%%% Baseline case: calibrated to NC hospitalizations starting from 
%%%%%%%%%                ~Sept 2020
%%%%%%%%% 

clear 
close all

%%%%%%%%% Initial conditions (normalized by total population of NC)

S0 = 0.5;          %%% half the population assumed susceptible at pandemic "mid-point"
V0 = 0;            %%% vaccinated
E0 = 0.001*S0;     %%% exposed
H0 = 1000/10.49e6; %%% hospitalized
I0 = 10*H0;        %%% infected (symptomatic)
A0 = 0.10*I0;      %%% infected (asymptomatic)

X0 = [S0; V0; E0; A0; I0; H0]; 

%%%%%%%%% Baseline parameter values

mu     = 0.0116/365;
delta  = 0.0116/365;
iota   = 3e-7;
beta   = 0.686;
sigma  = 0.82;
gamma  = 0.29;
kappa  = 0.0735;
alpha  = 0.5;
rho    = 0.2;
eta    = 0.17;
nu     = 0;
ep     = 0;
tau_nu = 0;

params = [mu; iota; delta; beta; nu; ep; sigma; gamma; kappa; alpha; rho; eta; tau_nu];

[t,y]  = SEIRmodel(X0, params); %%% numerical ODE solution

%%% create sub-folder to store figures
startingFolder = pwd;
newSubFolder = fullfile(startingFolder,'Figures');
if ~exist(newSubFolder,'dir')
    mkdir(newSubFolder)
end

figure(1)
plot(t, 10.49e6*y(:,2:6), 'LineWidth',3) %%% scale back to population size
set(gca,'FontSize',18)
axis([0 400 0 0.006*10.49e6])
legend('V','E','A','I','H')
xlabel('Days Elapsed since Mid-Pandemic Point')
ylabel('Number of People')
title('Baseline Case')
saveas(gcf, [newSubFolder '/Baseline_1.png'])

figure(2)
plot(t, 10.49e6*y(:,2:6), 'LineWidth',3)
set(gca,'FontSize',18)
axis([0 400 0 0.0035*10.49e6])
legend('V','E','A','I','H')
xlabel('Days Elapsed since Mid-Pandemic Point')
ylabel('Number of People')
title('Baseline Case: Zoomed In')
saveas(gcf, [newSubFolder '/Baseline_2.png'])
