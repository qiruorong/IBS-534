function c = xdist_spikes(x,y)
% X and Y should be a list of spike times.  Each can be of variable
% length.  Returns a sorted list of the distances Y(J)-X(I) between
% every pair of spikes {I} and {J}.  Because the distance is only
% computed in one direction, the result is not necessarily symetric.

nx = length(x);
ny = length(y);
c = zeros(1,nx*ny);

for i = 1:nx
    for j = 1:ny
        c(sub2ind([nx,ny],i,j)) = y(j)-x(i);
    end
end

c = sort(c);