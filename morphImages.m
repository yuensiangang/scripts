
%% Morphing Script
% Replace lines 8-9 with the image filenames
% Amend morphing factor in line 21
% Morphed image will be saved, you can change the filename in line 36 

% Read the images
happyImage = imread('happy.jpg');
neutralImage = imread('neutral.jpg');

% Convert images to double for precise calculations
happyImage = double(happyImage) / 255;
neutralImage = double(neutralImage) / 255;

% Ensure the images are the same size
if any(size(happyImage) ~= size(neutralImage))
    error('Images must be the same size for morphing.');
end

% Define the morphing factor (0.3 for 30% happy)
morphFactor = 0.3;

% Perform the morphing
morphedImage = (1 - morphFactor) * neutralImage + morphFactor * happyImage;

% Convert the morphed image back to uint8
morphedImage = uint8(morphedImage * 255);

% Display the images
figure;
subplot(1, 3, 1), imshow(uint8(neutralImage * 255)), title('Neutral Expression');
subplot(1, 3, 2), imshow(uint8(happyImage * 255)), title('Happy Expression');
subplot(1, 3, 3), imshow(morphedImage), title('30% Happy Expression');

% Save the morphed image
imwrite(morphedImage, 'morphedImage.jpg');
