function [ structOut ] = AK_sortStruct( structIn, sortField, substring )
%AK_sortStruct is a function for sorting the units in a structure array
%based on a numarical substring contained within the a designated field of
%the structure. Returns an updated version of the structure. 
%   INPUT:
%       structIn: the structure to be sorted
%       sortField: a numerical index referencing the field to sort by (in
%           the order the fields are displayed when the structure is
%           entered into the command window); this field should contain a
%           string containing a numerical character to sort by
%       substring: the substring to look for in the string stored in the
%           designated field; this substring should directly precede the
%           numerical character to sort by
%   OUTPUT:
%       structOut: the same as structIn, except with the units in the
%           structure array sorted
%
% Example useage:
%   This usage would sort .txt files containing data for this subject based
%   on the session number (i.e., filename = 'subject1-session2.txt').
%
% data_dir = ... % insert directory name here
% % create structure of all .txt files with the subject code in the file name
% file_list = dir(fullfile(data_dir,[subject_code '*.txt'])); 
% % sort the structure by field # 1 (name; aka filename) based on the numerical character which follows the substring 'session'
% file_list = AK_sortStruct(file_list,1,'session');

% check inputs
if nargin < 3
    error('AK_sortStruct requires three inputs: a structure, a numerical index of a field in that structure, and a substring which directly precedes the numerical character to sort by (see documentation)');
end

fields = fieldnames(structIn);
cell = struct2cell(structIn);
sz = size(cell);

% Convert to a matrix
cell = reshape(cell, sz(1), []);

% Make each field a column
cell = cell';

% preliminary sorting
cell = sortrows(cell, sortField);

% Sort by number following substring in sortField
substringIndex = zeros(length(cell(:,sortField)),1); % preallocate
sortValue = zeros(length(cell(:,sortField)),1);
for iR = 1:length(cell(:,sortField)); % cycle through rows of cell
    if ~isempty(strfind(cell{iR,sortField},substring)) % avoid setting substringIndex(iR) = []
        substringIndex(iR) = strfind(cell{iR,sortField},substring); % find substring
    end
    if substringIndex(iR) ~= 0 % the substring exists
        if ~isnan(str2double(cell{iR,sortField}(substringIndex(iR)+length(substring):substringIndex(iR)+length(substring)+1))) % check for 2 digit number
            sortValue(iR) = str2double(cell{iR,sortField}(substringIndex(iR)+length(substring):substringIndex(iR)+length(substring)+1)); % assign sortValue
        elseif ~isnan(str2double(cell{iR,sortField}(substringIndex(iR)+length(substring)))) % check for 1 digit number
            sortValue(iR) = str2double(cell{iR,sortField}(substringIndex(iR)+length(substring))); % assign sortValue
        end
    end
end
[~,sortIndex] = sort(sortValue); % create sort index based on numbers following substring
cell = cell(sortIndex,:); % apply sortIndex

% Put back into original cell array format
cell = reshape(cell', sz);

% Convert to Struct
structOut = cell2struct(cell, fields, 1);

end

