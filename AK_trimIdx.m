function [ trimIdx ] = AK_trimIdx( array, percent, trimSide )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% check inputs
if nargin<2
    error('AK_trimIdx requires two inputs: an array and a percent to trim')
end
if nargin<3
    trimSide = 'both';
end

% number of values to exclude
nTrimmed = floor(length(array)*(percent/100)/2);

trimIdx = zeros(size(array));

% create index for trimming array
switch trimSide
    case 'both'
        for iT = 1:nTrimmed
            % trim index
            trimIdx(array==max(array)) = 1;
            trimIdx(array==min(array)) = 1;
            % set max and min to zero
            array(array==max(array)) = 0;
            array(array==min(array)) = 0;
        end
    case 'high'
        for iT = 1:nTrimmed*2
            % trim index
            trimIdx(array==max(array)) = 1;
            % set max to zero
            array(array==max(array)) = 0;
        end
    case 'low'
        for iT = 1:nTrimmed*2
            % trim index
            trimIdx(array==min(array)) = 1;
            % set max and min to zero
            array(array==min(array)) = 0;
        end
end

% make logical
trimIdx = logical(trimIdx);

end

