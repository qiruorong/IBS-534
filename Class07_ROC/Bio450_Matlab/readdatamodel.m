% Load the real data 
load realdata01.mat

%%
% Choose which of the data sets you want to work with by commenting out the
% others
clusterstruct = clusterstruct_resp1;
% clusterstruct = clusterstruct_resp2;
% clusterstruct = clusterstruct_spont;

ntrials = numel(clusterstruct.trials);

% Timing
tbin = 0.1; % timebin size in ms
t0 = 0;
t1 = clusterstruct.trials(1).triallength;
stimt = clusterstruct.trials(1).stimparams(2);

[spktrains,t] =  psttrialhist(clusterstruct,'binwidth',tbin);

