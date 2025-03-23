function [times,spikes] = generateSpikingData_poisson(meanRate,simulationTime,dt)
    
    %maximum firing rate
    if nargin < 1 || isempty(meanRate)
        meanRate = 18;
    end

    %time to simulate
    if nargin < 2 || isempty(simulationTime)
        simulationTime = 10;
    end
    
    % Time-step in sec
    if nargin < 3 || isempty(dt)
        dt = .001;
    end
    
    %vector of simulation times
    times = 0:dt:simulationTime;

    
    rate = meanRate + zeros(size(times));
    
    spikes = alt_poissrnd(rate*dt);
