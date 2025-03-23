function [binLocations,pSpike,numSpikes] = findSpikingProbabilitiesFromConvolution(convData,spikes,numBins,dt)

    if nargin < 3 || isempty(numBins)
        numBins = 20;
    end
    
    if nargin < 4 || isempty(dt)
        dt = .001;
    end
    
    
    
    z = round(spikes/dt);
    
    numSpikes = zeros(numBins,1);
    [N,edges,~] = histcounts(convData,numBins);
    for i=1:numBins
        if i < numBins
            numSpikes(i) = sum(convData(z) >= edges(i) & convData(z) < edges(i+1));
        else
            numSpikes(i) = sum(convData(z) >= edges(i) & convData(z) <= edges(i+1));
        end
    end
    binLocations = .5*(edges(2:end) + edges(1:end-1));
    pSpike = numSpikes'./N;
    pSpike(N == 0) = 0;
    
    figure
    subplot(1,2,1)
    bar(binLocations,numSpikes,'k')
    xlabel('\chi')
    ylabel('p(\chi)')
    set(gca,'fontsize',14,'fontweight','bold')
    xlim([edges(1) edges(end)])
    
    subplot(1,2,2)
    plot(binLocations,pSpike,'ks-','markerfacecolor','k','linewidth',2)
    
    xlabel('\chi')
    ylabel('p(spike | \chi)')
    set(gca,'fontsize',14,'fontweight','bold')
    xlim([edges(1) edges(end)])