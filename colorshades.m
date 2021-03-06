function colorshades(rgbImage, mask)
	fontSize = 14;
	figure; 
	set(gcf, 'Position', get(0, 'ScreenSize')); 
	set(gcf,'name','Color Matching Demo by ImageAnalyst','numbertitle','off') 
 
	[rows columns numberOfColorBands] = size(rgbImage);  
	if strcmpi(class(rgbImage), 'uint8')
		% Flag for 256 gray levels.
		eightBit = true;
	else
		eightBit = false;
	end
	if numberOfColorBands == 1
		if isempty(storedColorMap)
			rgbImage = cat(3, rgbImage, rgbImage, rgbImage);
		else
			%indexed image.
			rgbImage = ind2rgb(rgbImage, storedColorMap);
			if eightBit
				rgbImage = uint8(255 * rgbImage);
			end
		end
	end
	
	% Display the original image.
	h1 = subplot(3, 4, 1);
	imshow(rgbImage);
	drawnow; % Make it display immediately. 
	if numberOfColorBands > 1 
		title('Original Color Image', 'FontSize', fontSize); 
	else 
		caption = sprintf('Original Indexed Image\n(converted to true color with its stored colormap)');
		title(caption, 'FontSize', fontSize);
	end
	
	% Mask the image.
	maskedRgbImage = bsxfun(@times, rgbImage, cast(mask, class(rgbImage)));
	% Display it.
	subplot(3, 4, 5);
	imshow(maskedRgbImage);
	title('Mask', 'FontSize', fontSize); 

	% Convert image from RGB colorspace to lab color space.
	cform = makecform('srgb2lab');
	lab_Image = applycform(im2double(maskedRgbImage),cform);
	
	% Extract out the color bands from the original image
	% into 3 separate 2D arrays, one for each color component.
	LChannel = lab_Image(:, :, 1); 
	aChannel = lab_Image(:, :, 2); 
	bChannel = lab_Image(:, :, 3); 
	
	% Display the lab images.
	subplot(3, 4, 2);
	imshow(LChannel, []);
	title('L Channel', 'FontSize', fontSize);
	subplot(3, 4, 3);
	imshow(aChannel, []);
	title('a Channel', 'FontSize', fontSize);
	subplot(3, 4, 4);
	imshow(bChannel, []);
	title('b Channel', 'FontSize', fontSize);

	% Get the average lab color value.
	[LMean, aMean, bMean] = GetMeanLABValues(LChannel, aChannel, bChannel, mask);
	
	% Get box coordinates and get mean within the box.
% 	x1 = round(roiPosition(1));
% 	x2 = round(roiPosition(1) + roiPosition(3) - 1);
% 	y1 = round(roiPosition(2));
% 	y2 = round(roiPosition(2) + roiPosition(4) - 1);
% 	
% 	LMean = mean2(LChannel(y1:y2, x1:x2))
% 	aMean = mean2(aChannel(y1:y2, x1:x2))
% 	bMean = mean2(bChannel(y1:y2, x1:x2))

	% Make uniform images of only that one single LAB color.
	LStandard = LMean * ones(rows, columns);
	aStandard = aMean * ones(rows, columns);
	bStandard = bMean * ones(rows, columns);
	
	% Create the delta images: delta L, delta A, and delta B.
	deltaL = LChannel - LStandard;
	deltaa = aChannel - aStandard;
	deltab = bChannel - bStandard;
	
	% Create the Delta E image.
	% This is an image that represents the color difference.
	% Delta E is the square root of the sum of the squares of the delta images.
	deltaE = sqrt(deltaL .^ 2 + deltaa .^ 2 + deltab .^ 2);
	
	% Mask it to get the Delta E in the mask region only.
	maskedDeltaE = deltaE .* mask;
	% Get the mean delta E in the mask region
	% Note: deltaE(mask) is a 1D vector of ONLY the pixel values within the masked area.
 	meanMaskedDeltaE = mean(deltaE(mask));
	% Get the standard deviation of the delta E in the mask region
	stDevMaskedDeltaE = std(deltaE(mask));
	message = sprintf('The mean LAB = (%.2f, %.2f, %.2f).\nThe mean Delta E in the masked region is %.2f +/- %.2f',...
		LMean, aMean, bMean, meanMaskedDeltaE, stDevMaskedDeltaE);	
	
	% Display the masked Delta E image - the delta E within the masked region only.
	subplot(3, 4, 6);
	imshow(maskedDeltaE, []);
	caption = sprintf('Delta E between image within masked region\nand mean color within masked region.\n(With amplified intensity)');
	title(caption, 'FontSize', fontSize);

	% Display the Delta E image - the delta E over the entire image.
	subplot(3, 4, 7);
	imshow(deltaE, []);
	caption = sprintf('Delta E Image\n(Darker = Better Match)');
	title(caption, 'FontSize', fontSize);

	% Plot the histograms of the Delta E color difference image,
	% both within the masked region, and for the entire image.
	PlotHistogram(deltaE(mask), deltaE, [3 4 8], 'Histograms of the 2 Delta E Images');
	
	message = sprintf('%s\n\nRegions close in color to the color you picked\nwill be dark in the Delta E image.\n', message);
	msgboxw(message);

	% Find out how close the user wants to match the colors.
	prompt = {sprintf('First, examine the histogram.\nThen find pixels within this Delta E (from the average color in the region you drew):')};
	dialogTitle = 'Enter Delta E Tolerance';
	numberOfLines = 1;
	% Set the default tolerance to be the mean delta E in the masked region plus two standard deviations.
	strTolerance = sprintf('%.1f', meanMaskedDeltaE + 3 * stDevMaskedDeltaE);
	defaultAnswer = {strTolerance};  % Suggest this number to the user.
	response = inputdlg(prompt, dialogTitle, numberOfLines, defaultAnswer);
	% Update tolerance with user's response.
	tolerance = str2double(cell2mat(response));

	% Let them interactively select the threshold with the threshold() m-file.
	% (Note: This is a separate function in a separate file in my File Exchange.)
% 	threshold(deltaE);
	
	% Place a vertical bar at the threshold location.
	handleToSubPlot8 = subplot(3, 4, 8);  % Get the handle to the plot.
	PlaceVerticalBarOnPlot(handleToSubPlot8, tolerance, [0 .5 0]);  % Put a vertical red line there.
	
	% Find pixels within that delta E.
	binaryImage = deltaE <= tolerance;
	subplot(3, 4, 9);
	imshow(binaryImage, []);
	title('Matching Colors Mask', 'FontSize', fontSize);
	
	% Mask the image with the matching colors and extract those pixels.
	matchingColors = bsxfun(@times, rgbImage, cast(binaryImage, class(rgbImage)));
	subplot(3, 4, 10);
	imshow(matchingColors);
	caption = sprintf('Matching Colors (Delta E <= %.1f)', tolerance);
	title(caption, 'FontSize', fontSize);

	% Mask the image with the NON-matching colors and extract those pixels.
	nonMatchingColors = bsxfun(@times, rgbImage, cast(~binaryImage, class(rgbImage)));
	subplot(3, 4, 11);
	imshow(nonMatchingColors);
	caption = sprintf('Non-Matching Colors (Delta E > %.1f)', tolerance);
	title(caption, 'FontSize', fontSize);

	% Alert user that the demo has finished.
	message = sprintf('Done!\n\nThe demo has finished.\nRegions close in color to the color you picked\nwill be dark in the Delta E image.\n');
	msgbox(message);

return; 

% Get the average lab within the mask region.
function [LMean, aMean, bMean] = GetMeanLABValues(LChannel, aChannel, bChannel, mask)
try
	LVector = LChannel(mask); % 1D vector of only the pixels within the masked area.
	LMean = mean(LVector);
	aVector = aChannel(mask); % 1D vector of only the pixels within the masked area.
	aMean = mean(aVector);
	bVector = bChannel(mask); % 1D vector of only the pixels within the masked area.
	bMean = mean(bVector);
catch ME
	errorMessage = sprintf('Error running GetMeanLABValues:\n\n\nThe error message is:\n%s', ...
		ME.message);
	WarnUser(errorMessage);
end
return; % from GetMeanLABValues

%==========================================================================================================================
function WarnUser(warningMessage)
	uiwait(warndlg(warningMessage));
	return; % from WarnUser()
	
%==========================================================================================================================
function msgboxw(message)
	uiwait(msgbox(message));
	return; % from msgboxw()
	
%==========================================================================================================================
% Plots the histograms of the pixels in both the masked region and the entire image.
function PlotHistogram(maskedRegion, doubleImage, plotNumber, caption)
try
	fontSize = 14;
	subplot(plotNumber(1), plotNumber(2), plotNumber(3)); 

	% Find out where the edges of the histogram bins should be.
	maxValue1 = max(maskedRegion(:));
	maxValue2 = max(doubleImage(:));
	maxOverallValue = max([maxValue1 maxValue2]);
	edges = linspace(0, maxOverallValue, 100);

	% Get the histogram of the masked region into 100 bins.
	pixelCount1 = histc(maskedRegion(:), edges);

	% Get the histogram of the entire image into 100 bins.
	pixelCount2 = histc(doubleImage(:), edges);

	% Plot the  histogram of the entire image.
	plot(edges, pixelCount2, 'b-');
	
	% Now plot the histogram of the masked region.
	% However there will likely be so few pixels that this plot will be so low and flat compared to the histogram of the entire
	% image that you probably won't be able to see it.  To get around this, let's scale it to make it higher so we can see it.
	gainFactor = 1.0;
	maxValue3 = max(max(pixelCount2));
	pixelCount3 = gainFactor * maxValue3 * pixelCount1 / max(pixelCount1);
	hold on;
	plot(edges, pixelCount3, 'r-');
	title(caption, 'FontSize', fontSize);
	
	% Scale x axis manually.
	xlim([0 edges(end)]);
	legend('Entire', 'Masked');
	
catch ME
	errorMessage = sprintf('Error running PlotHistogram:\n\n\nThe error message is:\n%s', ...
		ME.message);
	WarnUser(errorMessage);
end
return; % from PlotHistogram

%=====================================================================
% Shows vertical lines going up from the X axis to the curve on the plot.
function lineHandle = PlaceVerticalBarOnPlot(handleToPlot, x, lineColor)
	try
		% If the plot is visible, plot the line.
		if get(handleToPlot, 'visible')
			axes(handleToPlot);  % makes existing axes handles.axesPlot the current axes.
			% Make sure x location is in the valid range along the horizontal X axis.
			XRange = get(handleToPlot, 'XLim');
			maxXValue = XRange(2);
			if x > maxXValue
				x = maxXValue;
			end
			% Erase the old line.
			%hOldBar=findobj('type', 'hggroup');
			%delete(hOldBar);
			% Draw a vertical line at the X location.
			hold on;
			yLimits = ylim;
			lineHandle = line([x x], [yLimits(1) yLimits(2)], 'Color', lineColor, 'LineWidth', 3);
			hold off;
		end
	catch ME
		errorMessage = sprintf('Error running PlaceVerticalBarOnPlot:\n\n\nThe error message is:\n%s', ...
			ME.message);
		WarnUser(errorMessage);
end
	return;	% End of PlaceVerticalBarOnPlot


