function [rateFunctions,mus,kappa,amp] = createFiringRateFunctions(N,rMax,sigma)

    if nargin < 3 || isempty(sigma)
        sigma = pi / N;
    end
    
    mus = linspace(0,2*pi,N+1);
    mus = mus(1:end-1);
    kappa = fzero(@(x) sigma^2 - 1 + besseli(1,x)/besseli(0,x),max([0,2-sigma^2]));
    amp = rMax/exp(kappa);
    
    rateFunctions = cell(N,1);
    for i=1:N
        rateFunctions{i} = @(x) amp*exp(kappa*cos(x-mus(i)));
    end