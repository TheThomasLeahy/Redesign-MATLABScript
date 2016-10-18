function [ Circ, percent ] = CalcAssymetry(BorderXY, ImageBorder, Area)
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
tote = zeros(1,179);
match = zeros(1,179);
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
            
            %Is this xy point above or below the symmetry line
            %We'll only consider points that are above it
            ind = find(xPoints == i);
            if(j >= yPoints(ind))
                %Above the line, consider this value
                %Find opposite of line of sym point
                dx = round(d*sind(theta-90));
                dy = round(d*cosd(theta-90));
                xNew = i-(2*dx);
                yNew = i+(2*dy);
                %Check if this point is still on the picture
                if((xNew>=1) && (yNew<= size(ImageBorder,2)))
                    tote(theta) = tote(theta) + 1;
                    %Is this new point a match?
                    if ImageBorder(i,j) == ImageBorder(xNew, yNew)
                        %MATCH!
                        match(theta) = match(theta) + 1;
                    end
                end
            end

        end
    end
end

percent = (match./tote)*100;


%% Fit to elipse and find change in area

%Find major axes and minor axes length

[Mlength, mlength] = regionprops(ImageBorder,'MajorAxisLength','MinorAxisLength');

Majrad = Mlength/2;
minrad = mlength/2;

denom = ((Majrad+minrad)^2)*(sqrt(-3*(((Majrad-minrad)^2)/((Majrad+minrad)^2))+4)+10);
EPerim = pi*(Majrad+minrad)*(((3*((Majrad-minrad)^2))/denom)+1);

jEdges = Perimeter/EPerim; %Greater than 1 if jagged edges. 1 if perfect elipse


end

