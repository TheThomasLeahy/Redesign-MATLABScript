function [bound,I_bin_filled,pixel_conversion] = BorderDetection( I )
%Code by Mahy Hussain
%Finds the border of a lesion image
%Returns binarized image, xy coordinates, and pixel conversion (pixels/mm)

I_bin = imbinarize(I);
I_bin =imcomplement(I_bin);
I_bin_filled = imfill(I_bin,'holes');
B = bwboundaries(I_bin_filled);
bound = B(1);
moleIndex = 1;
dim = size(cell2mat(bound));
for i=2:length(B)
    test = size(cell2mat(B(i)));
    if test(1) > dim(1)
        bound = B(i);
        moleIndex = i;
    end
end
c = regionprops(I_bin_filled,'centroid');
centroids = cat(1, c.Centroid);
centroids(moleIndex,:) = [];
distances = diff(centroids);
pixel_conversion = sqrt(distances(1,1)^2 + distances(1,2)^2);

end

