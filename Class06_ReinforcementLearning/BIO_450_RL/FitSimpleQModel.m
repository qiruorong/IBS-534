function [lik] = FitSimpleQModel(alpha,beta)

global data  

% Find the log likelihood of the choice data under a Q learning model
% with learning rate "alpha" and inverse temperature parameter "beta" 
% Outputs:
% Lik = - log likelihood of the data

lik    = 0;   % log likelihood
Qval = [0, 0];  %start my Q values and probabilities at zero. Q(1) is Q value for action 1 (option 1)
                %Q(2) is the Q value for action 2 (option 2) 
Prob = [0, 0]; 
for t = 1:length(data)  % t = trial number
    c = data(t,2); %c is what the subject chose (option 1 or 2) 
    Reward=data(t,3); %what they recieved 
    Prob(1)=exp(Qval(1)* beta)/(exp(Qval(1)* beta)+exp(Qval(2)* beta)); %Softmax to get probability of making each action (choose 1, choose 2)
    Prob(2)=exp(Qval(2)* beta)/(exp(Qval(1)* beta)+exp(Qval(2)* beta)); 
    lik = lik + log(Prob(c));  %update log likelihood with the probability of the action that they chose on this trial 
    %UPDATE RPE AND Q VALUE FOR THE CHOSEN OPTION
    PE = Reward - Qval(c); % update your RPE here 
    Qval(c) = Qval(c) + alpha * PE; %%update Qval(c) or value of the chosen option here 
    
end
lik = -lik;  % so we can minimize the function rather than maximize
