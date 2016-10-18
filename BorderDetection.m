function [bound,I_bin_filled] = BorderDetection( I )
%Code by Mahy Hussain
%Finds the border of a lesion image
%Returns binarized image and xy coordinates

I_bin = imbinarize(I);
I_bin = imcomplement(I_bin);
I_bin_filled = bwareaopen(I_filled,50);
I_bin_filled = imfill(I_bin,'holes');
B = bwboundaries(I_bin_filled);



