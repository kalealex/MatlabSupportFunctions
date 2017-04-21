function [ newCoordinates ] = AK_driftCorrect( rawCoordinates, fixationCoordinates, stimCoordinates )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here


% check inputs
if nargin < 3
    error(['AK_defineFixations requires three inputs: ' ...
        'rawCoordinates: a 2D matrix of point of regard tuples of raw eye tracking data (x&y by number of observations); '...
        'fixationCoordinates: a 2D matrix of points identified as the centroids of fixations within rawCoordinates (x & y by number of observations); '...
        'stimCoordinates: a 2D matrix of coordinates of stimuli on which the participant might be fixating (x & y by number of stimuli)']); 
end

% generate optimal drift correction based on coordinates of fixations and stimulus objects
if isempty(fixationCoordinates)
    % no correction when there are no fixations in the raw data
    newCoordinates = rawCoordinates;
else
    % generate optimal drift correction transformation for a set of fixations
    Tprior = [0;0]; % starting point for transformation matrix; for additive version
    % Tprior = [1 0;0 1]; % starting point for transformation matrix; identity matrix; for multiplicative, original algorithm
    T = fminsearch(@avgDistanceToClosestFixation,Tprior); % least squares optimization of average distance from fixations to nearest possible stim location 

    % apply drift correction transformation
    newCoordinates(1,:) = T(1)+rawCoordinates(1,:); newCoordinates(2,:) = T(2)+rawCoordinates(2,:); % additive version
    % newCoordinates = (T*rawCoordinates); % multiplicative (original algorithm)
end

    function avgDistance = avgDistanceToClosestFixation(transformation)
        % apply transformation to fixation coordinates
        coords(1,:) = transformation(1)+fixationCoordinates(1,:); coords(2,:) = transformation(2)+fixationCoordinates(2,:); % additive version
    %     coords = (transformation*fixationCoordinates); % multiplicative (original algorithm)

        distClosest = zeros(1,size(coords,2)); % preallocate variable
        for fixNum = 1:size(coords,2)
            dist = zeros(1,size(stimCoordinates,2)); % preallocate variable
            for stimNum = 1:size(stimCoordinates,2);
                % create list of distances from current fixation to each stimulus location
                dist(stimNum) = norm(coords(:,fixNum)-stimCoordinates(:,stimNum));
            end
            % create list of distances to nearest stimulus location for each fixation
            distClosest(fixNum) = min(dist);
        end
        % calculate the average distance to the nearist stimulus location for all fixations;
        % this is the variable that is optimized
        avgDistance = mean(distClosest); 
    end


end

