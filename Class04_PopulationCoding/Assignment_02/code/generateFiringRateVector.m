function rates = generateFiringRateVector(s,N,rMax,deltaT,sigma)

    if nargin < 5 || isempty(sigma)
        sigma = pi / N;
    end

    mus = linspace(0,2*pi,N+1);
    mus = mus(1:end-1);
    kappa = fzero(@(x) sigma^2 - 1 + besseli(1,x)/besseli(0,x),max([0,2-sigma^2]));
    amp = rMax/exp(kappa);
    
    
    rates = zeros(N,1);
    for i=1:N
        r = amp*exp(kappa*cos(s-mus(i)));
        rates(i) = poissrnd(r*deltaT)/deltaT;
    end