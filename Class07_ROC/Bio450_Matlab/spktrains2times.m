function clusterstruct = spktrains2times(trialmatrix,t,varargin)

sgiindex = 1;
assign(varargin);

triallength = t(end)-t(1);
ntrials = size(trialmatrix,1);


for i = 1:ntrials
    clusterstruct.trials(i).triallength = triallength;
    clusterstruct.trials(i).SGI = sgiindex;
    clusterstruct.trials(i).spiketimes = t(trialmatrix(i,:)==1);
end
