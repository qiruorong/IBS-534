function [spiketimes,trialselect] = psttrialtimes(clusterstruct, varargin)
% [SPIKETIMES] = PSTTRIALTIMES(CLUSTERSTRUCT, VARARGIN)
% Make matrix of trial-by-trial spike times.  CLUSTERSTRUCT
% is the structure of data for a single cluster.  VARARGIN options are:
% 'align'    - alignment time in ms rel. to start of trial (default 0)
% 'interval' - analysis time window in ms rel. to align ([start stop])
%              (default [0 triallength])
% 'sgiindex' - desired SigGen indices of stimuli (default all unique sgi)
% Default values of variable arguments are: entire interval, 
% all SGI values.  PSTTRIALTIMES returns SPIKETIMES, a matrix in 
% which each row is a trial and each column is a spike time.  The number
% of columns equals the maximum number of spikes for any of the trials
% in CLUSTERSTRUCT, as specified by CLUSTERSTRUCT.MAXTRIALSPK.  The order
% of the trials is the same as appears in CLUSTERSTRUCT -- thus if the 
% order is different from numerically increasing SGI's (as happens with
% a sequence file), the order of the rows should be rearranged using
% MATCHINDEX to list the trials in increasing SGI index order.

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Written by R. Liu <liu@phy.ucsf.edu>,
% Last revised: 2000.04.10
% Called by: tuning
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
% Fill in spike train matrix.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ntrials   = length(trialselect);
% Initialize a matrix with ntrial rows and maximum-possible-number-
% of-spikes columns
spiketimes = zeros(ntrials,clusterstruct.maxtrialspk);
spiketimes(:,:) = NaN;

for t = 1:ntrials
   spikes      = clusterstruct.trials(trialselect(t)).spiketimes;
   spikes = spikes((spikes>interval(1))&(spikes<interval(2))); 
   alignspikes = spikes - align;
   
   if ~isempty(alignspikes)
      spiketimes(t,1:length(alignspikes)) = alignspikes;
   end;
end;



