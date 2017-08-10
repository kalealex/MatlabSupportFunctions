function [ fixations ] = AK_defineFixations( PORtuples, radiusThreshold, minDur )
%AK_defineFixations returns indices, xy coordinates, and radii of fixations
%within an array of tuples ([x,y,time]; each tuple representing a point of 
%regard (POR)) of raw eye tracking data (in degrees visual angle). Fixation 
%is defined as a continuous set of tuples of some minimum duration (in
%milliseconds) for which the maximum distance of any member of the set of
%tuples from the set's centroid does not exceed some threshold radius (in
%degrees visual angle). This definition of fixation is a dispersion-based
%fixation detection algorithm (Anliker, 1976; Blignaut, 2009).
%   INPUT:
%       PORtuples:  a 2D matrix of point of regard (POR) tuples of raw eye
%          tracking data (number of observations by [x, y, time]); these data
%          should be in degrees visual angle and millisecords; each POR
%          should coorespond to an individual point of eye tracking data
%       radiusThreshold: this parameter defines the maximum dispersion of any 
%           set of PORs which will be considered a fixation by the algorithm;
%           dispersion is defined as the maximum radial distance of any POR from
%           the centroid of the set of PORs 
%       minDur: this parameter defines the minimum duration (in
%           milliseconds) of any set of PORs which will be considered a fixation 
%           by the algorithm
%   OUTPUT:
%       fixations: a structure of length = number of fixations; structure
%           fields are as follows:
%           timeIdx: indices of the current fixtion in terms of the input
%             PORtuples
%           coordinates: xy coordinates (in degrees visual angle) of the
%               centroid of the current fixation
%           radius: the radius (in degrees visual angle) of the current
%               fixation
%   CAUTION: as noted in Blignaut (2009), function output is highly
%       sensative to input parameters; optimal parameter values depend on task
%       but often fall within the ranges radiusThreshold = .7 to 1.3 degrees 
%       and minDur = 100 to 200 milliseconds
%
%   References:
%       Anliker, J. 1976. Eye movements- On-line measurement, analysis,
%           and control. Eye movements and psychological processes,
%           185–199.
%       Blignaut, P. (2009). Fixation identification: The optimum threshold for
%           a dispersion algorithm. Attention, Perception & Psychophysics,
%           71(4), 881–895. http://doi.org/10.3758/APP


%check inputs
if nargin < 3
    error(['AK_defineFixations requires three inputs: ' ...
        'PORtuples: a 2D matrix of point of regard tuples of raw eye tracking data (number of observations by x, y, & t); '...
        'radiusThreshold: the largest distance from the center of fixation to any POR in the fixation ( in degrees visual angle); '...
        'minDur: the minimum duration of a fixation (in milliseconds)']); 
end


%preallocate variables
iT = 1; % counter for current tuple
fixations = struct; % structure for storing information about flagged fixations
iF = 1; % counter for current fixation

% cycle through all tuples flagging fixations
while iT < length(PORtuples(:,1))
    
    % initialize temporal window of the minimum fixation duration in terms of an index into PORtuples
    clear tempIdx temporalWindow dispersion centroid
    [~,tempIdx] = min(abs(PORtuples(:,3)-(PORtuples(iT,3)+minDur))); % find index of time==time(iT)+minDur (this syntax works regardless of sampling rate)
    temporalWindow = iT:tempIdx;
    
    % determine whether dispersion is less than threshold within temporalWindow; 
    % avoid indexing where there is a blink and indexing non-existing PORs
    if all(~isnan(PORtuples(temporalWindow,1))) && all(~isnan(PORtuples(temporalWindow,2))) && tempIdx<=length(PORtuples(:,1))
        [dispersion,~] = findDispersion(PORtuples(temporalWindow,1),PORtuples(temporalWindow,2));
        if dispersion <= radiusThreshold
            
            % add tuples to temporal window until dispersion exceeds threshold for fixation
            while dispersion <= radiusThreshold 
                tempIdx = tempIdx+1; % add next tuple to temporal window
                temporalWindow = iT:tempIdx; 
                % avoid indexing where there is a blink and indexing non-existing PORs
                if tempIdx<=length(PORtuples(:,1)) && all(~isnan(PORtuples(temporalWindow,1))) && all(~isnan(PORtuples(temporalWindow,2))) 
                    [dispersion,~] = findDispersion(PORtuples(temporalWindow,1),PORtuples(temporalWindow,2)); % recalculate dispersion
                else
                    dispersion = radiusThreshold+1; % exit while loop
                end
            end
            
            % remove the last POR added
            tempIdx = tempIdx-1;
            temporalWindow = iT:tempIdx;
            [dispersion,centroid] = findDispersion(PORtuples(temporalWindow,1),PORtuples(temporalWindow,2));
            
            % note fixation temporal window index, centroid coordinates, and dispersion radius
            fixations(iF).timeIdx = temporalWindow;
            fixations(iF).coordinates = centroid;
            fixations(iF).radius = dispersion;
            iF = iF+1; % add to fixation counter
            
            % reset beginning of temporal window to the next POR after the current fixation
            iT = tempIdx+1;
        else
            % advance the beginning of the temporal window by one POR
            iT = iT+1;
        end
    else
        % advance the beginning of the temporal window by one POR
        iT = iT+1;
    end
end
        
end

% dispersion is defined as the maximum radial distance of any POR from
% the centroid of the set of PORs within the current temporal window
function [dispersion, centroid] = findDispersion( X, Y )
    % find centeroid coordinates
    centerX = mean(X);
    centerY = mean(Y);
    % determine distance of each point from centroid
    distance = sqrt((X-centerX).^2 + (Y-centerY).^2);
    % dispersion radius =  maximum distance of any tuple from the centroid of all tuples within the fixation
    dispersion = max(distance);
    centroid = [centerX centerY];
end


