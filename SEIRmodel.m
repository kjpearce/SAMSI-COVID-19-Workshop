function [t,y] = SEIRmodel(N0, params)
%%%  Inputs: 
%%%       N0: initial condition for
%%%           state vector X = [S; V; E; A; I; H]
%%%           S: susceptible individuals
%%%           V: vaccinated individuals (not yet infected)
%%%           E: exposed but not yet infectious
%%%           A: asymptomatic infected
%%%           I: symptomatic infected
%%%           H: hospitalized (from symptomatic infected)
%%%       params: model parameter values
%%%           mu: birth rate [ppl/T]
%%%           iota: importation rate of infected people [1/T]
%%%           delta: baseline death rate [1/T]
%%%           beta: transmission coeff = rate at which susceptible and infectious come into contact * probability of transmission [1/T * diml]
%%%           v: vacc rate [1/T]
%%%           ep: vacc protection [diml]
%%%           sigma: proportion of infected with symptoms [diml]
%%%           gamma: rate of progression through infected stage [1/T]
%%%           kappa: probability of hospt. for sympt. infected [diml]
%%%           alpha: relative infectiousness of asympt infected [diml]
%%%           rho: rate of progression to infectiousness following infection [1/T]
%%%           eta: rate of progression thru hospitalization [1/T]
%%%           Tv: day first vaccine administered

%%% specify time steps to record the solution
tfinal = 730; %%% in days
tspan = 0:1:tfinal; 

%%% initial state vec
yzero = zeros(6, 1);
yzero(1) = N0;   

options = odeset('AbsTol',1e-10, 'RelTol', 1e-10);

frhs = @(t, y)(SEIRrhs(t, y, params));
 
[t,y] = ode15s(frhs, tspan, yzero, options);



