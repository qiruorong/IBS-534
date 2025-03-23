function [times,spikes] = generateSpikingData_angle(angle,simulationTime,dt)
    
    %angle -> angle (in radians) of the stimulus

    %time to simulate
    if nargin < 2 || isempty(simulationTime)
        simulationTime = 5;
    end
    
    % Time-step in sec
    if nargin < 3 || isempty(dt)
        dt = .001;
    end
    
    %vector of simulation times
    times = 0:dt:simulationTime;

    rate = 15*cos(angle - pi/3) + 20 + zeros(size(times));
    
    spikes = alt_poissrnd(rate*dt);
