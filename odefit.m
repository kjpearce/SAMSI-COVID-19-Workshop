function y = odefit(tdata, N0, K, qbar, params)

X0 = zeros(6,1);
X0(1) = N0;

anon = @(t,x) SEIRrhsEST(t, x, K, qbar, params);

[~,y] = ode15s(anon, tdata, X0);