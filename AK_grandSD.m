function [ GM, grandSD ] = AK_grandSD( means, SDs, Ns )
%AK_grandSD calculates the aggregate standard deviation of a list of
%descriptive statistics for sub-samples
%   The formula on which this function is based is:
%   grandSD = sqrt( (sum( variance(i) * (n(i)-1) ) + sum( (mean(i) - grandMean)^2 * n(i) )) / (sum( n(i) ) - 1)) )


% check number of arguments; must be at least three
if nargin < 3
    error('Error: AK_grandSD requires at least three arguments')
end

% check that length of arguments is equal
if length(means) ~= length(SDs)
    error('Error: AK_grandSD requires arguments of equal length')
elseif length(means) ~= length(Ns)
    error('Error: AK_grandSD requires arguments of equal length')
elseif length(SDs) ~= length(Ns)    
    error('Error: AK_grandSD requires arguments of equal length')
else
    argL = length(means); % create argument length variable
end

% clean data, keeping argument lengths equal
m = 1; % set counter
while m < argL; % cycle through each position of each argument
    if Ns(m) == 0 || isnan(means(m)) || isnan(SDs(m)) || isempty(means(m)) || isempty(SDs(m)) % remove observations where n = 0 or mean = nan or SD = nan
        means(m) = [];
        SDs(m) = [];
        Ns(m) = [];
        argL = length(means); % modify argument length variable for later use
    else
        m = m + 1; % counter progresses only where element m of argument arrays is left alone
    end
end
    
% calculate grand mean
GM = nanmean(means(1:argL));

% pre-allocate size of wVar and wSqEM
wVar = zeros(size(means));
wSqEM = zeros(size(means));

% cycle through positions in each array to calculate components of grand SD
for p = 1:argL;
    % calculate weighted variances [var*(n-1)]
    wVar(p) = (SDs(p)^2)*(Ns(p)-1);
    %calculate weighted squared errors of means [((mean-GM)^2)*n]
    wSqEM(p) = ((means(p)-GM)^2)*Ns(p);
end
   
% calculate sums of components for grand SD
SwVar = sum(wVar(1:argL)); % Error Sum of Squares
SwSqEM = sum(wSqEM(1:argL)); % Sum of Squared Errors of Means
GN = sum(Ns(1:argL)); % grand sample size

% calculate grand SD
if GN > 1
    grandSD = sqrt((SwVar+SwSqEM)/(GN-1));
else
    grandSD = sqrt((SwVar+SwSqEM)/GN); % avoid nan output for GN = 1
end
    
end

