function [ nanPadMat ] = AK_nanPad( Mat, Dimensions, iStart )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% check inputs
if nargin < 3; 
    error('AK_nanPad requires three arguments')
end

% create function output
nanPadMat = nan(Dimensions);

% insert Matrix into output
nanPadMat(iStart(1):length(Mat(:,1)),iStart(2):length(Mat(1,:))) = Mat;

end

