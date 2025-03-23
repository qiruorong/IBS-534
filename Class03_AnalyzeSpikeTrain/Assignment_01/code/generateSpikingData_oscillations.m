function [times,spikes] = generateSpikingData_oscillations(max_rate,min_rate,frequency,simulationTime,dt)
    
    %maximum firing rate
    if nargin < 1 || isempty(max_rate)
        max_rate = 18;
    end

    %minimum firing rate
    if nargin < 2 || isempty(min_rate)
        min_rate = 6;
    end

    %frequency of firing rate oscillations
    if nargin < 3 || isempty(frequency)
        frequency = 1;
    end

    %time to simulate
    if nargin < 4 || isempty(simulationTime)
        simulationTime = 10;
    end
    
    % Time-step in sec
    if nargin < 5 || isempty(dt)
        dt = .001;
    end
    
    %vector of simulation times
    times = 0:dt:simulationTime;

    %angular frequency
    omega = 2*pi*frequency;
    
    rate = min_rate + (max_rate - min_rate).*sin(omega*times)/2;
    
    spikes = alt_poissrnd(rate*dt);
