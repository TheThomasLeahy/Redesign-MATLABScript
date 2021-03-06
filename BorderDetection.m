function [bound,I_filled] = BorderDetection( I, map)
%Code by Mahy Hussain
%Finds the border of a lesion image
%Returns binarized image and xy coordinates

I_bin = imbinarize(I);
I_comp = imcomplement(I_bin);
I_despeckle = bwareaopen(I_comp,1000);
I_filled = imfill(I_despeckle,'holes');
B = bwboundaries(I_filled);
bound = B(1);
imshow(I, map);
hold on;
visboundaries(bound);

end 




