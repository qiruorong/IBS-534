function out = drawCorrelatedPoissonValues(lambda,N,rho,d)

    if nargin < 4 || isempty(d)
        d = 2;
    end
    
    R = generateCorrelatedUniformRandomVariables(N,rho,d);
    
    Q = length(lambda);
    out = zeros(N,d);
    if Q == 1
        
        z = max(10,round(lambda*20));
        x = [0 poisscdf(1:z,lambda) 1];
        
        for i=1:N
            for j=1:d
                out(i,j) = find(R(i,j)<x,1,'first');
            end
        end
        
    else
        
        xs = cell(d,1);
        for i=1:d
            z = max(10,round(lambda(i)*20));
            xs{i} = [0 poisscdf(1:z,lambda(i)) 1];
        end
        
        for i=1:N
            for j=1:d
                out(i,j) = find(R(i,j)<xs{j},1,'first');
            end
        end       
        
    end
    
    