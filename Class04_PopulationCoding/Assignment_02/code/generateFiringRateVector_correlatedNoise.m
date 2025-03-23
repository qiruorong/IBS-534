function rates = generateFiringRateVector_correlatedNoise(s,N,rMax,deltaT,rho,sigma)

    if nargin < 6 || isempty(sigma)
        sigma = pi / N;
    end

    mus = linspace(0,2*pi,N+1);
    mus = mus(1:end-1);
    kappa = fzero(@(x) sigma^2 - 1 + besseli(1,x)/besseli(0,x),max([0,2-sigma^2]));
    amp = rMax/exp(kappa);
    
    
    
    rs = zeros(N,1);
    for i=1:N
        rs(i) = amp*exp(kappa*cos(s-mus(i)));
    end
    
    rates = drawCorrelatedPoissonValues(rs*deltaT,1,rho,N)/deltaT;