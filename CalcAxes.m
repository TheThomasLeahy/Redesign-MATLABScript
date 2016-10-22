function [MajorAxis,MinorAxis] = CalcAxes( I )
%Code by Mahy Hussain
%Finds the major and minor axis lengths of a mole from binary image
%Returns major and minxor aixs lengths in pixels

axes = regionprops(I,'MajorAxisLength','MinorAxisLength');
MajorAxis = axes.MajorAxisLength;
MinorAxis = axes.MinorAxisLength;
end