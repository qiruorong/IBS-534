% Define the alphabet of "events" x, which are just tenths from 0 to 40
event_resol = 0.1;
event_min = 0;
event_max = 40;
x = [event_min:event_resol:event_max];

%%

% Parameters for Gaussian (i.e. normal) distributions of noise or signal
mean_noise = 11;
std_noise  = 2;
mean_signal= 12.9;
std_signal = 2;

% Define the probability density functions for noise and signal based on
% above parameters
pdf_x_noise = normpdf(x,mean_noise,std_noise);
norm_noise = sum(pdf_x_noise);
pdf_x_noise = pdf_x_noise / norm_noise;
pdf_x_signal = normpdf(x,mean_signal,std_signal);
norm_signal = sum(pdf_x_signal);
pdf_x_signal = pdf_x_signal / norm_signal;

%%
% Parameters for Poisson distributions of noise or signal
mean_noise = 21;
mean_signal= 25.7;

% Define the probability density functions for noise and signal based on
% above parameters
pdf_x_noise = poisspdf(x,mean_noise);
norm_noise = sum(pdf_x_noise);
pdf_x_noise = pdf_x_noise / norm_noise;
pdf_x_signal = poisspdf(x,mean_signal);
norm_signal = sum(pdf_x_signal);
pdf_x_signal = pdf_x_signal / norm_signal;

%%

% Parameters for Exponential distributions of noise or signal
mean_noise = 5;
mean_signal= 10;

% Define the probability density functions for noise and signal based on
% above parameters
pdf_x_noise = exppdf(x,mean_noise);
norm_noise = sum(pdf_x_noise);
pdf_x_noise = pdf_x_noise / norm_noise;
pdf_x_signal = exppdf(x,mean_signal);
norm_signal = sum(pdf_x_signal);
pdf_x_signal = pdf_x_signal / norm_signal;

%%

% Parameters for Rayleigh distributions of noise or signal
mean_noise = 5;
mean_signal= 8.6;

% Define the probability density functions for noise and signal based on
% above parameters
pdf_x_noise = raylpdf(x,mean_noise);
norm_noise = sum(pdf_x_noise);
pdf_x_noise = pdf_x_noise / norm_noise;
pdf_x_signal = raylpdf(x,mean_signal);
norm_signal = sum(pdf_x_signal);
pdf_x_signal = pdf_x_signal / norm_signal;

%%
k = 1;

% Plot probability density functions
figure
ax(1) = subplot(2,1,1);
plot(x,pdf_x_noise,'k');
hold on
plot(x,pdf_x_signal,'r');
set(gca,'xlim',[event_min,event_max]);
xlabel('Events x');
ylabel('Prob Density');

% Define Likelihood Ratio (lr) as a function of x
lr = pdf_x_signal./pdf_x_noise;

% Plot likelihood ratio
ax(2) = subplot(2,1,2);
plot(x,log(lr));
set(gca,'xlim',[event_min,event_max]);
text(event_min+2*event_resol,log(k),['k=',num2str(k)]);
xlabel('Events x');
ylabel('Log Likelihood Ratio');

% Compute Ideal Observer-based ROC curve
% Set a decision criterion based on the likelihood ratio
noise_events_k_i = find((lr<k));
signal_events_k_i = find((lr>=k));
% Plot events in likelihood plot, delineated as noise or signal
axes(ax(2));
hold on
plot(x(noise_events_k_i),log(lr(noise_events_k_i)),'ko');
plot(x(signal_events_k_i),log(lr(signal_events_k_i)),'ro');

% Compute Hit and False Alarm rates given criterion
FA_rate_k = sum(pdf_x_noise(signal_events_k_i))
HIT_rate_k = sum(pdf_x_signal(signal_events_k_i))

% Cycle through different likelihood ratio criteria to generate ROC curve
k_values = [0:0.01:20];
FA_rate_values = zeros(1,length(k_values));
HIT_rate_values = zeros(1,length(k_values));
for j = 1:length(k_values)
    noise_events_k_j = find((lr<k_values(j)));
    signal_events_k_j = find((lr>=k_values(j)));
    FA_rate_values(j) = sum(pdf_x_noise(signal_events_k_j));
    HIT_rate_values(j) = sum(pdf_x_signal(signal_events_k_j));
end

FA_rate_value9s = [1,FA_rate_values,0];
HIT_rate_values = [1,HIT_rate_values,0];
ROC_area = 1 + trapz(HIT_rate_values, FA_rate_value9s);

% Plot ROC curve
figure
plot(FA_rate_values,HIT_rate_values,'x');
hold on
xlabel('P(S|n) - False Alarm Rate');
ylabel('P(S|s) - Hit Rate');
set(gca,'xlim',[0 1],'ylim',[0 1]);

text(0.5,0.5,['AUC=',num2str(trapz(fliplr(FA_rate_values),fliplr(HIT_rate_values)))]);