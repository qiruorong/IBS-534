function [spiketrains, binvector, trialsgi] = psttrialhist(clusterstruct, varargin)
% [SPIKETRAINS, BINVECTOR, TRIALSGI] = PSTTRIALHIST(CLUSTERSTRUCT, VARARGIN)
% PSTTRIALHIST  Make matrix of trial-by-trial PSTHs.  CLUSTERSTRUCT
% is the structure of data for a single cluster.  VARARGIN options are:
% 'align'    - alignment time in ms rel. to start of trial (default 0)
% 'interval' - analysis time window in ms in abs time ([start stop])
%              (default [0 triallength])
% 'binwidth' - bin width in ms per bin (default 1)
% 'sgiindex' - desired SigGen indices of stimuli (default all unique sgi)
% Default values of variable arguments are: entire interval, 1-ms bins,
% all SGI values.  PSTTRIALHIST returns SPIKETRAINS, a matrix in which 
% each row is a trial and each column is a time bin, and BINVECTOR,
% a vector corresponding to time points at the center of each bin
% (as determined by 'interval' and 'binwidth').

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Written by J. Linden <linden@phy.ucsf.edu>,
% Last revised: 1999.12.01
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
addlastbin = false;
sgiindex = unique([clusterstruct.trials.SGI]);

% Assign non-default values, if they exist.
assign(varargin{:});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Select out trials which fit requirements specified.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialize the trial selection vector to be those trials
% with specified SGI indices.
trialselect = find(ismember([clusterstruct.trials.SGI], sgiindex));
trialsgi = [clusterstruct.trials(trialselect).SGI];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fill in spike train matrix.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ntrials   = length(trialselect);
if ~addlastbin
    binvector = interval(1)+binwidth/2:binwidth:interval(2)-binwidth/2;
else
    binvector = interval(1)+binwidth/2:binwidth:interval(2)+binwidth/2;
end
if isempty(binvector)
    % Length of the interval is shorter than the binwidth, so just set a
    % single bin to the middle of the interval.  The algorithm below still
    % only counts those spikes within the interval that fall in this single
    % bin.
    binvector = interval(1) + diff(interval)/2;
end
nbins     = length(binvector);

spiketrains = zeros(ntrials, nbins);
binvector = binvector - align;
for t = 1:ntrials
   spikes      = clusterstruct.trials(trialselect(t)).spiketimes;
   spikes = spikes(find((spikes>interval(1))&(spikes<interval(2)))); 
   alignspikes = spikes - align;
   
   if ~isempty(alignspikes)
      if nbins==1
         spiketrains(t,:) = hist(alignspikes, 1);
      else
         spiketrains(t,:) = hist(alignspikes, binvector);
      end;
   end;
end;



