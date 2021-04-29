function yprime = SEIRrhsEST(t, y, K, qbar, params)

%%% model parameters
count = 1; % number of nonzero entries in qbar 
        
numpar = length(params);
Kvec = zeros(1,numpar);

for par = 1:numpar
    %%% if parameter is fixed in qbar
    if isfield(qbar,params{par}) == 1
        %%% store that entry from qbar in Kvec
        Kvec(par) = getfield(qbar,params{par});
    else
        Kvec(par) = K(count);
        count = count + 1;
    end
end

P = [params; num2cell(Kvec)];
P = struct(P{:});

%%% states
S = y(1);
V = y(2);
E = y(3);
A = y(4);
I = y(5);
H = y(6);

if (t>=0)&&(t<=P.tau)
    nu = 0;
    epsilon = 0;
elseif (t>P.tau)
    nu = P.nu;
    epsilon = P.ep;
end

yprime = zeros(6, 1);

%%% dS/dt
yprime(1) = P.mu - (P.delta + P.beta*(P.alpha*A + I + H) + P.iota + nu)*S; 

%%% dV/dt
yprime(2) = nu*S - (P.delta + P.beta*(P.alpha*A + I + H)*(1-epsilon))*V;

%%% dE/dt
yprime(3) = P.beta*(P.alpha*A + I + H)*S + P.beta*(1-epsilon)*(P.alpha*A + I + H)*V + P.iota*S - (P.delta + P.rho)*E;

%%% dA/dt
yprime(4) = (1-P.sigma)*P.rho*E - (P.delta + P.gamma)*A; 

%%% dI/dt
yprime(5) = P.sigma*P.rho*E - (P.delta + P.gamma)*I;

%%% dH/dt
yprime(6) = P.gamma*P.kappa*I - (P.delta + P.eta)*H;

