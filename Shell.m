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
field4 = 'Area';  value4 = [];
field5 = 'Circ'; value5 = [];
field6 = 'maxPercentOverlap'; value6 = [];
field7 = 'deltaPerimeter'; value7 = [];
field8 = 'ColorVariation'; value8 = [];
field9 = 'ConversionFactor'; value9 = []; 

dataArray = struct(field1,value1,field2,value2,field3,value3,field4,...
    value4, field5, value5, field6,value6,field7,value7,...
    field8, value8, field9, value9);

%For each image:
for i = 1:length(files)
    %Load Image
    [Image,colorMap] = imread(files(i).name);
    
    %Cropping
    figure('Name', ' Crop the Ruler ');
    [ruler,rulerMap] = imcrop(Image,colorMap);
    figure('Name', ' Crop the Mole ');
    [mole,moleMap] = imcrop(Image,colorMap);
    
    %Border Detection
    [BorderXY, ImageBorder] = BorderDetection(mole);
    BorderXY = BorderXY{1};
    BorderXY = [BorderXY(:,2) BorderXY(:,1)]; %Making it XY points
    
    %Border-Thining
    BorderXY = BorderThining(BorderXY);
    
    %Generate Border Contour
    plot(BorderXY(:,1) ,BorderXY(:,2));
    hold on;
    title('Border Outline');
    
    %Calc Size
    Area =  CalcSize(BorderXY, ImageBorder);
    
    %Calc Assymetry
    %[Circ, maxPercentOverlap] = CalcAssymetry(BorderXY, ImageBorder, Area);
    
    %Calc Color Variation
    ColorVariation = CalcColorVariation(mole, colorMap, BorderXY, ImageBorder);
    
    %Data Storage
    dataArray(i).Image = Image;
    dataArray(i).BorderXY = BorderXY;
    dataArray(i).ImageBorder = ImageBorder;
    dataArray(i).Area = Area;
    dataArray(i).Circ =Circ;
    dataArray(i).maxPercentOverlap = maxPercentOverlap;
    dataArray(i).deltaPerimeter = deltaPerimeter;
    dataArray(i).ConversionFactor = ConversionFactor;
    dataArray(i).ColorVariation = ColorVariation;
end

%% Time-Lapse
%Generate Time-Lapse Data and Generate Plots

%If you want to get something (for ex, the area) from the ith image,
%address it like this "thisarea = dataArray(i).Area;"

%Border Change over time/Contour Map (Kristen)
%What is pink black or whatever
contour(BorderXY(:,1), BorderXY(:,2));
hold on
if length(files)>1
    for i=2:length(files)
        z = num2str(i);
        contour(BorderXY_z(:,1), BorderXY_z(:,2));
    end
end

%Area (MAHY)
knownAreas = [83192 89335 96728 100465 111878];
d_knownAreas  = diff(knownAreas);
moleArea = {};
for i=1:length(files);
    moleArea{end+1}=dataArray(i).Area / (dataArray(i).ConversionFactor)^2;  %is this right?
end
area = cell2mat(moleArea);
d_area = diff(area);
%Output and Plot Area over Time (Image Number)
subplot(1,1,1);
hold on;
plot(knownAreas);
plot(areas);
hold off;
%Output and Plot Change in Area over Time
subplot(1,2,2);
hold on;
plot(d_knownArea);
plot(d_areas);
hold off;
%Relation to what is bad

%Asymmetry (TOM)
%Output and Plots metrics over Time (Image Number)
%Relation to what is bad



%Color Variation (Kristen)
%Finding changes between Images, etc.




%Generate Table here (


