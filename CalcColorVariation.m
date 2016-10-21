function [ColorVar] = CalcColorVariation(Image, map, ImageBorder, Imagejpg)
%Code by Kristen Hagan 
cmap = map;
clc;
%output simple colormap 
imshow(Image,map)
title('Colormap of Image');
figure;
imshow(ImageBorder);
title('Mask')
figure;
%find homogeneity of only mole 

%mask Image with border 
maskedImage = Image;

for i=1:size(ImageBorder,1)
    for j=1:size(ImageBorder,2)
        if ImageBorder(i,j) ~=1
            maskedImage(i,j) = 255; 
        end 
    end 
   
 end


imshow(maskedImage, map);
title('Masked Mole')

%find std dev of intensities across mole 
figure;
ColorVar = stdfilt(Image);
imshow(ColorVar);
title('Standard Deviation of Image');
figure;

%find color distribution in image 
subplot(2, 2, 1);
imshow(Imagejpg);
title('Original Color Image');


redPlane = map(:, :, 1);
greenPlane = map(:, :, 2);
bluePlane = map(:, :, 3);

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

end

