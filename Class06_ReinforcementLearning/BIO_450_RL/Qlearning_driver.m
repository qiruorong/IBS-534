clear   
clear global
global data 
%output: 1 row per subject. subject number, alpha (learning rate), inverse temperature, negative log likelihood 
makeplots = 1; %change to  makeplots = 1; to make the plots 

cd('/Users/rqi/Documents/01_Academic/spring 2025/IBS 534/Class06_ReinforcementLearning/BIO_450_RL'); %cd to wherever you saved the scripts 
filenames_all = {'SampleDataExp1_1b.txt', 'SampleDataExp1_2b.txt','SampleDataExp1_3b.txt','SampleDataExp1_4b.txt','SampleDataExp1_5b.txt'};   %list of the subject files names that I want to run
%filenames_all = {'SampleDataExp2_1b.txt', 'SampleDataExp2_2b.txt','SampleDataExp2_3b.txt','SampleDataExp2_4b.txt','SampleDataExp2_5b.txt'};   
clear Fit 
Fit.Nparms = 2;  %you don't need to change anything here 
Fit.LB = [0 1e-6];   %lower bounds for our parameters 
Fit.UB = [1 30];    %upper bounds for our parameters

for s = 1:length(filenames_all)
    
    fname = filenames_all{s};
    data = dlmread(fname,'\t'); %read in the datafile
    
    fprintf('Fitting subject %d ...\n',s)
    for iter = 1:50   % run 50 times from random initial conditions, to avoid local minima 
        fprintf('Iteration %d...\n',iter)
        
        % determining initial condition
        Fit.init(s,iter,:) = rand(1,length(Fit.LB)).*(Fit.UB-Fit.LB)+Fit.LB; % random initialization
        %Fit.init(s,iter,2) = rand;
        % running fmincon to fit the free parameters of the model. you
        % don't need to change anything here 
        [res,lik] = ... 
            fmincon(@(x) FitSimpleQModel(x(1),x(2)),...
            squeeze(Fit.init(s,iter,:)),[],[],[],[],Fit.LB,Fit.UB,[],...
            optimset('maxfunevals',5000,'maxiter',2000,'GradObj','off','DerivativeCheck','off','LargeScale','on','Algorithm','active-set'));
        Fit.Result.Alpha(s,iter) = res(1);  
        Fit.Result.Beta(s,iter) = res(2); 
        Fit.Result.Lik(s,iter) = lik;
        Fit.Result.Lik  % to view progress so far
    end
    
end

% find the best fit results for each subject
[a,b] = min(Fit.Result.Lik,[],2);
for s = 1:length(filenames_all)
    Fit.Result.BestFit(s,:) = [s,...
    Fit.Result.Alpha(s,b(s)),... 
    Fit.Result.Beta(s,b(s)),...
    Fit.Result.Lik(s,b(s))];
end
Fit.Result.BestFit

dlmwrite('Output', Fit.Result.BestFit) %save the output 



%if we want to plot RPE and other variables
if makeplots == 1 
    for s = 1:length(filenames_all)
            fname = filenames_all{s};
            data = dlmread(fname,'\t');  %read in our data 
            alpha = Fit.Result.BestFit(s,2);  %get the parameters for this subject 
            beta = Fit.Result.BestFit(s,3); 
            Q1=0;   %start our Q values at zero 
            Q2=0;
            pr1 = 0; 
            pr2 = 0; 
            RPE = zeros(200,1); 
            Rewards = zeros(200, 1); 
            EV1 = zeros(200,1); 
            EV2 = zeros(200,1); 
            p1 = zeros(200,1);
            p2 = zeros(200,1); 
            for trialnum = 1:length(data) 
                    EV1(trialnum, 1) = Q1;  %my EV for each option is the Q value on this trial 
                    EV2(trialnum, 1) = Q2; 
                    Rewards(trialnum, 1) = data(trialnum, 3);  
                    pr1=exp(Q1*beta)/(exp(Q1*beta)+exp(Q2*beta));  %Softmax equation to get the probabilities 
                    pr2=exp(Q2*beta)/(exp(Q1*beta)+exp(Q2*beta)); 
                    p1(trialnum, 1) = pr1;
                    p2(trialnum, 1) = pr2; 
                    stimchoice = data(trialnum,2); %what the subject chose and the reward come from the data file (their actual choices/rewards)
                    reward=data(trialnum,3); 
                if stimchoice==1 
                     RPE(trialnum,1) = reward-Q1;
                     Q1 = Q1+((alpha)*(RPE(trialnum,1))); 
                elseif stimchoice==2
                     RPE(trialnum,1) = reward-Q2; 
                     Q2 = Q2+((alpha)*(RPE(trialnum,1))); 
                end
    
            end
    figure
    trials = 1:1:200; 
    subplot(3,1,1) 
    pointsize = 20; 
    group = data(:,2); 
    groupColors = [0 0 1; 1 0 0]; 
    gscatter(trials,RPE,group,groupColors,'.',pointsize)
   % scatter(trials, RPE) %top graph is prediction error by trial number 
    ylim([-1 1])
    title1 = ['Prediction Error by Trial (Alpha = ' num2str(alpha) '; Beta= ' num2str(beta) ')'];  
    title(title1)
    subplot(3,1,2) 
    plot(trials, EV1)    %middle graph plots expected values by trial number 
    ylim([0 1])
    hold on 
    plot(trials, EV2)
    title2 = ['Q values by Trial (Alpha = ' num2str(alpha) '; Beta= ' num2str(beta) ')']; 
    title(title2)
    subplot(3,1,3) 
    plot(trials, p1) %last graph plots predicted probability of choosing option 1 by trial number 
    ylim([0 1])
    title3 = ['P(Choose Option 1) (Alpha = ' num2str(alpha) '; Beta= ' num2str(beta) ')']; 
    title(title3)
    hold on 
    plot(trials, p2) %last graph plots predicted probability of choosing option 1 by trial number 
    end
end 
 