function [AreaPixel, AreaMM] = CalcSize(~, ImageBorder, ConversionFactor)
%Code by Thomas Leahy
AreaPixel = sum(sum(ImageBorder));
AreaMM = AreaPixel / (ConversionFactor^2);
end

