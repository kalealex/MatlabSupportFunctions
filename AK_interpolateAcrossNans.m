function [ signalOut ] = AK_interpolateAcrossNans( signalIn )
%AK_interpolateAcrossNans identifies chuncks of nans in a time series and
%replaces the nans with a linear interpolation across the values before and
%after each series of nans. This kind of thing is a common way to deal with
%blinks in pupil size data but should only be used if interpolation will
%not introduce artifacts into the analysis which are more confounding than
%the blinks.
%   INPUT:
%       signalIn: a vector of time series data where each value corresponds
%           to a point in time; note that the linear interpolation
%           implemented in this function assumes that time series data are
%           sampled at a constant frequency
%   OUTPUT:
%       signalOut: a version of signalIn where series of nans have been
%           replaced with values from a linear interpolation between the
%           values that precede and follow each continuous set of nans

nanIdx = isnan(signalIn);
nanGroupIdx = find(nanIdx(2:end)~=nanIdx(1:end-1));

signalOut = signalIn;

for iG = 1:length(nanGroupIdx)
    if ~isnan(signalIn(nanGroupIdx(iG)))
        if iG == length(nanGroupIdx) 
            % if this is the last non-nan value replace the rest of the signal with this value
            signalOut(nanGroupIdx(iG)+1:end) = signalIn(nanGroupIdx(iG));
        elseif isnan(signalIn(nanGroupIdx(iG)+1)) && isnan(signalIn(nanGroupIdx(iG+1))) && ~isnan(signalIn(nanGroupIdx(iG+1)+1))
            % if this value precedes a group of nans with more data on the other side, interpolate
            signalOut(nanGroupIdx(iG):nanGroupIdx(iG+1)+1) = interp1q([nanGroupIdx(iG); nanGroupIdx(iG+1)+1],[signalIn(nanGroupIdx(iG)); signalIn(nanGroupIdx(iG+1)+1)],[nanGroupIdx(iG):(nanGroupIdx(iG+1)+1)]');
        end
    elseif isnan(signalIn(nanGroupIdx(iG)))
        if iG == 1 && ~isnan(signalIn(nanGroupIdx(iG)+1))
            % if this nan precedes the first non-nan value, replace all values of the signal up to this point with the next non-nan value
            signalOut(1:nanGroupIdx(iG)) = signalIn(nanGroupIdx(iG)+1);
        end
    end
end

end

