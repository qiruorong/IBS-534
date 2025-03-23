%% Construct time-varying rates

% Timing
t0 = 0; % start time in ms
stimt = 200;
t1 = 10000; % end time in ms
tbin = 0.1; % timebin size in ms
t = [t0:tbin:t1];

%%
% Use this section to simulate a time varying (inhomogeneous) rate function
% To use the same code to simulate a constant (homogeneous) rate function,
% set the spkratepk1* values to the same value as bkgpk1*.

% Stimulus 1 response
% Transient portion
spkratepkt = 20; % spikes/sec
spkratepkt = spkratepkt / 1000; % spikes/ms
bkgpkt     = 20; % spikes/sec of background firing
bkgpkt     = bkgpkt / 1000; % spikes/ms
latencypkt = stimt; % latency to pk in ms
pkwidtht   = 5; % decay time of pk in ms

% Sustain portion
spkratepks = 0; % spikes/sec
spkratepks = spkratepks / 1000; % spikes/ms
bkgpks     = 0; % spikes/sec of background firing
bkgpks     = bkgpks / 1000; % spikes/ms
latencypks = stimt + 50; % latency to pk in ms
pkwidths   = 30; % decay time of pk in ms

rates = alphacubic(t,spkratepkt,pkwidtht,bkgpkt,latencypkt) + ...
    alphacubic(t,spkratepks,pkwidths,bkgpks,latencypks);


%% Construct simulated spike trains for each of these inhomogeneous rates

% Trials
ntrials = 2; % Number of trials
spktrains = zeros(ntrials, numel(t));
probspike = rand([ntrials,numel(t)]);
% Next line constructs the 2D matrix of ntrials rows x timebins with a 1 in
% each timebin where a spike occurs
spktrains(probspike<=tbin*repmat(rates,ntrials,1)) = 1;
% Next line converts the matrix into a structure of spike times that can be
% used conveniently with other functions
clusterstruct = spktrains2times(spktrains,t);


%%
% Plot the inhomogeneous rate and trial-derived PSTH
smoothbins = 100; % for ms: smoothbins*tbin

figure
psth = 1000*smooth(sum(spktrains)./tbin./ntrials,smoothbins);  % In spks/sec
plot(t,psth,'r');
hold on
plot(t,rates*1000,'b'); % in spks/sec
xlabel('Times (ms)');
ylabel('Spike rate (spks/sec)');
legend('PSTH','Inhomog Rate')

%%
% Plot the ISI distribution
isilimits = [0 100]; % in ms
binwidth  = 1; % in ms
interval  = [t0,t1]; % Time bin for spikes
% interval  = [stimt,t1]; % Time bin for spikes
% ISPIKEI returns the trial-by-trial interspike interval distributions as a
% matrix having each trial as a COLUMN, and each interspk interval bin as a
% row (ISIHIST).  ISIBINS returns the interspk interval bins
[isihist,isibins,isilist] = ispikei(clusterstruct, binwidth, isilimits, 'interval', interval);

figure
plot(isibins,sum(isihist,2)./sum(sum(isihist)));
set(gca,'xlim',isilimits);
% Choose which of the next two lines to comment out/in to plot the
% distribution on a log or linear y-scale
set(gca,'yscale','log');
% set(gca,'yscale','linear');
xlabel('Interspike Interval (ms)');
ylabel('Percentage of intervals');
% Compute the coefficient of variation of the ISI distribution
cv = std(isilist)/mean(isilist);
title(['Mean ISI = ',num2str(mean(isilist),'%3.2f'),'; Stdev ISI = ',num2str(std(isilist),'%3.2f'),...
    '; CV = ',num2str(cv,'%3.2f')])

%% 
% Plot the count distribution
countbins = [0:1:100]; % in spikes
interval  = [t0,t1]; % Time bin for spikes
% interval  = [stimt,stimt+200]; % Time bin for spikes
[spkcnt] =  psttrialhist(clusterstruct,'interval',interval,'binwidth',[]);

figure
counthist = hist(spkcnt,countbins);
bar(countbins,counthist);
set(gca,'xlim',[countbins(1),countbins(end)]);
xlabel('Number of spikes');
ylabel('Percentage of trials');
% Compute the Fano factor
fano = var(spkcnt)/mean(spkcnt);
title(['Mean Spk Cnt = ',num2str(mean(spkcnt),'%3.2f'),'; Var Spk Cnt = ',num2str(var(spkcnt),'%3.2f'),...
    '; Fano = ',num2str(fano,'%3.2f')])

