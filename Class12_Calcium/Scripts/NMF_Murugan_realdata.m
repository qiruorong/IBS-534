% Load calcium imaging data 
% look at xzAmyg.tif for original data
load('xzAmyg.mat')
max_frames = Ysiz(3);
data=double(Y);
%Reshape the film into a 2D matrix
rs = reshape(data, Ysiz(1)*Ysiz(2), max_frames);
number_of_neurons=20;

%% Perform NMF
tic
[W,H] = nnmf(rs,number_of_neurons, 'replicates', 1000);
toc

%We have the same problem as before, where the absolute values of W and H
%aren't right. We have to scale them again. We would expect the maximum of
%H to be the same as the maximum of the original data, but it isn't, so we
%scale W and H so it is. FYI, this is not perfect, and would not work on
%real data, but a similar approach can be used if you work ROIwise.

scale_factor = max(H(:))/max(data(:));
H = H ./ scale_factor;
W = W .* scale_factor;

%%

%Show result
h = figure();
set(h, 'MenuBar', 'none');
set(h, 'ToolBar', 'none');

for i = 1:5
    subplot(5,2,(i-1)*2+1)
    imshow(reshape(W(:,i), Ysiz(1), Ysiz(2)));
    subplot(5,2,i*2)
    plot(H(i,:))
end




