function [binTimes,rates] = calculateWindowedFiringRates(times,spikes,binSize,numPoints)

    %times,spikes -> outputs from generateSpikingData
    %binSize -> size of firing rate window (in seconds)
    %numPoints -> number of windows to evaluate on the whole range of times

    minTime = min(times);
    maxTime = max(times);
    
    binTimes = linspace(minTime+binSize/2,maxTime+binSize/2,numPoints);
    rates = zeros(size(binTimes));
    for i=1:length(binTimes)
        t = times >= binTimes(i) - binSize/2 & times < binTimes(i) + binSize/2;
        rates(i) = sum(spikes(t))/binSize;
    end
    
    plot(binTimes,rates,'k-','linewidth',1)
    xlabel('Time (s)')
    ylabel('Firing Rate (s^{-1})')
    set(gca,'fontsize',14,'fontweight','bold')
    xlim([minTime maxTime])