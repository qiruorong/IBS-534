function list = d2_list(clusterstruct,sgi1,sgi2,tc,varargin)

% Check that all trials are the same length.
if length(unique([clusterstruct.trials.triallength]))>1
    error(errormsg(40));
else
    triallength = clusterstruct.trials(1).triallength;
end;	

% Default arguments.
interval = [0 triallength];             % response window
align = 0;
otheropts = assignopts({'interval','align'},varargin{:});

n_tc = length(tc);

disp(['SGI ',int2str(sgi1),' vs. SGI ',int2str(sgi2)]);

spike1 = psttrialtimes(clusterstruct,'sgiindex',sgi1,'interval',interval,'align',align);
n1 = size(spike1,1);
if sgi1 == sgi2
    list = zeros(n_tc,n1*(n1-1)/2);
    k = 0;
    for i = 1:n1
        for j = i+1:n1
            i1 = find(~isnan(spike1(i,:)));
            i2 = find(~isnan(spike1(j,:)));
%             if ~isempty(i1) & ~isempty(i2)
                k = k + 1;
                for l = 1:n_tc
                    list(l,k) = d2_spikes(spike1(i,i1),...
                        spike1(j,i2),tc(l));
                end
%             end
        end
    end
    
else
    spike2 = psttrialtimes(clusterstruct,'sgiindex',sgi2,'interval',interval,'align',align);
    n2 = size(spike2,1);
    list = zeros(n_tc,n1*n2);
    k = 0;
    for i = 1:n1
        for j = 1:n2
            i1 = find(~isnan(spike1(i,:)));
            i2 = find(~isnan(spike2(j,:)));
%             if ~isempty(i1) & ~isempty(i2)
                k = k + 1;
                for l = 1:n_tc
                    list(l,k) = d2_spikes(spike1(i,i1),...
                        spike2(j,i2),tc(l));
                end
%             end
        end
        
    end
end

list = list(:,1:k);