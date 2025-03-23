mean_count = 10;
maxplot_count = 50;
bar([0:1:maxplot_count],...
    poisspdf([0:1:maxplot_count],mean_count));
hold on
plot(mean_count*[1,1],get(gca,'ylim'),'r','Linewidth',2);
set(gca,'xlim',[0 maxplot_count])
xlabel('m')
ylabel('N_m(T)');
suptitle(['Poisson, Mean = ',int2str(mean_count),' events in T']);