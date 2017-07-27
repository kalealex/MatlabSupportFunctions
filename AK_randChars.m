function [ randChars ] = AK_randChars( lengthOfStr, numStr, charType )
%AK_randChars generates a cell array of strings each containing a unique
%random character array of a specified length.
%   INPUT:
%       lengthOfStr: the number of characters desired in each random
%       sequence
%       numStr: the number of unique random character sequences
%       charType: a sting describing the kinds of characters to include
%           (i.e., 'letters' or 'lower' for lower case letters, 'upper' for
%           upper case letters, and 'numbers' or 'digits for numbers)
%   OUTPUT:
%       randChars: a cell array of unique random character arrays matching
%       the specifications of the function arguments

% check input
if nargin < 2
   error('AK_randChars requires at least two arguments: (1) the desired length of the random character sequence; and (2) the number of random character sequences.');
end
if nargin < 3
    % default to including letters (upper and lower case) and numbers
    charType = 'upper lower numbers';
end
% generate arrays of potential characters to include
lettersLowerCase = char('a':'z');
lettersUpperCase = char('A':'Z');
numbers = char('0':'9');

% use regexp to determine which sets of characters to include
set = '';
if regexpi(charType,'.(letter[s]?|lower).')
    % include lower case letters
    set = [set lettersLowerCase];
end
if regexpi(charType,'.upper.')
    % include upper case letters
    set = [set lettersUpperCase];
end
if regexpi(charType,'.(number[s]?|digit[s]?).')
    % include numbers
    set = [set numbers];
end

% generate unique strings of characters
randChars = cell(0);
i = 0; % counter
while length(randChars) < numStr
    % generate random index of set of desired length and sample a random
    % string from the set
    idx = randi(numel(set),[lengthOfStr 1]);
    str = set(idx);
    % guarantee unique character arrays
    if ~ismember(str,randChars)
        i = i + 1;
        randChars{i} = str;
    end
end

end

