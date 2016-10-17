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
        theseFiles(x) = files(i);
        x = x + 1;
    end
end

%Get rid of DS_Strore (TOMMY)


files = theseFiles;


%% Assess each image
%Data Array
field1 = 'Image';  value1 = [];
field2 = 'BorderXY';  value2 = [];
field3 = 'ImageBorder';  value3 = [];
field4 = 'Area';  value4 = [];
field5 = 'Asymmetry'; value5 = [];
field6 = 'ColorVariation'; value6 = [];

dataArray = struct(field1,value1,field2,value2,field3,value3,field4,value4, field5, field6);

%For each image:
for i = 1:length(files)
    %Load Image
    Image = imread(files(i).name);   
    
    %Border Detection
    [BorderXY, ImageBorder] = BorderDetection(Image);
    BorderXY = BorderXY{1};
    BorderXY = [BorderXY(:,2) BorderXY(:,1)]; %Making it XY points
    
    %Border-Thining
    BorderXY = BorderThining(BorderXY);
    
    %Generate Border Contour
    plot(BorderXY(:,1) ,BorderXY(:,2));
    hold on;
    figure;
    title('Border Outline');
    
    %Calc Size
    Area =  CalcSize(BorderXY, ImageBorder);
    
    %Calc Assymetry
    Asymmetry = CalcAssymetry(BorderXY, ImageBorder, Area);
    
    %Calc Color Variation
    ColorVariation = CalcColorVariation(Image, BorderXY, ImageBorder);
    
    %Data Storage
    dataArray(i).Image = Image;
    dataArray(i).BorderXY = BorderXY;
    dataArray(i).ImageBorder = ImageBorder;
    dataArray(i).Area = Area;
    dataArray(i).Asymmetry = Asymmetry;
    dataArray(i).ColorVariation = ColorVariation;
end

%% Time-Lapse
%Generate Time-Lapse Data and Generate Plots

%Border Change over time/Contour Map (Kristen)
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
    currentArea = CalcSize(BorderXY,ImageBorder);   %are we storing these somewhere aka do I need to recalculate
    moleArea{end+1}=currentArea;
end
area = cell2mat(moleArea);
d_area = diff(area);
subplot(1,1,1);
hold on;
plot(knownAreas);
plot(areas);
hold off;
subplot(1,2,2);
hold on;
plot(d_knownArea);
plot(d_areas);
hold off;
    %Output and Plot Area over Time (Image Number)
    %Output and Plot Change in Area over Time
    %Relation to what is bad
    
%Asymmetry (TOM)
    %Output and Plots metrics over Time (Image Number)
    %Relation to what is bad
    

    
%Color Variation (Kristen)
    %Finding changes between Images, etc.  
    

    
    



