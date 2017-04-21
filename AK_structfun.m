function [ result ] = AK_structfun( functionHandle, structure, fieldStr, fieldIndexStr )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% check input
if nargin < 3
    error('AK_structfun requires at least three inputs: a function handle, a structure, and a field name as a string')
end
if nargin < 4
    % fieldIndex is optional but should at least be initialized as a string
    fieldIndexStr = '';
end
if ~ischar(functionHandle)
    % function handle should be function name as a string
    functionHandle = func2str(functionHandle);
end


% preallocate
result = nan(size(structure));

for i = 1:length(structure)
    evalStr = [functionHandle '(structure(' num2str(i) ').' fieldStr fieldIndexStr ')'];
    result(i) = eval(evalStr);
end

end

