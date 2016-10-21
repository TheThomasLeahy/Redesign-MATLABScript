[A,map] = imread('EditMole1.gif');
[ruler, rulermap]=imcrop(A, map);
figure;
imshow(ruler); colormap(rulermap);

%black = 0.15, 0.15, 0.15 or less =warning 
%pink range 
%white range 0.9412 0.9412 0.9412 = light gray and above is white 
%tan 

%provide number of colors 

[rows columns numberOfColorBands] = size(rgbImage);
subplot(2, 2, 1);
imshow(rgbImage, []);
title('Original Color Image');
set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.

redPlane = rgbImage(:, :, 1);
greenPlane = rgbImage(:, :, 2);
bluePlane = rgbImage(:, :, 3);

% Let's get its histograms.
[pixelCountR grayLevelsR] = imhist(redPlane);
subplot(2, 2, 2);
plot(pixelCountR, 'r');
title('Histogram of red plane');
xlim([0 grayLevelsR(end)]); % Scale x axis manually.

[pixelCountG grayLevelsG] = imhist(greenPlane);
subplot(2, 2, 3);
plot(pixelCountG, 'g');
title('Histogram of green plane');
xlim([0 grayLevelsG(end)]); % Scale x axis manually.

[pixelCountB grayLevelsB] = imhist(bluePlane);
subplot(2, 2, 4);
plot(pixelCountB, 'b');
title('Histogram of blue plane');
xlim([0 grayLevelsB(end)]); % Scale x axis manually.
