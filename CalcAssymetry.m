function [ Circ ] = CalcAssymetry(BorderXY, ImageBorder, Area)
%Code by Thomas Leahy
%Quanitifies the assymetry of the image
%Ideas/Algorithms taken from the following paper:
%"Determining the asymmetry of skin lesion with fuzzy borders" (See UT Box)

%% Find CIRC

% CIRC is 1 if the lesion is symmetrical or greater than 1 if it is
% elliptical
Perimeter = length(BorderXY);
Circ = (4*pi*Area)/(Perimeter^2);

%% Fit to elipse and find change in area



%% SD Method


%% Will's Method

%Find Centroid
xCent = mean(BorderXY(:,1));
yCent = mean(BorderXY(:,2));
xCent = round(xCent);
yCent = round(yCent);

for theta = 0:179
    %Find the line of sym
    xPoints = size(ImageBorder,1);
    xPoints = 1:xPoints;
    for i= 1:length(xPoints)
        if xPoints(i) <= xCent
            yPoints(i) = round(yCent - abs(xPoints(i)-xCent)*tand(180-theta));
        else
            yPoints(i) = round(yCent + abs(xPoints(i)-xCent)*tand(180-theta));
        end
    end
    
    Q1 = [xPoints(i) yPoints(1)];
    Q2 = [xPoints(length(xPoints)) yPoints(length(yPoints))];
    %Match points across the line of sym
    for i = 1:size(ImageBorder,1)
        for j = 1:size(ImageBorder,2)
            P = [i j];
            d = abs(det([Q2-Q1;P-Q1]))/abs(Q2-Q1);
        end
    end
    
    
    
end

end

