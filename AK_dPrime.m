function [ dPrime ] = AK_dPrime( n_trials_signal, n_trials_no_signal, hits, false_alarms )
%AK_dPrime determines d prime (the discriminability index) for
%signal among noise in a signal detection paradigm
%   Inputs are as follows: number of trials where signal is presented,
%   number of trials where signal is not presented, number of of hits
%   (correct signal detections), and number of false alarms (responses to no
%   signal stimuli).
%   Output is d prime, calculated as follows: rate of hits per signal stim
%   presentations and rate of false alarms per non-signal trials are
%   calculated (1 - false alarm rate = correct rejection rate); a normal pdf
%   is used to assign z-scores to the hit rate and correct rejection rate 
%   respectively; and d prime = z(hit rate) + z(correct rejection rate).
% NOTE: this function uses Geoff Boynton's 'inverseNormalCDF.m'

% check arguments
if nargin < 4
    error('AK_dPrimeBinomial requires 6 arguments: number of trials with signal, number of trials without signal, hits, & false alarms');
end

% calculate hit & false alarm rates
hit_rate = hits/n_trials_signal;
false_alarm_rate = false_alarms/n_trials_no_signal;

% make adjustments to avoid meaningles dPrime values
% for hit rate:
if hit_rate==1
    % adjustment = half way between 100% and next best possible performance
    adjustment = 1/(2*n_trials_signal); 
    hit_rate = hit_rate - adjustment;
elseif hit_rate==0
    % adjustment = half way between 0% and next worst possible performance
    adjustment = 1/(2*n_trials_signal); 
    hit_rate = hit_rate + adjustment;
end
% for false alarm rate
if false_alarm_rate==1
    % adjustment = half way between 100% and next worst possible performance
    adjustment = 1/(2*n_trials_no_signal); 
    false_alarm_rate = false_alarm_rate - adjustment;
elseif false_alarm_rate==0
    % adjustment = half way between 0% and next best possible performance
    adjustment = 1/(2*n_trials_no_signal); 
    false_alarm_rate = false_alarm_rate + adjustment;
end
    
% find correct rejection rate
correct_rejection_rate = 1-false_alarm_rate;

% calculate z-scores corresponding to hit and false alarm rates
z_hits = inverseNormalCDF(hit_rate);
z_correct_rejections = inverseNormalCDF(correct_rejection_rate);

% calculate d prime
dPrime = z_hits + z_correct_rejections;

end

