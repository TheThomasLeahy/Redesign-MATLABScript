function [ Circ, percentOverlap, deltaPerim ] = CalcAssymetry(BorderXY, ImageBorder, Area)
%Code by Thomas Leahy
%Quanitifies the assymetry of the image
%Ideas/Algorithms taken from the following paper:
%"Determining the asymmetry of skin lesion with fuzzy borders" (See UT Box)

%% Find CIRC - How close to circular

% CIRC is 1 if the lesion is perfectly circular
% Greater than 1 if eliptical
% Less than 1 if extremely jagged edges
Perimeter = length(BorderXY);
Circ = (4*pi*Area)/(Perimeter^2);

%% Testing for symmetry around different planes of symmetry

%Find Centroid
xCent = mean(BorderXY(:,1));
yCent = mean(BorderXY(:,2));
xCent = round(xCent);
yCent = round(yCent);
tote = zeros(1,180);
match = zeros(1,180);
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
    
    x1 = xPoints(1);
    y1 = yPoints(1);
    x2 = xPoints(length(xPoints));
    y2 = xPoints(length(yPoints));
    
    %Match points across the line of sym
    for i = 1:size(ImageBorder,1)
        for j = 1:size(ImageBorder,2)
            P = [i j];
            d = abs((y2-y1)*P(1) - (x2-x1)*P(2) + x2*y1 - y2*x1)/sqrt(((y2-y1)^2)+((x2-x1)^2));
            
            %Is this xy point above or below the symmetry line
            %We'll only consider points that are above it
            ind = find(xPoints == i);
            if(j >= yPoints(ind))
                %Above the line, consider this value
                %Find opposite of line of sym point
                dx = round(d*sind(theta-90));
                dy = round(d*cosd(theta-90));
                xNew = i-(2*dx);
                yNew = j+(2*dy);
                %Check if this point is still on the picture
                if((xNew>=1) && (xNew <= size(ImageBorder,1)) && (yNew >= 1) && (yNew<= size(ImageBorder,2)))
                    tote(theta+1) = tote(theta+1) + 1;
                    %Is this new point a match?
                    if ImageBorder(i,j) == ImageBorder(xNew, yNew)
                        %MATCH!
                        match(theta+1) = match(theta+1) + 1;
                    end
                end
            end

        end
    end
end

percent = (match./tote)*100;
percentOverlap = max(percent);


%% Fit to elipse and find change in perimeter

%Find major axes and minor axes length

Lengths = regionprops(ImageBorder,'MajorAxisLength','MinorAxisLength');

Mlength = Lengths.MajorAxisLength;
mlength = Lengths.MinorAxisLength;
Majrad = Mlength/2;
minrad = mlength/2;

denom = ((Majrad+minrad)^2)*(sqrt(-3*(((Majrad-minrad)^2)/((Majrad+minrad)^2))+4)+10);
EPerim = pi*(Majrad+minrad)*(((3*((Majrad-minrad)^2))/denom)+1);

deltaPerim = Perimeter/EPerim; %Greater than 1 if jagged edges. 1 if perfect elipse


end

