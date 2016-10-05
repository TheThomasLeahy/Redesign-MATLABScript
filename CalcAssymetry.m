function [ output_args ] = CalcAssymetry(BorderXY, ImageBorder)
%Code by Thomas Leahy
%Quanitifies the assymetry of the image
%Ideas/Algorithms taken from the following paper:
%"Determining the asymmetry of skin lesion with fuzzy borders" (See UT Box)

%Find Centroid
BorderXY = BorderXY{1};
xCent = mean(BorderXY(:,1));
yCent = mean(BorderXY(:,2));

%Find Major Axes



end

