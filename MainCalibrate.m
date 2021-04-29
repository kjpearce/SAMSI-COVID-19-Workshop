%%%% SEIR calibration

clear 
close all

%%% values from paper
%%%% use parameter values from cited paper
%mu    = 0.0116/365;
%delta = 0.0116/365;

iota  = [1e-7; 3e-7; 1e-6]; %%% importation rate of infected
beta  = [0.514; 0.6; 0.686]; %%% transmission coefficient
nu    = [0.001516; 0.00197; 0.002467]; %%% rate of vaccination
ep    = [0.5; 0.8; 0.9]; %%% vaccine efficacy
sigma = [0.5; 0.82; 0.9]; %%% proportion of infections that result in symptoms
gamma = [0.125; 0.31; 0.5]; %%% rate of progression through infection stage
kappa = [0.207; 0.26; 0.314]; %%% probability of hosp among sympt infected
alpha = [0.046; 0.602; 0.981]; %%% relative infectiousness of asymptomatic people
rho   = [0.166; 0.2; 0.333]; %%% rate of progression to infectiousness following infection
eta   = [0.0485; 0.075; 0.172]; %%% rate of progression through hospitalization 
ParMat = [alpha, beta, eta, gamma, iota, kappa, nu, rho, sigma];

tau   = 300; %%% day vaccines start (Dec 2020)

%%% total NC population in 2019: 10.49 million (source: US Census Bureau)
N = 10.49e6;

%%% total NC deaths in 2019: 95,951 (source: North Carolina State Center for Health
%%% Statistics)
deaths = 95951;

%%% total NC births in 2019: 118,725 (source: North Carolina State Center for Health
%%% Statistics)
births = 118725;

mu    = births/(N*365); %%% daily birth rate
delta = deaths/(N*365); %%% daily death rate

%%% try fmincon with values from paper as lb and ub; fix birth/death rate
FixedNames = {'delta','ep','mu','tau'};
FixedPars  = [delta, ep(2), mu, tau];
FixedCell  = [FixedNames; num2cell(FixedPars)];
Fixed = struct(FixedCell{:});

%%% estimate everything else
EstNames = {'alpha','beta','eta','gamma','iota','kappa','nu','rho','sigma'};
EstPars = [alpha(2), beta(2), eta(2), gamma(2), iota(2), kappa(2), nu(2), rho(2), sigma(2)];
EstCell = [EstNames; num2cell(EstPars)];
Est = struct(EstCell{:});

%%% monthly hospitalization averages in NC since April 2020
hosp_data = [0, 375, 461.92, 579.90, 865.53, 1157.03, 1028.00, 912.07, 1109.03, 1482.10, 2751.13, 3605.29, 1989.64, 1041.23];
hosp_data = hosp_data/N;
t_data = zeros(1,length(hosp_data));

start = 0;
for pt = 1:length(hosp_data)-1
    start = start + 30;
    t_data(pt+1) = start;
end

%%% in case we need to do months--unlikely
%t_data = [0, 1:(length(hosp_data)-1)];

%%% create lower and upper bounds for optimization
lb = ParMat(1,:);
ub = ParMat(3,:);

params = {'alpha','beta','delta','ep','eta','gamma','iota','kappa','mu','nu','rho','sigma','tau'};
[Kopt, fval] = fminroutine(hosp_data, t_data, 1, EstPars, Fixed, params, lb, ub);


tspan = 0:0.1:400;
Y = odefit(tspan, 1, Kopt, Fixed, params);
figure()
plot(t_data, hosp_data, 'o', tspan, Y(:,3:6),'LineWidth',3','MarkerSize',14)
set(gca,'FontSize',18)
legend('Hospitalized in NC','E','A','I','H')

