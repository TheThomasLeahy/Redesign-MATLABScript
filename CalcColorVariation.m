function [ColorVar] = CalcColorVariation(Image, map, BorderXY, ImageBorder)
%Code by Laura Kenyon and Kristen Hagan 

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
            maskedImage(i,j) = 0; 
        end 
    end 
   
 end


imshow(maskedImage, map);
title('Masked Mole')
% maskedImage = maskedImage(I_filled);
% imshow(maskedImage);
% title('Masked Image')
% figure;

%find std dev of intensities across mole 
figure;
ColorVar = stdfilt(maskedImage);
imshow(ColorVar);
title('Standard Deviation');
figure;

end

