function J = objfun(hdata, tdata, X0, K, qbar, params)

y = odefit(tdata, X0, K, qbar, params);

H = y(:,6);

N = length(H);
res = zeros(N,1);
for pt = 1:N
    res(pt) = H(pt) - hdata(pt);
end

J = (1/N)*norm(res).^2;




