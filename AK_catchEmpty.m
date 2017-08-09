function [ outArg ] = AK_catchEmpty( inArg, outClass )
%AK_catchEmpty trys to evaluate a section of Matlab code and either returns
%the result or, in the case that there is an indexing error, an empty
%variable of the designated data type. Use this when you are not sure
%whether or not you will receive and indexing error but you do not want
%that to prevent your code from running to completion. 
%   INPUT:
%       inArg: the matlab code to be evaluated (as a string); this code
%           will be evaluated in the scope in which the function is called
%       outClass: the data type (Matlab calls these classes) which you
%           would like the output of the function to be in the case that it
%           returns an empty variable 
%   OUTPUT:
%       outArg: either the result of the evaluated Matlab code OR an empty
%           variable of the designated data type; this function will try to
%           evaluate your code, and if it hits an 'Index exceeds matrix
%           dimensions.' error it will return an empty variable

% check input
if nargin ~= 2 || ~ischar(inArg) || ~ischar(outClass)
    error('AK_catchEmpty requires two inputs: 1) Matlab code to evaluate (string); 2) the class of the output (string)')
end

% classes to check
classes = {'cell','char','table'}; % the 'double' class is tacitly included (see below)

try
    % try evaluating the input argument
    outArg = evalin('caller',inArg); 
catch ME
    switch ME.message
        case 'Index exceeds matrix dimensions.'
            % catch by filling the output argument with an empty element of the proper type 
            whichClass = AK_findStrMatch(classes,outClass,1);
            if whichClass(1)==1 % cell out
                outArg = {[]};
            elseif whichClass(2)==1 % char out
                outArg = '';
            elseif whichClass(3)==1 % table out
                outArg = table([]);
            else % double out
                outArg = [];
            end
        otherwise
            rethrow(ME)
    end
end

end

