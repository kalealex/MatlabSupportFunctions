function [ string ] = AK_eraseSubstring( string, substring )
%AK_eraseSubstring removes each instance of a given substring from a given
%string and returns the string with each instance of the substring removed.
%   INPUT:
%       string: a string from which to remove each instance of substring
%       substring: a substring to remove from the string parameter
%   OUTPUT:
%       string: the string parameter with each instance of substring
%           removed from its contents

% check input
if nargin < 2 || ~ischar(string) || ~ischar(substring)
    error('AK_eraseSubstring requires two strings as input');
end

% remove all instances of substring from sting
% starting index of each instance of substring in string
idx = strfind(string, substring);
while ~isempty(idx)
    % remove next instance of substring
    string(idx(1):idx(1) + length(substring) - 1) = [];
    % redefine starting index of each instance of substring in string
    idx = strfind(string, substring);
end

end

