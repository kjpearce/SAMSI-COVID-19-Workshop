%%%% Main: SEIR-type model for COVID-19 (See: Perkins, T.A., España, G.
%%%%                                          Optimal Control of the COVID-19 Pandemic with Non-pharmaceutical Interventions. Bull Math Biol 82, 118 (2020). https://doi.org/10.1007/s11538-020-00795-y)
%%%% Author: Kate Pearce
%%%% SAMSI Workshop on Mathematical Modeling

clear
close all

%%%% all individuals assumed susceptible at t=0 (normalized by total population)
N0 = 1;  

%%%% use parameter values from cited paper
mu    = 0.0116/365;
iota  = 1e-6;
delta = 0.0116/365;
beta  = 0.6;
%v     = 0.00197;
v = 0;
ep = 0;
%ep    = 0.8;
sigma = 0.82;
gamma = 0.31;
kappa = 0.26;
alpha = 0.1;
rho   = 0.2;
eta   = 0.075;
Tv    = 330;

params = [mu; iota; delta; beta; v; ep; sigma; gamma; kappa; alpha; rho; eta; Tv];

[t,y] = SEIRmodel(N0, params);

figure()
plot(t, y, 'LineWidth',3)
set(gca,'FontSize',18)
legend('S','V','E','A','I','H')
