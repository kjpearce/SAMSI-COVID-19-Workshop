function yprime = SEIRrhs(t, y, params)

%%% model parameters
mu    = params(1);
iota  = params(2);
delta = params(3);
beta  = params(4);
v     = params(5);
ep    = params(6);
sigma = params(7);
gamma = params(8);
kappa = params(9);
alpha = params(10);
rho   = params(11);
eta   = params(12);
Tv    = params(13);

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
yprime(1) = mu - (delta + beta*(alpha*A + I + H) + iota + nu)*S; 

%%% dV/dt
yprime(2) = nu*S - (delta + beta*(alpha*A + I + H)*(1-epsilon))*V;

%%% dE/dt
yprime(3) = beta*(alpha*A + I + H)*S + beta*(1-epsilon)*(alpha*A + I + H)*V + iota*S - (delta + rho)*E;

%%% dA/dt
yprime(4) = (1-sigma)*rho*E - (delta + gamma)*A; 

%%% dI/dt
yprime(5) = sigma*rho*E - (delta + gamma)*I;

%%% dH/dt
yprime(6) = gamma*kappa*I - (delta + eta)*H;


