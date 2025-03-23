function s_ML = maximumLikelihoodEstimateDecoder(rates)

    N = length(rates);
    mus = linspace(0,2*pi,N+1);
    mus = mus(1:end-1);

    
    s_ML = fzero(@(x) sum(rates.*sin(mod(x,2*pi) - mus')),mus(argmax(rates)));
    s_ML = mod(s_ML,2*pi);