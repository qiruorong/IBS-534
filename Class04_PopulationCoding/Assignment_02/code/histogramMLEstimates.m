function [vals,avgRates] = histogramMLEstimates(s,N,rMax,deltaT,numValues,sigma,plotOn)

    if nargin < 6 || isempty(sigma)
        sigma = pi / N;
    end
    
    if nargin < 5 || isempty(numValues)
        numValues = 1000;
    end
    
    if nargin < 7 || isempty(plotOn)
        plotOn = true;
    end
    
    
    vals = zeros(numValues,1);
    avgRates = zeros(N,1);
    for i=1:numValues
        rates = generateFiringRateVector(s,N,rMax,deltaT,sigma);
        vals(i) = maximumLikelihoodEstimateDecoder(rates);
        %avgRates = avgRates + rates;
    end
    avgRates = avgRates / numValues;
    
    if plotOn
        figure
        hist(vals,50)
        set(gca,'fontsize',14,'fontweight','bold')
        xlabel('s_{ML}','fontsize',16)
        ylabel('p(s_{ML})','fontsize',16)
        title(['\mu = ' num2str(mean(vals)) ', \sigma = ' num2str(std(vals))],'fontsize',18)
    end