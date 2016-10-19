function [ColorVar] = CalcColorVariation(Image, map, BorderXY, ImageBorder)
%Code by Laura Kenyon and Kristen Hagan 

clc;
%output simple colormap 
imshow(Image,map)
title('Colormap of Image');
figure;
%find homogeneity of only mole 

%mask Image with border 
maskedImage = Image;

BW = imbinarize(maskedImage, .5);
I_comp = imcomplement(BW);
I_comp = imfill(I_comp,'holes');
imshow(I_comp);
maskedImage = maskedImage.*uint8(I_comp);
for i=1:size(maskedImage, 1)
    for j=1:size(maskedImage, 2)
        if maskedImage(i,j)~=0
            maskedImage(i,j)=1;
        end 
    end
end
figure;
imshow(maskedImage, map);
% maskedImage = maskedImage(I_filled);
% imshow(maskedImage);
% title('Masked Image')
% figure;

%find std dev of intensities across mole 
ColorVar = stdfilt(maskedImage);
imshow(ColorVar);
figure;

end

