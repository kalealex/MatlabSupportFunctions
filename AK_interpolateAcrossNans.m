function [ signalOut ] = AK_interpolateAcrossNans( signalIn )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

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

