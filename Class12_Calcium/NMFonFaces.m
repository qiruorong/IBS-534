% Set the folder where your images are stored
imageFolder = 'orl_faces';  % or your path

% Parameters
numImages = 200;     % Use up to 100 images
imgSize = [112, 92]; % Resize all images to this
filePattern = fullfile(imageFolder, '*.jpg');  % OR use *.png, *.jpg, etc.
imageFiles = dir(filePattern);

% Preallocate data matrix V
V = zeros(prod(imgSize), numImages);

for i = 1:numImages
    img = imread(fullfile(imageFolder, imageFiles(i).name));
    img = imresize(img, imgSize);     % Ensure uniform size
    img = im2double(img);             % Normalize pixel values
    V(:, i) = img(:);                 % Flatten and store as column
end

%%

num_components = 12;  % Number of basis images (parts)
[W_est, H_est] = nnmf(V, num_components);

%%

% Show the basis images (columns of W_est)
figure;
for i = 1:num_components
    subplot(3, 4, i);
    imagesc(reshape(W_est(:, i), imgSize));
    title(['Part ', num2str(i)]);
    axis off;
end
colormap gray;
sgtitle('NMF - Learned Face Parts');


%%

% Pick one reconstructed face
sample_id = 100;
reconstructed = W_est * H_est(:, sample_id);
reconstructed_img = reshape(reconstructed, imgSize);

% Compare original and reconstructed
original_img = reshape(V(:, sample_id), imgSize);

figure;
subplot(1,2,1); imagesc(original_img); title('Original'); axis off;
subplot(1,2,2); imagesc(reconstructed_img); title('Reconstructed'); axis off;
colormap gray;

%% Which component contributes most to each face

% H_est is components × samples (e.g., 16 × 100)
[~, topComponent] = max(H_est);  % returns index of max component for each face

% Display results
for i = 1:length(topComponent)
    fprintf('Face %d: Top contributing component is #%d\n', i, topComponent(i));
end

%% 

num_faces = size(H_est, 2);
face_ids = 1:num_faces;

figure;
bar(face_ids, topComponent);
xlabel('Face Index');
ylabel('Most Contributing Component');
title('Top Contributing Component per Face');

%%
contrib_ratio = H_est ./ sum(H_est, 1);  % Normalize per face

figure;
imagesc(H_est);
xlabel('Face Index');
ylabel('Component');
title('Component Contributions per Face');
colorbar;

