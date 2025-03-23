mean_interval = 150;
std_interval = 100;
maxplot_interval = 400;
maxplot_time = 20000;
n_trials = 400;
n_intervals = 100;
y = zeros(n_trials,n_intervals);
for i = 1:n_trials
    y(i,:) = max([std_interval * randn(1,n_intervals) + mean_interval;...
        zeros(1,n_intervals)]);
end
t = cumsum(y,2);
figure
subplot(2,1,1);
plot([0:mean_interval/20:maxplot_interval],...
    normpdf([0:mean_interval/20:maxplot_interval],...
    mean_interval,std_interval));
set(gca,'xlim',[0 maxplot_interval]);
xlabel('Interval');
ylabel('p[Interval]');
subplot(2,1,2);
plotxtimeyraster3(t,0);
set(gca,'xlim',[0 maxplot_time]);
xlabel('Time');
ylabel('Trial');
suptitle(['Gaussian p[z_i], Mean = ',int2str(mean_interval),'; Std = ',int2str(std_interval)]);