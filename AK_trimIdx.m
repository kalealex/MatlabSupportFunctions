function [ trimIdx ] = AK_trimIdx( array, percent, trimSide )
%AK_trimIdx creates and index of values to trim from an array. The
%trimming of the values where this index == 1 will result in the trimming
%of the passed percent of values from the high or low end of the
%distribution of values, or an even split of both depending on the
%parameters passed to the function.
%   INPUT:
%       array: an a array of doubles to trim
%       percent: the percent of the extreme values of the distribution of
%           values in the array to be trimmed
%       trimSide: a string which determines what part of the
%           distribution to be trimmed: the 'high' end of the distribution,
%           the 'low' end of the distribution, or 'both' the high and low
%           end of the distribution
%   OUTPUT:
%       trimIdx: an index of values in the array; where index == 1 values
%           in the array should be trimmed in order to create a resulting
%           array which is trimmed according to the specifications passed
%           to this function

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

