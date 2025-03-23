%% Q0
N = [5,10,15,20];
for i = N
    rateFunctions = drawReceptiveFields(i);
end

%% Q2
s = 1;
N = 10;
rMax = 20;
deltaT = 2;
[outputValues,avgRates] = histogramMLEstimates(s,N,rMax,deltaT);

%% Q4
sigma = pi / N;
target_sigma = 1e-4;
deltaT_min = sqrt(2 * pi * sigma^2) / (N^2 * rMax * target_sigma);
sigma_2_min = sqrt(2 * pi * sigma^2) / (N^2 * rMax * deltaT_min);

% "num2str is suggested by ChatGPT to enable printing value
disp(['Minimum deltaT: ', num2str(deltaT_min)]);
disp(['Sigma under minimum deltaT: ', num2str(sigma_2_min)]);

%% Q5
N_value = 5:5:50;
for i = 1:length(N_value)
    N = N_value(i);
    s_estimate = zeros(N_value(i),1);
    [outputValues, ~] = histogramMLEstimates(s, N, rMax, deltaT, [], [], false);
    s_estimate(i) = mean(outputValues);
    bias(i) = mean(s_estimate) - s;
    variance(i) = var(s_estimate);
end

figure;
subplot(2,1,1); % this line is suggested by ChatGpt to display two subplots
plot(N_value, bias, '-o');
xlabel('N (number of neurons)');
ylabel('$\langle \hat{s} \rangle - s$', 'Interpreter', 'latex')% this line is suggested by ChatGPT to display the symbols

subplot(2,1,2);
plot(N_value, variance, '-o');
xlabel('N (number of neurons)');
ylabel('$\sigma^2_{est}(\hat{s})$', 'Interpreter', 'latex')

%% Q6
figure;
loglog(N_value, variance, '-o')
xlabel('N (number of neurons)');
ylabel('$\sigma^2_{est}(\hat{s})$', 'Interpreter', 'latex')

logN = log(N_value);
logVar = log(variance);
fit = polyfit(logN, logVar, 1); %% This line is suggested by chatgpt to extract the slope
slope = fit(1);
disp(['Slope: ', num2str(slope)]);


%% Q7.1
s = 1;
rMax = 20;
deltaT = 2;
sigma_value = 0.08:0.02:1;
variance = zeros(size(sigma_value));

for i = 1:length(sigma_value)
    sigma = sigma_value(i);
    [outputValues, ~] = histogramMLEstimates(s, N, rMax, deltaT, [], sigma, false);
    s_estimate(i) = mean(outputValues);
    variance(i) = var(s_estimate);
end

figure;
semilogy(variance, sigma_value, '-o');
xlabel('$\sigma$','Interpreter', 'latex');
ylabel('$\sigma^2_{est}(s)$','Interpreter', 'latex');

%% Q7.2
[~, minIndex] = min(variance);
optimal_sigma = sigma_value(minIndex);
disp(['The function is minimized at sigma = ', num2str(optimal_sigma)]);

%% Q8
sigma = 0.2;
N = 10;
rMax = 20;
drawReceptiveFields(N,rMax,sigma);