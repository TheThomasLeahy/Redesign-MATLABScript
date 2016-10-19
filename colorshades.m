[A,map] = imread('EditMole1.gif');
[ruler, rulermap]=imcrop(A, map);
figure;
imshow(ruler); colormap(rulermap);

%black = 0.15, 0.15, 0.15 or less =warning 
%pink range 
%white range 0.9412 0.9412 0.9412 = light gray and above is white 
%tan 

%provide number of colors 
%std dev matrix for each 
%images 
%ssi over and over with the same mole across different 


