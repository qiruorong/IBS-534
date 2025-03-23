function [isihist,isibins,timedifflist] = ispikei(clusterstruct, binwidth, isilimits, varargin)
% ISIHIST = ISPIKEI(CLUSTERSTRUCT, BINWIDTH, ISILIMITS, VARARGIN)
% Make matrix of trial-by-trial inter-spike-interval counts.  CLUSTERSTRUCT
% is the structure of data for a single cluster.  VARARGIN options are:
% 'align'    - alignment time in ms rel. to start of trial; align
%              can be a scalar or a vector; if it is a vector, it must
%              have the same number of elements as the number of trials
%              which are processed
% 'interval' - analysis time window in ms rel. to align ([start stop]);
%              if more than one interval is desired, each start/stop
%              interval should be on a new row
% 'sgiindex' - desired SigGen indices of stimuli
% Default values of variable arguments are: 0 ms alignment, entire interval, 
% all SGI values.  ISPIKEI returns ISIHIST, a 3D matrix in which 
% each row is a bin of the isi histogram, each column is a trial and each 
% page is a time interval (in the order in which the intervals were specified).
% 
% BINWIDTH is a scalar specifying the bin size in ms of the histogram of isi's.
% ISILIMITS is a 2-element vector specifying the minimum and maximum isi in ms.

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Written by R. Liu <liu@phy.ucsf.edu>,
% Last revised: 2001.06.20
% Called by: 
% Scripts used: 
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Argument checking.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check that all trials are the same length.
if length(unique([clusterstruct.trials.triallength]))>1
    error(errormsg(40));
else
    triallength = clusterstruct.trials(1).triallength;
end;	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Variable declarations, initializations, and assignments.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

isibins = [isilimits(1)+binwidth/2:binwidth:isilimits(2)-binwidth/2];
nisi = length(isibins);

% Default arguments.
align    = 0;                           % alignment time
interval = [0 triallength];             % response window
sgiindex = unique([clusterstruct.trials.SGI]);

% Assign non-default values, if they exist.
assign(varargin{:});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Select out trials which fit requirements specified.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialize the trial selection vector to be those trials
% with specified SGI indices.
trialselect = find(ismember([clusterstruct.trials.SGI], sgiindex));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Count intervals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ntrials   = length(trialselect);
ninterval = size(interval,1);     % Number of rows = number of intervals
start = interval(:,1);
stop  = interval(:,2);
if length(align) == 1
    align = repmat(align,1,ntrials);
end;

isihist = zeros(nisi,ntrials,ninterval);
timedifflist = [];
for t = 1:ntrials
    spikes = clusterstruct.trials(trialselect(t)).spiketimes - align(t);
    spikes = repmat(spikes,ninterval,1);
    if ~isempty(spikes)
        istart = repmat(start,1,size(spikes,2));
        paststartspikes  = (spikes - istart) >= 0;
        istop  = repmat(stop,1,size(spikes,2));
        beforestopspikes = (istop - spikes) >= 0;
        intervalspikes = paststartspikes & beforestopspikes;
        [i,j] = find(intervalspikes);
        if ~isempty(i)
            times = spikes(sub2ind(size(spikes),i,j));
            timediff = diff(times);
            for k = unique(i)
                m = find(i==k);
                if length(m) > 1
                    m = m(1:end-1);
                    isihist(:,t,k) = isihist(:,t,k) + hist(timediff(m),isibins)';
                    timedifflist = [timedifflist,timediff(m)];
                end
            end
        end
    end
end;