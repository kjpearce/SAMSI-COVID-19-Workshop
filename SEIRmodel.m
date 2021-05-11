function [t,y] = SEIRmodel(X0, params)
%%%  Function to compute numerical solution of ODE system
%%%  Author: Kate Pearce

%%%  Inputs: 
%%%       X0: initial condition for state vector X = [S; V; E; A; I; H]
%%%       params: model parameters
%%%           mu: birth rate
%%%           iota: importation rate of infected people
%%%           delta: baseline death rate 
%%%           beta: transmission coeff = rate at which susceptible and infectious come into contact * probability of transmission [1/T * diml]
%%%           v: vacc rate
%%%           ep: vacc protection [diml]
%%%           sigma: proportion of infected with symptoms [diml]
%%%           gamma: rate of progression through infected stage 
%%%           kappa: probability of hospt. for sympt. infected [diml]
%%%           alpha: relative infectiousness of asympt infected [diml]
%%%           rho: rate of progression to infectiousness following infection 
%%%           eta: rate of progression thru hospitalization
%%%           Tv: day first vaccine administered

%%% Outputs: 
%%%       t: time vector 
%%%       y: state vector 


tfinal = 600; %%% Specify time steps to record the solution (in days)
tspan = 0:1:tfinal; 

options = odeset('AbsTol',1e-10, 'RelTol', 1e-8); 

frhs = @(t, y)(SEIRrhs(t, y, params));    %%% anonymous sub-function for ODE solver
 
[t,y] = ode15s(frhs, tspan, X0, options); %%% calls numerical solver

%%% sub-function SEIRrhs: creates right hand side of ODE system
    function yprime = SEIRrhs(t, y, params)

        %%% model parameters
        mu    = params(1);
        delta = params(2);
        beta  = params(3);
        v     = params(4);
        ep    = params(5);
        sigma = params(6);
        gamma = params(7);
        kappa = params(8);
        alpha = params(9);
        rho   = params(10);
        eta   = params(11);
        Tv    = params(12);

        %%% states
        S = y(1);
        V = y(2);
        E = y(3);
        A = y(4);
        I = y(5);
        H = y(6);

        if (t>=0)&&(t<=Tv)
            nu = 0;
            epsilon = 0;
        elseif (t>Tv)
            nu = v;
            epsilon = ep;
        end

        yprime = zeros(6, 1);

        %%% dS/dt
        yprime(1) = mu - (delta + beta*(alpha*A + I + H) + nu)*S; 

        %%% dV/dt
        yprime(2) = nu*S - (delta + beta*(alpha*A + I + H)*(1-epsilon))*V;

        %%% dE/dt
        yprime(3) = beta*(alpha*A + I + H)*S + beta*(1-epsilon)*(alpha*A + I + H)*V - (delta + rho)*E;

        %%% dA/dt
        yprime(4) = (1-sigma)*rho*E - (delta + gamma)*A; 

        %%% dI/dt
        yprime(5) = sigma*rho*E - (delta + gamma)*I;

        %%% dH/dt
        yprime(6) = gamma*kappa*I - (delta + eta)*H;

    end

end


