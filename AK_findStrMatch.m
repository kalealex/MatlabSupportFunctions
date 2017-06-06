function [ cell_array_index ] = AK_findStrMatch( cell_array_str, match_str, insensitiveYN )
%AK_findStrMatch finds matches between wildcard match_str and a subset of
% some cell_array_str and returns a logical array of indices in cell_array_str

if nargin < 2; % error message trigger
    error('AK_findStrMatch requires at least two arguments');
elseif nargin < 3
    insensitiveYN = 0; % default to case sensitivity
end
if any(cellfun(@isnumeric,cell_array_str)) % no numeric values in cell array of strings
    numIdx = cellfun(@isnumeric,cell_array_str);
    cell_array_str(numIdx) = cellfun(@num2str,cell_array_str(numIdx),'UniformOutput',false); % change doubles to strings
end

cell_array_index = zeros(length(cell_array_str),1); % preallocate for speed

if ~all(cellfun(@isempty,cell_array_str))
    if insensitiveYN==1
        for C = 1:length(cell_array_str); % cycle through cell array
            cell_array_index(C) = ~isempty(regexpi(cell_array_str{C},regexptranslate('wildcard',match_str), 'once'));
        end
    else
        for C = 1:length(cell_array_str); % cycle through cell array
            cell_array_index(C) = ~isempty(regexp(cell_array_str{C},regexptranslate('wildcard',match_str), 'once'));
        end
    end
end

cell_array_index = logical(cell_array_index); % transform index into logical

end

