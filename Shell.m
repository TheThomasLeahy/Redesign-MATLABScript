%BME 370 Redesign Project
%Team 9
%MoleScope

%Project Script
clc; clear all; close all;

%% Load Images

%User input files

folder_name = uigetdir('C:\Users\thoma_000\OneDrive\Documents\BME 370\Redesign-MATLABScript\Images', 'Select a folder of images you want to process!');
cd(folder_name);

%Load files
files = dir(folder_name);
fileIndex = find(~[files.isdir]);

%Get rid of bogus files - idk why these are there
x = 1;
for i = 1:length(files)
    if files(i).bytes ~= 0
        if ~strcmp(files(i).name, '.DS_Store')
            theseFiles(x) = files(i);
            x = x + 1;
        end
    end
end
files = theseFiles;


%% Assess each image
%Data Array
field1 = 'Image';  value1 = [];
field2 = 'BorderXY';  value2 = [];
field3 = 'ImageBorder';  value3 = [];
field4 = 'AreaMM';  value4 = [];
field5 = 'Circ'; value5 = [];
field6 = 'maxPercentOverlap'; value6 = [];
field7 = 'deltaPerimeter'; value7 = [];
field8 = 'ColorVariation'; value8 = [];
field9 = 'ConversionFactor'; value9 = [];
field10 = 'MajorAxis'; value10 = [];
field11 = 'MinorAxis'; value11 = [];
field12 = 'AreaPixel';  value12 = [];

dataArray = struct(field1,value1,field2,value2,field3,value3,field4,...
    value4, field5, value5, field6,value6,field7,value7,...
    field8, value8, field9, value9, field10, value10, field11, value11,...
    field12, value12);

%For each image:
for i = 1:length(files)
    
    %Create a .gif from the .jpg
    [image, colormap] = imread(files(i).name);
    
    %Cropping
    figure('Name', ' Crop the Ruler ');
    [ruler,rulermap] = imcrop(image,colormap);
    figure('Name', ' Crop the Mole ');
    [mole, molemap] = imcrop(image, colormap);
    close all;
    %{
    figure;
    imshow(ruler);
    figure;
    imshow(mole);
    %}
    
    %Border Detection
    [BorderXY, ImageBorder] = BorderDetection(mole, colormap);
    BorderXY = BorderXY{1};
    BorderXY = [BorderXY(:,2) BorderXY(:,1)]; %Making it XY points
    
    
    %Border-Thining
    BorderXY = BorderThining(BorderXY);
    
    %Generate Border Contour
    plot(BorderXY(:,1) ,BorderXY(:,2));
    hold on;
    title('Border Outline');
    
    %Calc Conversion Factor
    figure;
    ConversionFactor = CalcConversion(ruler);
    
    %Calc Major and Minor Axis Lengths
    [major, minor, centroid] = CalcAxes(ImageBorder);
    
    %Calc Size
    [AreaPixel, AreaMM] =  CalcSize(BorderXY, ImageBorder, ConversionFactor);
    
    %Calc Assymetry
    %[Circ, maxPercentOverlap, deltaPerimeter] = CalcAssymetry(BorderXY, ImageBorder, Area);
    
    %Calc Color Variation
    ColorVariation = CalcColorVariation(mole, colormap, ImageBorder);
    ColorSD = (ColorVariation/AreaPixel)*100;
    
    %Data Storage
    dataArray(i).Image = mole;
    dataArray(i).BorderXY = BorderXY;
    dataArray(i).ImageBorder = ImageBorder;
    dataArray(i).Area = AreaPixel;
    dataArray(i).Area = AreaMM;
    % dataArray(i).Circ = Circ;
    %dataArray(i).maxPercentOverlap = maxPercentOverlap;
    %dataArray(i).deltaPerimeter = deltaPerimeter;
    dataArray(i).ConversionFactor = ConversionFactor;
    dataArray(i).ColorVariation = ColorVariation;
    dataArray(i).MajorAxis = major;
    dataArray(i).MinorAxis = minor;
    dataArray(i).Centroid = centroid;
end

%% Time-Lapse
%Generate Time-Lapse Data and Generate Plots

%If you want to get something (for ex, the area) from the ith image,
%address it like this "thisarea = dataArray(i).Area;"

%Border Change over time/Contour Map (Kristen)

%Find largest image
max = 0;
for i = 1:size(dataArray,2)
    val = size(dataArray(i).ImageBorder,1)*size(dataArray(i).ImageBorder,2);
    val = val/(dataArray(i).ConversionFactor^2);
    if val > max
        max = val;
        ind = i;
    end
end
constFactor = dataArray(ind).ConversionFactor;
setPixelSize = size(dataArray(ind).ImageBorder);
centroidCoord = round(setPixelSize/2);
figure;
for i = 1:size(dataArray,2)
    xNew = [];
    yNew = [];
    for x = 1:size(dataArray(i).BorderXY,1)
        if x ~= ind
            %Find distance from centroid in mm
            dx = dataArray(i).BorderXY(x,1)-dataArray(i).Centroid(1);
            dy = dataArray(i).BorderXY(x,2)-dataArray(i).Centroid(2);
            dxNEW = dx/dataArray(i).ConversionFactor;
            dyNEW = dy/dataArray(i).ConversionFactor;
            %Scale by constant pixel/mm ratio, found above
            dxScale = dxNEW*constFactor;
            dyScale = dyNEW*constFactor;
            %Find new Border
            xNew = [xNew; dxScale + centroidCoord(1)];
            yNew = [yNew;  dyScale + centroidCoord(2)];
        end
    end
    plot(xNew,yNew);
    hold on;
end
hold off;

%Area (MAHY)
allMajor = {};
allMinor = {};
for i=1:length(files)
    allMajor{end+1}=dataArray(i).MajorAxis / ((dataArray(i).ConversionFactor)^2);
    allMinor{end+1}=dataArray(i).MinorAxis / ((dataArray(i).ConversionFactor)^2);
end
majorSize = cell2mat(allMajor);
d_majorSize = diff(majorSize);
minorSize = cell2mat(allMinor);
d_minorSize = diff(minorSize);

%Plot over time
figure();
plot(majorSize);
hold on;
plot(minorSize);
xlabel('Picture Number');
ylabel('Length (mm)');
title('Major and Minor Lengths over Time');
legend('Major Axis','Minor Axis');
hold off;

figure();
plot(d_majorSize);
hold on;
plot(d_minorSize);
xlabel('Picture Number');
ylabel('Change in Length (mm)');
title('Change in Major and Minor Lengths over Time');
legend('Major Axis','Minor Axis');
hold off;

%Relation to what is bad

%Asymmetry (TOM)
%Output and Plots metrics over Time (Image Number)
%Relation to what is bad

figure('Name', 'Asymmetry Timelapse');
subplot(1,3,1);
plot(dataArray(:).Circ);
title('Cirularity Index');
xlabel('Images')
ylabel('Circularity Index');
subplot(1,3,2);
plot(dataArray(:).maxPercentOverlap);
title('Maximum Percent Overlap');
xlabel('Images');
ylabel('Maximum Percentage Overlap');
subplot(1,3,3);
plot(dataArray(:).deltaPerimeter);
title('Delta Perimeter');
xlabel('Images');
ylabel('Delta Perimeter');

%Color Variation (Kristen)
%Finding changes between Images, etc.



%Generate Table here (


