function rates = calculateCausalFilteredFiringRates(times,spikes,alpha)

    %times,spikes -> outputs from generateSpikingData
    %alpha -> size of firing rate smoothing window (in seconds^-1)

    
    minTime = min(times);
    maxTime = max(times);
    
    w = median(times);
    h = alpha^2*(times - w).*exp(-alpha.*(times - w));
    h(h<0) = 0;
    rates = ifft(fft(spikes).*conj(fft(h)));
        
    plot(times,rates,'k-','linewidth',1)
    xlabel('Time (s)')
    ylabel('Firing Rate (s^{-1})')
    set(gca,'fontsize',14,'fontweight','bold')
    xlim([minTime maxTime])