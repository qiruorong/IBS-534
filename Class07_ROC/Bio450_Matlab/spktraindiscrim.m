load realdata02.mat

%% Define variables
t0 = 0;  % trial start time
t1 = clusterstruct.trials(1).triallength; % trial end time
stimt = clusterstruct.trials(1).stimparams(2); % start of stimulus
duration = 65; % duration of stimulus
interval = [t0 t1]; % interval to use for analysis
binwidth = 5; % binwidth to use for plotting

d2bins = [0:.5:20];  % bins for distance metric
tc = [1,2,4,8,16,32,64,128]; % decay times for the distance metric (ms)
sgi1 = 8; % the 1st stimulus
sgi2 = 14; % the 2nd stimulus
sgi3 = 33; % the 3rd stimulus

%% Plot the rasters and PSTH for a specific SGI index (sgi#)
doplotrasthiststim(clusterstruct,stimt,stimt+duration,'sgiindex',sgi3,'binwidth',binwidth);

%% Return the number of spikes within a specified interval for each trial
spkcount1 = psttrialhist(clusterstruct,'interval',interval,'binwidth',interval,'sgiindex',sgi1);
spkcount2 = psttrialhist(clusterstruct,'interval',interval,'binwidth',interval,'sgiindex',sgi2);
spkcount3 = psttrialhist(clusterstruct,'interval',interval,'binwidth',interval,'sgiindex',sgi3);

%% Calculate statistics on spike counts
mnspkcount = mean(spkcount1);
stdspkcount = std(spkcount1);

%% Hypothesis test: are the mean spike counts statistically different?
% Use help ttest2 to read up on the t-test
[h,p] = ttest2(spkcount3,spkcount2)

%%
% Compute spike distance metric for specific trials
sgia = sgi1; % sets which stimulus to compare
sgib = sgi3; % sets which stimulus to compare
triala_i = find([clusterstruct.trials.SGI]==sgia); % finds which trials are for stimulus a
trialb_i = find([clusterstruct.trials.SGI]==sgib); % finds which trials are for stimulus b
targettriala = 5;  % set to a random integer between 1 and 24 trials
targettrialb = 13;  % set to a random integer between 1 and 24 trials
targettc = tc(8); % set to desired decay time for spike distance metric
disp(['Spiketimes trial a (ms): ']);
clusterstruct.trials(triala_i(targettriala)).spiketimes
disp(['Spiketimes trial b (ms): ']);
clusterstruct.trials(trialb_i(targettrialb)).spiketimes
d2trial = d2_spikes(clusterstruct.trials(triala_i(targettriala)).spiketimes,...
    clusterstruct.trials(trialb_i(targettrialb)).spiketimes,targettc);
disp(['Spike distance: ',num2str(d2trial,'%3.2f')]);

%% 
% Calculate spike distance metric for all trials between two stimuli (sgia
% and sgib), and plot histogram of distances between trials for the same
% stimulus (blue) and trials for different stimuli (red).  Cycles through
% different decay time constants (tc) defined above, and plots the result
% in subplots. Also prints the mean distance for same and different stimuli
% in the corner of each subplot, and does a t-test to check whether the
% distribution of distances is different between same and different stimulus
% trials.
%
% To change which stimuli you're comparing, set sgia and sgib
% appropriately.
sgia = sgi1;
sgib = sgi3;
figure
for i = 1:numel(tc)
    % function d2_list will return the spike distance metric for all
    % pairwise comparisons between all the trials for two stimuli (sgia and
    % sgib) as a list of distances 
    list11 = d2_list(clusterstruct,sgia,sgia,tc(i),'interval',interval);
    list22 = d2_list(clusterstruct,sgib,sgib,tc(i),'interval',interval);
    list12 = d2_list(clusterstruct,sgia,sgib,tc(i),'interval',interval);
    nsame = hist([list11,list22],d2bins);  % produces a histogram of the distances at with centers at the values specified by d2bins
    ndiff = hist([list12],d2bins);
    subplot(numel(tc),1,i);
    plot(d2bins,nsame/sum(nsame),'b'); % plot the histogram for all same stimulus comparisons
    hold on
    plot(d2bins,ndiff/sum(ndiff),'r'); % plot the histogram for all diff stimulus comparisons
    axis([d2bins(1) d2bins(end) get(gca,'ylim')]);
    text(.9,.9,['same: ',num2str(mean([list11,list22]),'%2.3f'),'; diff: ',num2str(mean(list12),'%2.3f')],'HorizontalAlignment','right','VerticalAlignment','top','units','normalized');
    [h,p] = ttest2([list11,list22],[list12])
end
