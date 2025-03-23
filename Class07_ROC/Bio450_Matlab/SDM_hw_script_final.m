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
sgi1 = 15; % pup call
sgi2 = 18; % pup call
sgi3 = 24; % adult call

%% Plot the rasters and PSTH for a specific SGI index (sgi#)
doplotrasthiststim(clusterstruct,stimt,stimt+duration,'interval',[t0 t1],'sgiindex',sgi1,'binwidth',binwidth,'maxrate',maxrate)

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
st1 = st1(find((st1>=interval(1))&(st1<=interval(2))));
disp(['Spiketimes trial a (ms): ']);
st1
st2 = clusterstruct.trials(trialb_i(targettrialb)).spiketimes;
st2 = st2(find((st2>=interval(1))&(st2<=interval(2))));
disp(['Spiketimes trial b (ms): ']);
st2
d2trial_single = d2_spikes(st1,st2,targettc);
disp(['Spike distance: ',num2str(d2trial_single,'%3.2f')]);

%% Compute spike distance metric for all trials of the specified stimulus SGIs
% Calculate spike distance metric for all trials between the three stimuli 
% indicated in sgis = [sgi1, sgi2, sgi3]. Plots histogram of distances
% between trials for sgi1 vs. sgi2 (blue), trials for sgi1 vs. sgi3 (red)
% and trials sgi2 vs. sgi3. Cycles through different decay time constants
% (tc) defined above. 

sgis = [sgi1,sgi2,sgi3];
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
                    st1 = st1(find((st1>=interval(1))&(st1<=interval(2))));
                    st2 = clusterstruct.trials(trialb_i(targettrialb)).spiketimes;
                    st2 = st2(find((st2>=interval(1))&(st2<=interval(2))));
%                     st1 = clusterstruct.trials(triala_i(targettriala)).spiketimes;
%                     st2 = clusterstruct.trials(trialb_i(targettrialb)).spiketimes;
                    d2trial(targettriala,targettrialb,i,j,k) = d2_spikes(st1,st2,tc(k));
                    disp(['Spike distance: ',num2str(d2trial(targettriala,targettrialb,i,j,k),'%.4f')]);
                end
            end
            tempmat = reshape(d2trial(:,:,i,j,k),1,numel(d2trial(:,:,i,j,k)));
            tempmat = tempmat(find(tempmat>d2floor));
            disp(['Different SGI',int2str(sgis(i)),' vs SGI',int2str(sgis(j)),' d2: ',num2str(median(tempmat),'%.4f')]);
            ndiff = hist(tempmat,d2bins);
            ndiff = ndiff / sum(ndiff);
            pdf_sgi(k,:,i,j) = ndiff; 
        end
    end
    subplot(numel(tc),1,k);
    plot(d2bins,pdf_sgi(k,:,1,2),'b'); % plot the histogram for distances between sgi1 and sgi2
    hold on
    plot(d2bins,pdf_sgi(k,:,1,3),'r'); % plot the histogram for distances between sgi1 and sgi3
    plot(d2bins,pdf_sgi(k,:,2,3),'k'); % plot the histogram for distances between sgi2 and sgi3
    axis([d2bins(1) d2bins(end) get(gca,'ylim')]);
end

%% ROC curves for discriminating same from different stimulus trials
event_min = 0;
event_max = 40;
x = d2bins;

k = 4; % index into time constant array tc (see second cell)
% Set sgia, sgib, sgic appropriately for the distance metric distributions
% you want to compare
sgia = 1; % set to 1 for first element of sgis (see above cell)
sgib = 2; % set to 2 for second element of sgis (see above cell)
sgic = 3; % set to 3 for third element of sgis (see above cell)
pdf_x_1 = pdf_sgi(k,:,sgia,sgib); % probability distribution of distances between trials of sgia and sgib
pdf_x_2 = pdf_sgi(k,:,sgia,sgic); % probability distribution of distances between trials of sgia and sgic

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

