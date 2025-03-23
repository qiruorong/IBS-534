function log_likelihood = makeLogLikelihoodPlot(s,N,rMax,deltaT,sigma)

    if nargin < 5 || isempty(sigma)
        sigma = pi / N;
    end

    [rateFunctions,~,~,~] = createFiringRateFunctions(N,rMax,sigma);
    rates = generateFiringRateVector(s,N,rMax,deltaT,sigma);
    thetas = linspace(0,2*pi,1000);
    d_theta = thetas(2) - thetas(1);
    
    logFs = zeros(10,1000);
    for i=1:10
        logFs(i,:) = log(rateFunctions{i}(thetas));
    end
    log_likelihood = sum(bsxfun(@times,rates,logFs))*deltaT;
    
    %der = .5*[0, log_likelihood(3:end) - log_likelihood(1:end-2), 0]/d_theta;
    %der2 = [0, log_likelihood(3:end) - 2*log_likelihood(2:end-1) + log_likelihood(1:end-2), 0]/d_theta^2;
    
    %c = der2 ./ (1 + der.^2).^1.5;
    %maxC = c(argmax(log_likelihood));
    
    q = log_likelihood - max(log_likelihood);
    p = exp(q)/(sum(exp(q))*d_theta);
    meanP = sum(p.*thetas)./sum(p);
    varP = sum(p.*(thetas-meanP).^2)/sum(p);
    s = sqrt(varP);
    
    
    figure
    yyaxis left
    plot(thetas,log_likelihood,'b-','linewidth',1)
    xlabel('s','fontsize',16)
    ylabel('Log Likeihood','fontsize',16)
    yyaxis right
    plot(thetas,p,'r-','linewidth',1)
    set(gca,'fontsize',14,'fontweight','bold')
    ylabel('p(s|r)','fontsize',16)
    xlim([0 2*pi])
    title(['Width = ' num2str(s)],'fontsize',18)