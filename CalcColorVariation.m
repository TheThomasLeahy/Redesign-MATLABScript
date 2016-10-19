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
bordermask = poly2mask(BorderXY(:,1), BorderXY(:,2), size(maskedImage,1), size(maskedImage,2));
%imshow(bordermask);
% filledmask= imfill(bordermask);
% imshow(filledmask);
%figure;
%title('Mask Used in ColorHomog. Calculation');
maskedImage = maskedImage .* bordermask;
imshow(maskedImage);
title('Masked Image')
figure;

%find std dev of intensities across mole 
ColorVar = stdfilt(maskedImage);
imshow(ColorVar);
figure;

end

