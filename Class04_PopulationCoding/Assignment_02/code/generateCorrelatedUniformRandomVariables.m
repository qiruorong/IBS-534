function out = generateCorrelatedUniformRandomVariables(N,rho,d)

    if nargin < 3 || isempty(d)
        d = 2;
    end
    
    s = zeros(d) + rho;
    s(1:(d+1):end) = 1;
    
    R = mvnrnd(zeros(1,d),s,N);
    out = .5*(1+erf(R/sqrt(2)));