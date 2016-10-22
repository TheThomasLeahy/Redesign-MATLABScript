function [ColorVar] = CalcColorVariation(Image, map, ImageBorder)
%Code by Kristen Hagan 
cmap = map;
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
           maskedImage(i,j)= size(map,1)+1; 

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



end

