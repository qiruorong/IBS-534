function [spiketrains, binvector,spiketimes,trialselect] = ...
   psttrialhisttimes(clusterstruct, varargin)
% [SPIKETRAINS, BINVECTOR, SPIKETIMES, TRIALSELECT] = 
%   PSTTRIALHISTTIMES(CLUSTERSTRUCT, VARARGIN)
% Combines the jobs of PSTHTRIALHIST and PSTHTRIALTIMES.  See these
% functions for details.
%
% The order of the trials is the same as appears in CLUSTERSTRUCT -- thus
% if the  order is different from numerically increasing SGI's (as happens
% with a sequence file), the order of the rows should be rearranged using
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
binwidth = 1;                           % ms per bin
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
binvector = [interval(1)+binwidth/2:binwidth:interval(2)-binwidth/2] - align;
nbins     = length(binvector);

spiketrains = zeros(ntrials, nbins);
% Initialize a matrix with ntrial rows and maximum-possible-number-
% of-spikes columns
spiketimes = zeros(ntrials,clusterstruct.maxtrialspk);
spiketimes(:,:) = NaN;

for t = 1:ntrials
   spikes      = clusterstruct.trials(trialselect(t)).spiketimes;
   spikes = spikes(find((spikes>=interval(1))&(spikes<=interval(2)))); 
   alignspikes = spikes - align;
   
   if ~isempty(alignspikes)
      spiketimes(t,1:length(alignspikes)) = alignspikes;
      if nbins==1
         spiketrains(t,:) = hist(alignspikes, 1);
      else
         spiketrains(t,:) = hist(alignspikes, binvector);
      end;
   end;
end;



