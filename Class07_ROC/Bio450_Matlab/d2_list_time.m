function [means,stds,times] = d2_list_time(clusterstruct,sgi1,sgi2,tc,...
    intervalwidth,intervalstart,intervalstop,intervalstep)

times = [intervalstart:intervalstep:intervalstop];
ntimes = length(times);
n_tc = length(tc);
means = zeros(n_tc,ntimes,3);
stds = zeros(n_tc,ntimes,3);

for i = 1:ntimes
    
    start = times(i);
    list_1_1 = d2_list(clusterstruct,sgi1,sgi1,tc,'interval',[start,start+intervalwidth]);
    means(:,i,1) = mean(list_1_1,2);
    stds(:,i,1) = std(list_1_1,0,2);
    list_2_2 = d2_list(clusterstruct,sgi2,sgi2,tc,'interval',[start,start+intervalwidth]);
    means(:,i,2) = mean(list_2_2,2);
    stds(:,i,2) = std(list_2_2,0,2);
    list_1_2 = d2_list(clusterstruct,sgi1,sgi2,tc,'interval',[start,start+intervalwidth]);
    means(:,i,3) = mean(list_1_2,2);
    stds(:,i,3) = std(list_1_2,0,2);
    
end