function [ColorVar] = CalcColorVariation(Image, map, ImageBorder)
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


red = map(:, :, 1);
green = map(:, :, 2);
blue = map(:, :, 3);

[pixelCountR grayLevelsR] = imhist(red);
subplot(2, 2, 2);
plot(pixelCountR, 'r');
title('Histogram of red plane');
xlim([0 grayLevelsR(end)]); 

[pixelCountG grayLevelsG] = imhist(green);
subplot(2, 2, 3);
plot(pixelCountG, 'g');
title('Histogram of green plane');
xlim([0 grayLevelsG(end)]); 

[pixelCountB grayLevelsB] = imhist(blue);
subplot(2, 2, 4);
plot(pixelCountB, 'b');
title('Histogram of blue plane');
xlim([0 grayLevelsB(end)]); 

end

