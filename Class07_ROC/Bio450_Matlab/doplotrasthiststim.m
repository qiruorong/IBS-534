function [obj,rastylimits,binvector,spiketrains] = doplotrasthiststim(clusterstruct,stimonset,stimoffset,varargin);
% OBJ = DOPLOTRASTHISTSTIM(CLUSTERSTRUCT, STIMULUS, VARARGIN)
% Plots a combined graph of spike rasters, psth histogram, and the
% stimulus periods, pooling together the results for the specified SGI indices.
%
% CLUSTERSTRUCT = structure containing trials of reponses
% STIMONSET = row vector of onset times for the stimuli, in ms
% STIMOFFSET = row vector of offset times (aligned to the STIMONSET vector)s
%
% Should not be used in the case when an alignment parameter, ALIGN,
% is passed that is NOT a scalar (not currently implemented anyways).
%
% Can accomodate the case where there are complicated combinations of
% the stimuli.  For example, when the stimuli are streamed from disk, and
% repeated within the same presentation.  All stimuli used for a single 
% SGI index should be included in STIMULUS.  Moreover, the stimulus does
% not necessarily have to begin at the beginning of the trial.
%
% If a file name is specified for the stimulus, make sure to include as
% VARARGIN options the 'offset' and 'maxread' variables.
%
% The order of the rasters is in the same order as specified by SGIINDEX.
% If this is not specified, it will be increasing SGI order.

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Written by R. Liu <liu@phy.ucsf.edu>
% Last revised: 2001.02.08 (RL)
% Called by: 
% Scripts used: assignopts,psttrialhisttimes,plotxtimeyraster,loadsound
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

% Check that all trials are the same length.
if length(unique([clusterstruct.trials.triallength]))>1
    error(errormsg(40));
else
    triallength = clusterstruct.trials(1).triallength;
end;	

% Default arguments for psttrialhisttimes
align    = 0;                           % alignment time
interval = [0 triallength];             % response window
binwidth = 1;                           % ms per bin
sgiindex = unique([clusterstruct.trials.SGI]);
% Default argument for loadsound
samplerate = 250000;
group = 0;
bincolor = [.5 .5 .5];
stimpos = 'mid';  % 'mid' or 'top'
stimcolor = 'r';
spontcolor = 'c';
groupcolor = 'k';

otheropts = assignopts({'stimpos','align','interval','smoothbin','bincolor','stimcolor','spontcolor',...
        'groupcolor','binwidth','sgiindex','group','samplerate','axesh','spontwindow','maxrate'},varargin{:});

[spiketrains,binvector,spiketimes,trialselect] = psttrialhisttimes(clusterstruct,...
    'align',align,'interval',interval,'binwidth',binwidth,...
    'sgiindex',sgiindex);
spiketimes_sgiorder = [clusterstruct.trials(trialselect).SGI];

if exist('spontwindow','var')
    [q,cntbins] = spkcntdistrib(spiketrains,binvector,spontwindow);
    for j = 1:size(spiketrains,2)
        [p,cntbins] = spkcntdistrib(spiketrains,[1:size(spiketrains,2)],[j,j]);
        kldist(j) = kldistance(p,q);
    end
end
    
% Convert binned spike counts to rates.
spiketrains = mean(spiketrains) / binwidth * 1000;

if ~exist('axesh','var')
    figh = figure;
else
    axes(axesh);
    hold on
end


% Plot the histogram and extract the histogram ylimits.  Might want 
% to smooth the binned histogram instead of just doing a bar plot here,
% but that is a fine point.
if exist('spontwindow','var')
    [obj1,h1,h2] = plotyy(binvector,spiketrains,binvector,kldist,'bar','plot');
    obj1 = obj1';
    klylimits = get(obj1(2),'Ylim');
%     set(h1,'Color',bincolor);
    set(h2,'Color',spontcolor);
else
    obj1 = bar(binvector,spiketrains);
    set(obj1,'FaceColor',bincolor);
end
if exist('maxrate','var')
    set(gca,'YLim',[0,maxrate]);
end

hold on
histylimits = get(gca, 'YLim');

if exist('smoothbin','var')
    smooth = [-smoothbin(2):1:smoothbin(2)];
    smooth = exp(-(smooth/smoothbin(1)).^2);
    smooth = smooth / sum(smooth);
    spiketrains_smooth = conv(spiketrains,smooth);
    spiketrains_smooth = spiketrains_smooth(smoothbin(2)+1:end-smoothbin(2));
    obj1_sm = plot(binvector,spiketrains_smooth,'r');
    obj1 = [obj1;obj1_sm];
end


% Determine the desired ylimits for the whole plot.
histyrange  = diff(histylimits);
midhist = histylimits(1)+histyrange/2;
rastyrange  = histyrange; % 10/10 of histogram height for rasters
stimyrange  = histyrange/10; % 1/10 of histogram height for stimulus
totylimits  = [histylimits(1),histylimits(2)+stimyrange+rastyrange];
switch stimpos
    case 'mid',
        rastylimits = [histylimits(2)+stimyrange, histylimits(2)+stimyrange+rastyrange];
        stimylimits = [histylimits(2), histylimits(2)+stimyrange];
    case 'top',
        rastylimits = [histylimits(2), histylimits(2)+rastyrange];
        stimylimits = [rastylimits(2), rastylimits(2)+stimyrange];
end



% Plot the rasters.
% Reorder the spiketimes matrix so that the order is the same as in
% SGIINDEX.  Note that SPIKETIMES has a separate row for each trial with
% the same SGI index.  Thus the length of TRIALSELECT is equal to the
% number of trials, not SGI indices.
temp = spiketimes;
temp_order = spiketimes_sgiorder;
triali = 1;
for k = 1:length(sgiindex)
    ind = find(spiketimes_sgiorder==sgiindex(k));
    temp(triali:triali+length(ind)-1,:) = spiketimes(ind,:);
    temp_order(triali:triali+length(ind)-1) = sgiindex(k);
    triali = triali + length(ind);
end
spiketimes = temp;
spiketimes_sgiorder = temp_order;

if group
    obj2 = plotxtimeyraster3(spiketimes,0,'rastylimits',rastylimits,...
        'groupi',spiketimes_sgiorder,'groupcolor',groupcolor,otheropts{:});
else
    obj2 = plotxtimeyraster3(spiketimes,0,'rastylimits',rastylimits,'Color',groupcolor);
end

obj3 = line([stimonset;stimoffset],...
    repmat(stimylimits(1)+stimyrange/2,2,length(stimonset)),...
    'Linewidth',2,'Color',stimcolor);

% Fix the appearance of the figure
% Set only to the range of response desired
set(gca, 'XLim', interval);
% Reset the ylimits for the plot to show raster, histogram, stimulus 
set(gca, 'YLim', totylimits);

if exist('spontwindow','var')
    klyrange  = diff(klylimits);
    totklylimits  = [klylimits(1),klylimits(2)+klyrange];
    % Reset the ylimits for the kldistance plot (axes is in obj1(2)) 
    set(obj1(2), 'XLim', interval);
    set(obj1(2), 'YLim', totklylimits);
    line([1,1]*spontwindow(1),totylimits,'Color',spontcolor);
    line([1,1]*spontwindow(2),totylimits,'Color',spontcolor);

end

% Fix yaxis labels using manual XTickLabelMode, so that ticks are
% shown for 0, max(binvector), and some fractions of the max for
% histogram.

% Set the YTicks so that there is a tick
% at the bottom, middle and top of the pst histogram.
set(gca,'YTick',[histylimits(1),...
        histylimits(1)+histyrange/2,histylimits(2)]);
set(gca,'YTickLabel',{'0/s',sprintf('%3g/s',midhist),...
        sprintf('%3g/s',histylimits(2))});

xlabel('Time (ms)');
title([clusterstruct.animal,'.',...
        clusterstruct.exptdate,...
        ', ',clusterstruct.dataname,...
        ', LC',num2str(clusterstruct.localcluster),...
        ', SGI: ',num2str(sgiindex)],'FontSize',8,...
    'Interpreter','none');

obj = [obj1;obj2;obj3];