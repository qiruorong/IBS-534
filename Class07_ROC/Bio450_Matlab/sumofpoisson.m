% In this script you'll simulate two poisson processes, add them together,
% and determine the properties of the resulting distribution.

%% General variables
maxplot_count = 20;         % Max bin for plotting count histograms
num_trials = 50;         % CHANGE HERE TO CHANGE THE NUMBER OF TRIALS
countbins = [0:1:maxplot_count];

%% Process variables
mean_count1 = 5;        % CHANGE HERE TO CHANGE THE MEAN FOR PROCESS 1
mean_count2 = 8;        % CHANGE HERE TO CHANGE THE MEAN FOR PROCESS 2

%% RUN THESE 3 LINES TO SIMULATE THE POISSON PROCESSES AND THEIR SUM
process1 = poissrnd(mean_count1,1,num_trials); % 1 row x num_trials column vector of simulated counts
process2 = poissrnd(mean_count2,1,num_trials); % 1 row x num_trials column vector of simulated counts
processsum = process1 + process2; % adds the counts from the 2 processes together, element-by-element

%%
% RUN THESE NEXT 8 LINES TO PLOT THE COUNT DISTRIBUTION FOR A PROCESS
process = process1;     % CHANGE HERE TO PLOT A DIFFERENT PROCESS, E.G. PROCESS1 OR PROCESS2
n = hist(process,countbins);
n = n/sum(n);
figure
bar(countbins,n)
set(gca,'xlim',[0 maxplot_count]);
xlabel('Count');
ylabel('Frequency of occurrence');
title(['Mean: ',num2str(mean(process),'%3.2f'),'; Var: ',num2str(var(process),'%3.2f')]);
