function rateFunctions = drawReceptiveFields(N,rMax,sigma)

    if nargin < 2 || isempty(rMax)
        rMax = 20;
    end

    if nargin < 3 || isempty(sigma)
        sigma = pi / N;
    end

    rateFunctions = createFiringRateFunctions(N,rMax,sigma);
    
    thetas = linspace(0,2*pi,1000);
    figure
    hold on
    %sumVals = zeros(size(thetas));
    for i=1:N
        a = rateFunctions{i}(thetas);
        plot(thetas,a,'-','linewidth',1)
        %sumVals = sumVals + a;
    end
    %plot(thetas,sumVals,'k-','linewidth',2)
    
    xlim([0 2*pi]);
    set(gca,'fontsize',14,'fontweight','bold')
    xlabel('Angle','fontsize',16)
    ylabel('Firing Rate (s^{-1})','fontsize',16)
    
    