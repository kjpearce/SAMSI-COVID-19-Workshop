function [Kopt, fval] = fminroutine(hvec, tvec, N, K0, qbar, params, lb, ub)
    
    options = optimset('Display','iter','TolFun', 1e-12, 'TolX', 1e-8);
    
    optfun = @(K) objfun(hvec, tvec, N, K, qbar, params);
    
    [Kopt, fval] = fmincon(optfun, K0, [], [], [], [], lb, ub, [], options);

end
