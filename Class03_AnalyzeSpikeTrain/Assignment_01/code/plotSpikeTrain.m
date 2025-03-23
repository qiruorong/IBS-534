function plotSpikeTrain(times,spikes)

    q = max(spikes);
    for j=1:q
        idx = find(spikes == j);
        for i=1:length(idx)
            plot(times([idx(i) idx(i)]),[-1 1],'k-','linewidth',j)
            hold on
        end
    end
    
    
    xlim([min(times) max(times)])
    ylim([-2 2])
    axis off