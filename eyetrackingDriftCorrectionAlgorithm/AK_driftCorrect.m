function [ newCoordinates ] = AK_driftCorrect( rawCoordinates, fixationCoordinates, stimCoordinates )
%AK_driftCorrect applies a post-hoc drift correction to the xy-coordinates
%of eye tracking data. This drift correction is meant to minimize the
%distance between fixations and likely coordinates of fixation (coordinates
%where there are stimuli) within this block of eye tracking data. Based on
%Vadillo et al. (2015).
%   INPUT:
%       rawCoordinates: a matrix containing the raw coordinates of eye
%           tracking data with the dimensions x-coordinates at row 1,
%           y-coordinates at row 2, and time encoded as columns;
%           coordinates should be in degrees visual angle
%       fixationCoordinates: the xy-coordinates of fixations within this
%           block of eyetracking data; dimensions and units should match
%           rawCoordinates except for the fact that for this matrix columns
%           encode different fixations; it is recommended that fixations
%           are identified using the function AK_defineFixations which
%           implements a dispersion-based fixation detection algorithm
%           (Anliker, 1976; Blignaut, 2009)
%       stimCoordinates: the xy-coordinates of stimuli on the display;
%           dimensions and units should match rawCoordinates except for the
%           fact that in this matrix columns encode different possible
%           stimulus locations; the algorith considers these coordinates as
%           locations where the subject is likely to have been looking
%           during a fixation; the correction applied will minimize the
%           distance between the set of fixation coordinates provided and
%           the locations of stimuli on the screen
%   OUTPUT:
%       newCoordinates: a version of the given raw coordinates with the
%           optimal drift correction applied which minimizes the distance
%           between the set of fixation coordinates provided and
%           the locations of stimuli on the screen
%   NOTES:
%       The original algorithm from Vadillo et al. (2015) applies a
%       multiplicative correction to the gaze coordinates which rescales
%       eye movements so that fixations map as closely as possible to the
%       locations of stimuli on the screen. It is important to note that
%       this rescaling affects the magnitude of the variablity in the eye
%       tracking signal; the idea is that this corrects for poor
%       calibration post-hoc. However, for some experimental designs, this
%       rescaling can render the eye tracking data meaningless. For
%       example, if the only stimulus location is at the center of the
%       screen degrees visual angle = (0, 0), the optimal multiplicative
%       correction for both the x- and y-coordinates will be close to zero
%       and the resulting drift corrected coordinates will be sucked in
%       toward the center of the screen, thus eliminating any variablity in
%       the signal. For this reason, I have implemented an additive version
%       of the algorithm which is more conservative because it does not
%       rescale the data but rather translates the x- and y-coordinates
%       independently in order to minimize the distance between fixations
%       and the locations of stimuli on the screen. This additive version
%       is what I've used in the UW Murray Lab's GABA in ASD project, where
%       I was mostly concerned with how well participants were fixating at
%       the center of the screen during our fMRI sessions. TO TOGGLE
%       BETWEEN THE ADDITIVE AND MULTIPLICATIVE VERSIONS OF THE ALGORITHM,
%       CHANGE THE BOOLEAN VALUE 'additive' IN THE CODE BELOW.
%       It is important to note that the number of fixations and the number
%       of stimulus locations has a large effect on the results of this
%       algorithm. I have discussed some issues regarding the number of
%       stimulus locations as a motivation for the additive version of the
%       algorithm. Vadillo et al. (2015) study the impact of the number of
%       fixations on the algorithm's performance. They find that the
%       quality of corrections improves with the number of fixation
%       coordinates provided and that very low number of fixations can
%       produce drift corrected data in which fixations are further from
%       the stimulus coordinates than in the raw data. This happens because
%       some fixations will not be at stimulus locations, and providing the
%       algorithm with a greater number of fixation coordinates makes the
%       results more robust to stimulus-irrelevant fixations. Vadillo et
%       al. recommend using at least eight to ten fixations for drift
%       correction.
%       
%   References:
%       Anliker, J. 1976. Eye movements- On-line measurement, analysis,
%           and control. Eye movements and psychological processes,
%           185–199.
%       Blignaut, P. (2009). Fixation identification: The optimum threshold for
%           a dispersion algorithm. Attention, Perception & Psychophysics,
%           71(4), 881–895. http://doi.org/10.3758/APP
%       Vadillo, M. A., Street, C. N. H., Beesley, T., & Shanks, D. R.
%           (2015). A simple algorithm for the offline recalibration of
%           eye-tracking data through best-fitting linear
%           transformation. Behavior Research Methods, 47(4), 1365–1376.
%           http://doi.org/10.3758/s13428-014-0544-1

% additive vs multiplicative version (see note above)
additive = true;

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
    if additive
        Tprior = [0;0]; % starting point for transformation matrix; for additive version
    else% original multiplicative algorithm from Vadillo et al. (2015)
        Tprior = [1 0;0 1]; % starting point for transformation matrix; identity matrix; for multiplicative, original algorithm
    end
    T = fminsearch(@avgDistanceToClosestFixation,Tprior); % least squares optimization of average distance from fixations to nearest possible stim location 

    % apply drift correction transformation
    if additive
        newCoordinates(1,:) = T(1)+rawCoordinates(1,:); newCoordinates(2,:) = T(2)+rawCoordinates(2,:); % additive version
    else % original multiplicative algorithm from Vadillo et al. (2015)
        newCoordinates = (T*rawCoordinates); % multiplicative version
    end
end

    function avgDistance = avgDistanceToClosestFixation(transformation)
        % apply transformation to fixation coordinates
        if additive
            coords(1,:) = transformation(1)+fixationCoordinates(1,:); coords(2,:) = transformation(2)+fixationCoordinates(2,:); % additive version
        else % original multiplicative algorithm from Vadillo et al. (2015)
            coords = (transformation*fixationCoordinates); % multiplicative version
        end
        
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

