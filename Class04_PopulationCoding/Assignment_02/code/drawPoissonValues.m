function out = drawPoissonValues(lambda,N,randomNums)
    
    out = zeros(N,1);
    limit = exp(-lambda);
    
    if nargin < 3 || isempty(randomNums)
        randomNums = rand(round(N*(5*lambda)),1);
    end
    L = length(randomNums);
    
    count = 1;
    for i=1:N
        i
        n=1;
        p = randomNums(count);
        count = mod(count+1,L)+1;
        while p <= limit
            p = p*randomNums(count);
            count = mod(count+1,L)+1;
            n = n + 1;
        end
        out(i) = n - 1;
    end
    