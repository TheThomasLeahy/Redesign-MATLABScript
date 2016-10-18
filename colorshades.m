[A,map] = imread('palette.gif');
imagesc(A); colormap(map);
mask= roipoly();        %mask the color I want to know 



