function rates = calculateGaussianWindowedFiringRates(times,spikes,sigma)

    %times,spikes -> outputs from generateSpikingData
    %sigma -> size of firing rate smoothing window (in seconds)

    minTime = min(times);
    maxTime = max(times);
    
    w = median(times);
    g = exp(-.5*(times - w).^2/sigma^2)/sqrt(2*pi*sigma^2);
    rates = ifft(fft(spikes).*conj(fft(g)));
        
    plot(times,rates,'k-','linewidth',1)
    xlabel('Time (s)')
    ylabel('Firing Rate (s^{-1})')
    set(gca,'fontsize',14,'fontweight','bold')
    xlim([minTime maxTime])