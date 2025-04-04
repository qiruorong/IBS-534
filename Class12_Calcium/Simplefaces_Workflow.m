%% Simulating stick figure faces

% Size of the synthetic image (e.g., 10x10 pixels)
img_size = [10, 10];
num_features = 3;  % eyes, nose, mouth

% Generate basis features (W) - simple patterns
eye = zeros(img_size);
eye(3, 3:4) = 1;
eye(3, 7:8) = 1;

nose = zeros(img_size);
nose(5:6, 5) = 1;

mouth = zeros(img_size);
mouth(8, 4:7) = 1;

% Stack features into W (flatten each to a column vector)
W = [eye(:), nose(:), mouth(:)];

% Coefficient matrix H - how much of each feature is used
H = [1; 0.8; 1.2];  % weights for eye, nose, mouth

% Generate final image
V = W * H;

% Reshape to image
face_image = reshape(V, img_size);

% Plot
figure;
subplot(2,3,1); imagesc(reshape(W(:,1), img_size)); title('Eye'); axis off;
subplot(2,3,2); imagesc(reshape(W(:,2), img_size)); title('Nose'); axis off;
subplot(2,3,3); imagesc(reshape(W(:,3), img_size)); title('Mouth'); axis off;
subplot(2,3,[4 5 6]); imagesc(face_image); title('Generated Face'); axis off;
colormap gray;

%% Creating multiple fake faces 

% Create multiple combinations of facial parts
H = [1 0.8 1.2;    % Face 1
     0.5 1 1;      % Face 2
     1 0.2 0.8; 
     1 0.25 0.75; 
     0.4 0.75 1.25; 
     1.2, 0.5 1; 
     0.4 1.3 0.2;  
     0.4 1.3 0.2; 
     0.4 0.75 1.25; 
     1.25 0.1 0.1]';  % Each column = one face

% W is 100 x 3 (flattened parts), H is 3 x 10 (10 faces)
V = W * H;         % V will be 100 x 10


%%  Apply NMF
num_features = 3;
[W_est, H_est] = nnmf(V, num_features,'algorithm','mult');

%% Show identified components 

% Display estimated basis images
img_size = [10 10];
figure;
for i = 1:num_features
    subplot(1, num_features, i);
    imagesc(reshape(W_est(:,i), img_size));
    title(['Component ', num2str(i)]);
    axis off;
end
colormap gray;

%% Plot original vs reconstructed faces
num_faces = size(V, 2);  % 10 faces
img_size = [10, 10];

% Reconstruct faces
V_hat = W_est * H_est;

figure;
for i = 1:num_faces
    % Original face
    subplot(2, num_faces, i);
    imagesc(reshape(V(:,i), img_size));
    title(['Original ', num2str(i)]);
    axis off;

    % Reconstructed face
    subplot(2, num_faces, i + num_faces);
    imagesc(reshape(V_hat(:,i), img_size));
    title(['Recon ', num2str(i)]);
    axis off;
end
colormap gray;
sgtitle('Original vs Reconstructed Stick Faces');