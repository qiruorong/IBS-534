function d2 = d2_spikes(x,y,tc)

cxx = xdist_spikes(x,x);
cyy = xdist_spikes(y,y);
cxy = xdist_spikes(x,y);
d2 = 0;

for i = 1:length(cxx)
    d2 = d2 + exp(-abs(cxx(i))/tc);
end
for i = 1:length(cyy)
    d2 = d2 + exp(-abs(cyy(i))/tc);
end
for i = 1:length(cxy)
    d2 = d2 -2*exp(-abs(cxy(i))/tc);
end

d2 = d2/2;
