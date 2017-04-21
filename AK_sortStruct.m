function [ structOut ] = AK_sortStruct( structIn, sortField, substring )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

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

