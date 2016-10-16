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
    Assymetry = CalcAssymetry(BorderXY, ImageBorder, Area);
    
    %Calc Color Variation
    ColorVariation = CalcColorVariation(Image, BorderXY, ImageBorder);
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
    %Output and Plot Area over Time (Image Number)
    %Output and Plot Change in Area over Time
    %Relation to what is bad
    
%Asymmetry (TOM)
    %Output and Plots metrics over Time (Image Number)
    %Relation to what is bad
    

    
%Color Variation (Kristen)
    %Finding changes between Images, etc.  
    




