function [ result ] = AK_structfun( functionHandle, structure, fieldStr, fieldIndexStr )
%AK_structfun is a very limited version of Matlab's arrayfun function
%created to deal with structure arrays. The given function is applied to a
%designated field of the structure at each unit in the array, with the
%option to select an index into the field.
%   INPUT:
%       functionHandle: the function handle of the function to be applied
%           to each unit of the structure
%       structure: the structure to be iterated over and evaluated using
%           the given function
%       fieldStr: the name of the field in the structure to be accessed (as
%           a string)
%       fieldIndexStr[optional]: a index into the given field of the
%           structure to be used when evaluating the given function on the
%           given structure; if left undesignated, no indexing will be
%           applied to the selected field
%   OUTPUT:
%       result: an array containing the result of the function evaluation
%           on the designated field of the given structure for each unit of
%           the structure

% check input
if nargin < 3
    error('AK_structfun requires at least three inputs: a function handle, a structure, and a field name as a string')
end
if ~ischar(functionHandle)
    % function handle should be function name as a string
    functionHandle = func2str(functionHandle);
end


% preallocate
result = nan(size(structure));

for i = 1:length(structure)
    if exist('fieldIndexStr','var')
        evalStr = [functionHandle '(structure(' num2str(i) ').' fieldStr '(' num2str(fieldIndexStr) '))'];
    else
        evalStr = [functionHandle '(structure(' num2str(i) ').' fieldStr ')'];
    end
    result(i) = eval(evalStr);
end

end

