load resp_10846

%% Define variables
t0 = -200;  % trial start time
t1 = t0 + clusterstruct.trials(1).triallength; % trial end time
stimt = clusterstruct.trials(1).stimparams(4); % start of stimulus
duration = 65; % duration of stimulus
windowt = 300;
interval = [stimt windowt]; % interval to use for analysis
maxrate = 50;
binwidth = 10; % binwidth to use for plotting
SGI = unique([clusterstruct.trials.SGI]);
d2bins = [0:.5:80];  % bins for distance metric
d2floor = 1e-10;
tc = [8,16,32,64,128,256]; % decay times for the distance metric (ms)

% SGI is jargon that indicates a specific sound stimulus in the data file
sgi1 = 15;
sgi2 = 18;
sgi3 = 24;

%% Plot the rasters and PSTH for a specific SGI index (sgi#)
doplotrasthiststim(clusterstruct,stimt,stimt+duration,'interval',[t0 t1],'sgiindex',sgi1,'binwidth',binwidth,'maxrate',maxrate)

doplotrasthiststim(clusterstruct,stimt,stimt+duration,'interval',[t0 t1],'sgiindex',sgi2,'binwidth',binwidth,'maxrate',maxrate)

doplotrasthiststim(clusterstruct,stimt,stimt+duration,'interval',[t0 t1],'sgiindex',sgi3,'binwidth',binwidth,'maxrate',maxrate)

%% Return the number of spikes within a specified interval for each trial
spkcount1 = psttrialhist(clusterstruct,'interval',interval,'binwidth',interval,'sgiindex',sgi1);
spkcount2 = psttrialhist(clusterstruct,'interval',interval,'binwidth',interval,'sgiindex',sgi2);
spkcount3 = psttrialhist(clusterstruct,'interval',interval,'binwidth',interval,'sgiindex',sgi3);

%% Calculate statistics on spike counts
mnspkcount = mean(spkcount1);
medianspkcount = median(spkcount1);
stdspkcount = std(spkcount1);

%% Hypothesis test: are the mean spike counts statistically different?
% Use help ttest2 to read up on the t-test
[h,p] = ttest2(spkcount1,spkcount2)

%% Compute spike distance metric for specific trials
sgia = sgi1; % sets which stimulus to compare
sgib = sgi2; % sets which stimulus to compare
triala_i = find([clusterstruct.trials.SGI]==sgia); % finds which trials are for stimulus a
trialb_i = find([clusterstruct.trials.SGI]==sgib); % finds which trials are for stimulus b
targettriala = 5;  % set to a random integer between 1 and 30 trials
targettrialb = 13;  % set to a random integer between 1 and 30 trials
targettc = tc(4); % set to desired decay time for spike distance metric
st1 = clusterstruct.trials(triala_i(targettriala)).spiketimes;
disp(['Spiketimes trial a (ms): ']);
st1
st2 = clusterstruct.trials(trialb_i(targettrialb)).spiketimes;
disp(['Spiketimes trial b (ms): ']);
st2
d2trial_single = d2_spikes(st1,st2,targettc);
disp(['Spike distance: ',num2str(d2trial_single,'%3.2f')]);

%% Compute spike distance metric for all trials of the specified stimulus SGIs
% Calculate spike distance metric for all trials between two stimuli (sgia
% and sgib), and plot histogram of distances between trials for the same
% stimulus (blue) and trials for different stimuli (red).  Cycles through
% different decay time constants (tc) defined above, and plots the result
% in subplots. Also prints the mean distance for same and different stimuli
% in the corner of each subplot.

sgis = [sgi1,sgi2];
figure
for k = 1:length(tc)
    for i = 1:length(sgis)
        for j = i:length(sgis)
            sgia = sgis(i); % sets which stimulus to compare
            sgib = sgis(j); % sets which stimulus to compare
            triala_i = find([clusterstruct.trials.SGI]==sgia); % finds which trials are for stimulus a
            trialb_i = find([clusterstruct.trials.SGI]==sgib); % finds which trials are for stimulus b
            for targettriala = 1:length(triala_i)
                for targettrialb = 1:length(trialb_i)
                    st1 = clusterstruct.trials(triala_i(targettriala)).spiketimes;
                    st2 = clusterstruct.trials(trialb_i(targettrialb)).spiketimes;
                    d2trial(targettriala,targettrialb,i,j,k) = d2_spikes(st1,st2,tc(k));
                    disp(['Spike distance: ',num2str(d2trial(targettriala,targettrialb,i,j,k),'%.4f')]);
                end
            end
        end
    end
    % For different distributions
    tempmat = reshape(d2trial(:,:,1,2,k),1,numel(d2trial(:,:,1,2,k)));
    tempmat = tempmat(find(tempmat>d2floor));
    ndiff = hist(tempmat,d2bins);
    ndiff = ndiff / sum(ndiff);
    disp(['Different SGI d2: ',num2str(median(tempmat),'%.4f')]);
 
    % For Same SGIs
    tempmat = [reshape(triu(d2trial(:,:,1,1,k)),1,numel(d2trial(:,:,1,1,k))),reshape(triu(d2trial(:,:,2,2,k)),1,numel(d2trial(:,:,2,2,k)))];
    tempmat = tempmat(find(tempmat>d2floor));
    nsame = hist(tempmat,d2bins);
    nsame = nsame / sum(nsame);
    disp(['Same SGI d2: ',num2str(median(tempmat),'%.4f')]);
    
    subplot(numel(tc),1,k);
    plot(d2bins,nsame,'b'); % plot the histogram for all same stimulus comparisons
    hold on
    plot(d2bins,ndiff,'r'); % plot the histogram for all diff stimulus comparisons
    axis([d2bins(1) d2bins(end) get(gca,'ylim')]);
    text(.9,.9,['same med: ',num2str(median([nsame]),'%.4e'),'; diff med: ',num2str(median(ndiff),'%.4e')],'HorizontalAlignment','right','VerticalAlignment','top','units','normalized');

    pdf_1(k,:) = nsame;
    pdf_2(k,:) = ndiff;

end

%% ROC curves for discriminating same from different stimulus trials
event_min = 0;
event_max = 40;

k = 6;
pdf_x_1 = pdf_1(k,:);
pdf_x_2 = pdf_2(k,:);

figure
ax(1) = subplot(2,1,1);
plot(x,pdf_x_1,'k');
hold on
plot(x,pdf_x_2,'r');
set(gca,'xlim',[event_min,event_max]);
xlabel('Events x');
ylabel('Prob Density');

% Define Likelihood Ratio (lr) as a function of x
lr = pdf_x_2./pdf_x_1;

% Plot likelihood ratio
ax(2) = subplot(2,1,2);
plot(x,log(lr));
set(gca,'xlim',[event_min,event_max]);
xlabel('Events x');
ylabel('Log Likelihood Ratio');

% Compute Ideal Observer-based ROC curve
% Set a decision criterion based on the likelihood ratio
k = 1;
events_1_k_i = find((lr<k));
events_2_k_i = find((lr>=k));
% Plot events in likelihood plot, delineated as noise or signal
axes(ax(2));
hold on
plot(x(events_1_k_i),log(lr(events_1_k_i)),'ko');
plot(x(events_2_k_i),log(lr(events_2_k_i)),'ro');

% Compute Hit and False Alarm rates given criterion
FA_rate_k = sum(pdf_x_1(events_2_k_i))
HIT_rate_k = sum(pdf_x_2(events_2_k_i))

% Cycle through different likelihood ratio criteria to generate ROC curve
k_values = [0.01:0.01:20];
FA_rate_values = zeros(1,length(k_values));
HIT_rate_values = zeros(1,length(k_values));
for j = 1:length(k_values)
    events_1_k_j = find((lr<k_values(j)));
    events_2_k_j = find((lr>=k_values(j)));
    FA_rate_values(j) = sum(pdf_x_1(events_2_k_j));
    HIT_rate_values(j) = sum(pdf_x_2(events_2_k_j));
end

% Plot ROC curve
figure
plot(FA_rate_values,HIT_rate_values,'x');
hold on
xlabel('P(S|n) - False Alarm Rate');
ylabel('P(S|s) - Hit Rate');
set(gca,'xlim',[0 1],'ylim',[0 1]);

text(0.5,0.5,['AUC=',num2str(trapz(fliplr(FA_rate_values),fliplr(HIT_rate_values)))]);

