load ROC_hw_data.mat

%%
spikecount_spont = spikecount_spont_3065;
spikecount_sound = spikecount_sound_3065;

%%
spikecount_spont = spikecount_spont_3009;
spikecount_sound = spikecount_sound_3009;

%%
event_min = 0;
event_max = 40;

[n_spont,edges] = histcounts(spikecount_spont,[event_min:event_max]);
pdf_spont = n_spont/sum(n_spont);
n_sound = histcounts(spikecount_sound,[event_min:event_max]);
pdf_sound = n_sound/sum(n_sound);

x = edges(1:end-1);

%%
% Plot probability density functions

pdf_x_1 = pdf_spont;
pdf_x_2 = pdf_sound;

%%
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

% Plot log likelihood ratio
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
ROC_area = 1 + trapz(HIT_rate_values, FA_rate_values);