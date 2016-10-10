function [ColorVar] = CalcColorVariation(Image, BorderXY, ImageBorder)
%Code by Laura Kenyon and Kristen Hagan 

clc;

%output simple colormap 

imagesc(Image)
colorbar
title('ColorMap of Image');
figure;
%find homogeneity of only mole 

%mask Image with border 
maskedImage = Image;
bordermask = poly2mask(BorderXY(:,1), BorderXY(:,2), 512, 512);
%imshow(bordermask);
% filledmask= imfill(bordermask);
% imshow(filledmask);
%figure;
%title('Mask Used in ColorHomog. Calculation');
maskedImage(~bordermask)=255;
imshow(maskedImage);
title('Masked Image')
figure;

%find std dev of intensities across mole 
ColorVar = stdfilt(maskedImage);
imshow(ColorVar);
figure;

end

