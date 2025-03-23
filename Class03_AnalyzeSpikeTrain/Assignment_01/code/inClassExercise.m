%%%%%% introduction to spike-rate smoothing %%%%%%
%% Q2
meanRate = 10;         
simulationTime = 10; 
[times, spikes] = generateSpikingData_poisson(50, 10);

% Q3
plotSpikeTrain(times,spikes);

%% Q5
% As the time window becomes larger, the firing rate curve become more
% smooth
plotAllWindowTypes(times,spikes,.01);
plotAllWindowTypes(times,spikes,.05);
plotAllWindowTypes(times,spikes,.1);
plotAllWindowTypes(times,spikes,.25);
plotAllWindowTypes(times,spikes,1);

%% Q6 inhomogeneous Poisson process
max_rate = 200;
min_rate = 100;
frequency = 1;
[times, spikes] = generateSpikingData_oscillations(max_rate,min_rate,frequency,simulationTime);
plotSpikeTrain(times,spikes);
plotAllWindowTypes(times,spikes,.01);
plotAllWindowTypes(times,spikes,.05);
plotAllWindowTypes(times,spikes,.1);
plotAllWindowTypes(times,spikes,.25);
plotAllWindowTypes(times,spikes,1);

%% Q7
% window=0.01 loos most accurate on plot 1, and rest look most accurate
% with window=0.05. This might be that binned firing rate depend on bin
% size to display temporal resolution, the smaller window, the better it at
% presenting spiking information. The rest applied window to assess firing
% rate/capture the main pattern, so a slightly larger bin would decrease
% the possibility of noise.

%% Q8
% the second line is closely next to the first line with a few miniseconds
% apart
sigma = 0.05;
alpha = 1/0.05;
gaussianRate = calculateGaussianWindowedFiringRates(times,spikes,sigma);
hold on;
causalRate = calculateCausalFilteredFiringRates(times,spikes,alpha);


%%%%%%%% Calculating a Tuning Curve %%%%%%%%
%% Q1
angles = linspace(0, 2*pi, 100);

% Q2
simulationTime = 2;            
dt = 0.001;      
averageRates = zeros(size(angles)); 

% Q3
% around 1.3 radian is the preferred angle
for i = 1:length(angles)
    angle = angles(i);
    [times, spikes] = generateSpikingData_angle(angle, simulationTime, dt); 
    averageRates(i) = sum(spikes) / simulationTime;
end
figure;
plot(angles, averageRates, 'b-', 'LineWidth', 2);
xlabel('Angle (radians)');
ylabel('Average Firing Rate (Hz)');

% Q4
% when stimulationTime is 2, 1 radian is preferred

% Q5
residual = 15*cos(angle - pi/3) - averageRates;

% Q6
simulationTimes = linspace(1,20,1);
residualSums = zeros(size(simulationTimes)); 
for i = 1:length(simulationTimes)
    simulationTime = simulationTimes(i); 
    [times, spikes] = generateSpikingData_angle(angles, simulationTime, dt);
    averageRates = sum(spikes, 2) / simulationTime;
    residual = 15 * cos(angles - pi/3) - averageRates;
    residualSums(i) = sum(residual.^2);
end
figure;
loglog(simulationTimes, residualSums, 'b-o', 'LineWidth', 2);


%%%%%%%%%% Calculating a Spike Triggered Average
%% Q2
spikeTimes = H1_spikes(1:10000,:);
averagingWindow = 100;
STA = calculateSpikeTriggeredAverage(H1_times,H1_stimulusData,spikeTimes,averagingWindow);
% Q3 
% The curve become smoother as I increase the amount of data, change
% systematically decrease in fluctuation.

%% Q4
% Here CV=2.0086, the spike looks more bursting and irregular
spikeTimes = H1_spikes(:,:);
ISI = diff(spikeTimes);
meanISI = mean(ISI); 
stdISI = std(ISI); 
CV = stdISI / meanISI;
disp(CV);



