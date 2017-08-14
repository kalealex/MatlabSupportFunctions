function [ numericChars ] = AK_getNumericChars( string )
%AK_getNumericChars accepts a string as an argument and returns the
%numberic characters of that string as an array of doubles.
%   INPUT:
%       string: a string to find numeric characters in
%   OUTPUT:
%       numericChars: an array of doubles matching the numeric characters
%       in the string argument

% check input
if nargin < 1 || ~ischar(string)
    error('AK_getNumericChars requires a string as input.');
end

% convert each character in the array to a double
numArray = arrayfun(@str2double,string);

numericChars = numArray(~isnan(numArray));

end

