function plotSpikesOnData(times,convData,spikes,startTime,endTime)

    idx = times >= startTime & times <= endTime;
    spikeIdx = find(spikes >= startTime & spikes <= endTime);

    figure
    plot(times(idx),convData(idx),'k-','linewidth',2)
    hold on
    q = ylim;
    for i=1:length(spikeIdx)
        plot([0 0] + spikes(spikeIdx(i)),q,'r--','linewidth',1)
    end
    
    xlabel('Time (s)')
    ylabel('\chi (t)')
    
    set(gca,'fontsize',14,'fontweight','bold')