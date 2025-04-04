%% Elbow method of determining K

Ks = 2:30;  % Range of K values to try
errors = zeros(length(Ks), 1);

for i = 1:length(Ks)
    K = Ks(i);
    [W_tmp, H_tmp] = nnmf(V, K, 'replicates', 5);  % multiple runs helps
    errors(i) = norm(V - W_tmp * H_tmp, 'fro');
end

figure;
plot(Ks, errors, '-o');
xlabel('Number of Components (K)');
ylabel('Reconstruction Error');
title('NMF Model Selection - Elbow Method');
