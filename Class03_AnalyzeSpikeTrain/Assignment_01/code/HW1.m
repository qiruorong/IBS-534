%%%%%%%%%% Part I %%%%%%%%%%
%% Q1
averagingWindow = 100;
N = [100, 500, 1000, 5000, 10000, 25000, 53601];
STA_curves = struct(); % this is suggested by AI to create a structure to save all curves
for i = N
    figure;
    spikeTimes = H1_spikes(randperm(i),:);
    fieldName = sprintf('STA_N_%d', i); 
    STA = calculateSpikeTriggeredAverage(H1_times,H1_stimulusData,spikeTimes,averagingWindow);
    STA_curves.(fieldName) = STA;
end
save('HW1_1_STA.mat', 'STA_curves');

%% Q3
STA_53601 = STA_curves.STA_N_53601;
d_values = zeros(1, length(N));
for idx = 1:length(N)
    k = N(idx);
    fieldName = sprintf('STA_N_%d', k);
    STA_k = STA_curves.(fieldName); 
    d_values(idx) = sqrt(sum((STA_k - STA_53601).^2));
end
figure;
loglog(N, d_values, '-o');
xlabel('Number of Spikes (k)');
ylabel('d(k)');


%%%%%%%% Part II %%%%%%%%%
%% Q1
dt = 0.001;
duration = 1;
convolutionOutput = convolveDataWithSTA(H1_stimulusData, STA, dt);
convolutionFirstSecond = convolutionOutput(1:(duration/dt)); % first second

figure;
plot(time_points, convolutionFirstSecond);
xlabel('Time (s)');
ylabel('Convolution Output x(t)');

%% Q2
plotSpikesOnData(H1_times, convolutionOutput, H1_spikes, 0, 1);
disp(length(convolutionOutput));

%% Q3
hist(convolutionOutput,20);
xlabel('Bins');
ylabel('Convolution Output x(t)');

[convData, binEdge] = histcounts(convolutionOutput, 20);
histoData.convData = convData; 
histoData.binEdge = binEdge; 
save('convolutionHistogram.mat', 'histoData');

%% Q4
numBins = 20;
[binLocations, pSpike, numSpikes] = findSpikingProbabilitiesFromConvolution(convolutionOutput, H1_spikes, numBins);

