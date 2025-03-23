mean_interval = 150;
maxplot_interval = 400;
maxplot_time = 90000;
n_trials = 40;
n_intervals = 100;
y = zeros(n_trials,n_intervals);
for i = 1:n_trials
    y(i,:) = max([exprnd(mean_interval,n_intervals);...
        zeros(1,n_intervals)]);
end
t = cumsum(y,2);
figure
subplot(2,1,1);
plot([0:mean_interval/20:maxplot_interval],...
    exppdf([0:mean_interval/20:maxplot_interval],...
    mean_interval));
set(gca,'xlim',[0 maxplot_interval]);
xlabel('Interval');
ylabel('p[Interval]');
subplot(2,1,2);
plotxtimeyraster3(t,0);
set(gca,'xlim',[0 maxplot_time]);
xlabel('Time');
ylabel('Trial');
suptitle(['Exponential p[z_i], Mean = ',int2str(mean_interval)]);