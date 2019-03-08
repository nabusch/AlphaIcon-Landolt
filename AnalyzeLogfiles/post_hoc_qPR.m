function [ph, out_table] = post_hoc_qPR(INFO, mytrials, varargin)
% perform post-hoc analysis of qPR
%
% MANDATORY inputs:
%
% INFO      <-- output structure from an alphaIcon run
%
% mytrials  <-- NxM matrix, where N are trials and M are the "observers"
%               -or the experimental conditions
%
% OPTIONAL input
%
% cond_names <-- cell with M string entries to provide informative legend
%                to the plot
%
% created by eb on 28-02-2019
% updated by eb on 01-03-2019 to allow a variable number of conditions

% get the number of observers
n_obs = size(mytrials, 2);

% get names for condition and check consistency
if ~isempty(varargin)
    cond_names = varargin{1};
    if numel(cond_names)~=n_obs
        error('detected mismatch between the number of condition names and the number of actual conditions')
    end
end

% print message for starting new participant
fprintf('\n################################################################\n')
fprintf('\nstarting post-hoc analysis for %s \n', INFO.name)

% get evolution parameters and settings from INFO.qPR
evolution_pars = INFO.qPR.evolution_pars;
setting = INFO.qPR.setting;
PST = setting.PST;

% start creating the M entries structure for post-hoc analysis 
ph(n_obs).setting = [];

for iObs = 1:n_obs

    % append the common setting for each observer
    ph(iObs).setting = setting;
    
    % now set the right true parameters for each condition
    % ph(1).setting.TrueParam = setting.TrueParam(1);
    % ph(2).setting.TrueParam = setting.TrueParam(2);


    % prior cration -based on common settings
    ph(iObs).this = qPrior(ph(iObs).setting);


    % assign a count_ex field to each structure in order to count the
    % violation of the "entropy searchlight". 
    [ph(iObs).count_ex, ph(iObs).sugg_soa] = deal(0);
    
    % vectorize mytrials, assigning a value from 1 to M to each condition
    obsVect = mytrials*(1:n_obs)';

    % split the datasets basing on the observer
    ph(iObs).data = evolution_pars(logical(mytrials(:,iObs)),:);
    
    % assign vector of "ones" to be updated into myqpr_sort_resp and keep 
    % track of the already sorted trials
    ph(iObs).not_sorted_trls = ones(size(ph(iObs).data,1), 1);
    
end


% start the loop
int_acc = zeros(1,n_obs);
count_ex = 0; % keep the general count
for iTrial = 1:setting.nTrial

    % fprintf('\ntrial n°: %i \n', iTrial)

    which_obs = obsVect(iTrial);    
    int_acc(which_obs) = int_acc(which_obs)+1;

    % specify trial according to the observer an not to the whole 
    % experiment in the "this" substructure
    ph(which_obs).trial = int_acc(which_obs); 

    % compute entropy
    ph(which_obs).this = qSelect(ph(which_obs).this, ...
        ph(which_obs).setting);

    % now sort the response for the requested SOA
    [ph(which_obs), count_ex] = myqPR_optimize_resp(ph(which_obs),...
        count_ex);

%         % show summary for this re-trial (debug mode)
%         qPrintOut(ph(which_obs), which_obs)
%         waitforbuttonpress

    % update prior based on the observer response stored in data
    ph(which_obs).this = qUpdate(ph(which_obs).this, PST);

    % update coefficients
    ph(which_obs).this = qEstimate(ph(which_obs).this,...
        ph(which_obs).setting);
    
    if mod(iTrial, 50)==0
        fprintf('%i trials analyzed for %s\n', iTrial, INFO.name)
    end

end
%% create summary table

fin_array = nan(n_obs, 3);
for iObs = 1:n_obs
    fin_array(iObs, :) = ph(iObs).this.est;
end

% the first line is Elio's, but we might not always have exactly 4
% observers.
% lbls = {'obs1', 'obs2', 'obs3', 'obs4'};

for iobs = 1:n_obs
   lbls{iobs} = sprintf('obs%d', iobs); 
end


out_table = array2table(fin_array, 'VariableNames', {'a0', 'a1', 'tau'});
out_table = table(out_table, 'RowNames', lbls);
disp(out_table)

%% plot
x_vals = setting.soa;
figure; hold on;
for iPlot = 1:n_obs
    
    coeffs = ph(iPlot).this.my_est;
    y_vals = setting.FH.decay(coeffs, x_vals);
    
    plot(x_vals, y_vals, 'LineWidth', 3)
    
end

if exist('cond_names', 'var')
    legend(cond_names)
else
    legend
end
   
title(INFO.name)
    
end

