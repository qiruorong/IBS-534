function STA = calculateSpikeTriggeredAverage(time,stimulus,spikeTimes,averagingWindow)

    %STA -> spike triggered average
    
    %time -> time course of stimulus
    %stimulus -> stimulus time series
    %spikeTimes -> timings of spikes
    %averagingWindow -> half-window size to compute STA
    
    s = size(stimulus);
    if s(1) > s(2)
        stimulus = stimulus';
    end
    
    if nargin < 4 || isempty(averagingWindow)
        averagingWindow = 100;
    end
    
    dt = time(2) - time(1);
    N = length(spikeTimes);
    L = length(stimulus);
    STA = zeros(1,2*averagingWindow+1);

    num = N;
    for i=1:N
        
        [~,idx] = min(abs(time - spikeTimes(i)));
        
        q = (-averagingWindow:averagingWindow) + idx;
        
        if min(q) > 0 && max(q) <= L            
            STA = STA + stimulus(q);
        else
            num = num - 1;
        end
        
    end
    
    STA = STA / num;
    
    plot((-averagingWindow:averagingWindow)*dt,STA,'k-','linewidth',2)
    q = ylim;
    hold on
    plot([0 0],q,'r--','linewidth',1)
    xlabel('Time (s)')
    ylabel('Spike Triggered Average')
    set(gca,'fontsize',16,'fontweight','bold')
    