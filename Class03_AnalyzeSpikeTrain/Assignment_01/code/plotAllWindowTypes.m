function plotAllWindowTypes(times,spikes,windowSize)

    figure
    
    subplot(4,1,1)
    calculateFiringRates(times,spikes,windowSize);
    title(['Binned Firing Rates (\Deltat = ' num2str(windowSize) ')'])
    
    subplot(4,1,2)
    calculateWindowedFiringRates(times,spikes,windowSize,1000);
    title('Windowed Firing Rates')
    
    subplot(4,1,3)
    calculateGaussianWindowedFiringRates(times,spikes,windowSize/2);
    title('Gaussian-Windowed Firing Rates')
    
    subplot(4,1,4)
    calculateCausalFilteredFiringRates(times,spikes,2/windowSize);
    title('Causally-Windowed Firing Rates')