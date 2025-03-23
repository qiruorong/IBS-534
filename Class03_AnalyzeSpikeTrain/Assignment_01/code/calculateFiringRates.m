function [binTimes,rates] = calculateFiringRates(times,spikes,binSize)

    %times,spikes -> outputs from generateSpikingData
    %binSize -> size of firing rate bins (in seconds)

    minTime = min(times);
    maxTime = max(times);
    d = ceil((maxTime - minTime)/binSize)*binSize;
    maxTime = minTime + d;
    
    binTimes = minTime:binSize:maxTime;
    rates = zeros(1,length(binTimes)-1);
    for i=1:length(binTimes)-1
        t = times >= binTimes(i) & times < binTimes(i+1);
        rates(i) = sum(spikes(t))/binSize;
    end
    
    binTimes = (binTimes(1:end-1) + binTimes(2:end))/2;
    
    bar(binTimes,rates)
    xlabel('Time (s)')
    ylabel('Firing Rate (s^{-1})')
    set(gca,'fontsize',14,'fontweight','bold')