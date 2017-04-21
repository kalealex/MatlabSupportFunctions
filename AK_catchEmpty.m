function [ OutArg ] = AK_catchEmpty( InArg, OutClass )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% check input
if nargin ~= 2 || ~ischar(InArg) || ~ischar(OutClass)
    error('AK_catchEmpty requires two inputs: 1) Matlab code to evaluate (string); 2) the class of the output (string)')
end

% classes to check
classes = {'cell','char','table'};

try
    % try evaluating the input argument
    OutArg = evalin('caller',InArg); 
catch ME
    switch ME.message
        case 'Index exceeds matrix dimensions.'
            % catch by filling the output argument with an empty element of the proper type 
            whichClass = AK_findStrMatch(classes,OutClass,1);
            if whichClass(1)==1 % cell out
                OutArg = {[]};
            elseif whichClass(2)==1 % char out
                OutArg = '';
            elseif whichClass(3)==1 % table out
                OutArg = table([]);
            else 
                OutArg = [];
            end
        otherwise
            rethrow(ME)
    end
end

end

