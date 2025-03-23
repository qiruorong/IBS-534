figure;
plot(timeBins, miValues, '-o', 'LineWidth', 2, 'MarkerSize', 6);
xlabel('timeBin size');
ylabel('Mutual Information');
title('Neuron 1 Mutual Information vs. TimeBin Size');
grid on;

%%
figure;
bar(timeBins, miValues);
xlabel('timeBin size');
ylabel('Mutual Information');
title('Neuron 1 Mutual Information vs. TimeBin Size');
grid on;
