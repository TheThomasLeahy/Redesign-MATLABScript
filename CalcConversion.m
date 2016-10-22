function [PixelsToMM] = CalcConversion( I )
%Code by Mahy Hussain
%Finds conversion factor from pixels to mm from ruler image
%Returns pixels to mm ratio

I_bin = imbinarize(I);
I_comp = imcomplement(I_bin);
I_despeckle = bwareaopen(I_comp,1000);
I_filled = imfill(I_despeckle,'holes');
B = bwboundaries(I_filled);
imshow(I);
hold on;
visboundaries(B);
c = regionprops(I_filled,'centroid');
centroids = cat(1, c.Centroid);
distances = diff(centroids);
PixelsToMM = sqrt(distances(1,1)^2 + distances(1,2)^2);
plot(centroids(:,1),centroids(:,2),'*b');
end