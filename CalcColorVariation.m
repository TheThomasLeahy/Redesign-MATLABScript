function [ColorVar] = CalcColorVariation(Image, map, ImageBorder)
%Code by Kristen Hagan 
clc;
%output simple colormap 
imshow(Image, map)
title('Colormap of Image');
figure;
imshow(ImageBorder);
title('Mask')
figure;
%find homogeneity of only mole 

%mask Image with border 
maskedImage = Image;
 
newmap = zeros((size(map,1)+1), size(map,2));
newmap(1:size(map,1),:) = map;
newmap(end, :) = [1 1 1];

for i=1:size(ImageBorder,1)
    for j=1:size(ImageBorder,2)
        if ImageBorder(i,j) ==0     %if its black area on mask
           maskedImage(i,j)= imcomplement(ImageBorder(i,j));

        end 
    end 
end



imshow(maskedImage, newmap);
title('Masked Mole')

%find std dev of intensities across mole 
figure;
ColorVar = stdfilt(maskedImage);
imshow(ColorVar);
title('Standard Deviation of Image');
figure;

rgbImage = ind2rgb(Image, map);
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

[pixelCountG grayLevelsG] = imhist(greenPlane);
subplot(2, 2, 3);
plot(pixelCountG, 'g');
title('Histogram of green plane');

[pixelCountB grayLevelsB] = imhist(bluePlane);
subplot(2, 2, 4);
plot(pixelCountB, 'b');
title('Histogram of blue plane');

%what color are in image
%colorshades(rgbImage, ImageBorder)

end

