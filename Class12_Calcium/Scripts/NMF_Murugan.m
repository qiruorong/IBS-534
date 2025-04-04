rng(1);
max_frames = 1000;
%%Make film

%Preallocate Film
data = zeros(200,200,max_frames);


%Center for each ROI
ROIcent = [40, 40;
           110, 70;
           180, 55;
           60, 135;
           140, 140];

%Preallocate Amplitude data for comparison
amplitude = zeros(size(ROIcent,1),max_frames);
       
%Make component ROIs       
ROIbase = zeros(200,200,size(ROIcent,1));

%Make a picture of each ROI with a random width
for r = 1:size(ROIcent,1)
    ROIbase(:,:,r) = gauss2d(ROIbase(:,:,r), randi([10 50]), ROIcent(r,:));  
end



%Simulate each ROI is a exponentially decaying
for r = 1:size(ROIcent,1)
    amp = 0;
    tau = randi(10)+10;
    maxamp = 1 + randi(3);
    for t = 1:size(data,3)
        if rand() > 0.99
            amp = maxamp;
        else
            amp = amp - amp/tau;
        end
        amplitude(r,t) = amp;
        data(:,:,t) = data(:,:,t) + amp*ROIbase(:,:,r);
    end
end

%%
%Save as TIF for website
% for t = 1:size(data,3)
%    if t == 1
%        imwrite(data(:,:,t),'fakeCaImage.tif')
%    else
%         imwrite(data(:,:,t),'fakeCaImage.tif','WriteMode','append')
%    end
% end

%Reshape the film into a 2D matrix
rs = reshape(data, 200*200, max_frames);

tic
%Perform NMF
[W,H] = nnmf(rs,5, 'replicates', 100);
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
    imshow(reshape(W(:,i), 200, 200));
    subplot(5,2,i*2)
    plot(H(i,:)) 
end




