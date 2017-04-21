function [ whichPattern ] = AK_whichPattern( String, Pattern, ignoreCase )
%AK_whichPattern looks within a string for a list of pattern substrings and
%returns a logical array corresponding to the list of patterns: true
%where the pattern is present in the larger string; false otherwise. 
%   INPUT:
%       String: a string in which to look for substring patterns
%       Pattern: a cell array of substring patterns to look for inside of
%           String
%       ignoreCase[optional]: a logical input which will make the substring
%           finding algorithm ignore case within both inputs; defaults to
%           case sensitivity
%   OUTPUT:
%       whichPattern: a logical array of size Pattern, containing true
%           where the substring pattern was found in the string and false
%           where the pattern was not found

% check input
if nargin < 2
    error('AK_whichPattern requires at least two areguments as input: a string and a cell array of pattern strings to check for inside of that string');
end
if nargin < 3 
    ignoreCase = false; % defaults to case sensitivity
end

whichPattern = zeros(1,length(Pattern));

if ignoreCase
    String = lower(String);
    Pattern = lower(Pattern);
end

for iP = 1:length(Pattern); % cycle through cell array of candidate patterns
    whichPattern(iP) = ~isempty(strfind(String,Pattern{iP})); % 
end

whichPattern = logical(whichPattern);
    
end

