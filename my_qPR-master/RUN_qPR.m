%% launch qPR

clear all %#ok<CLALL>
close all
clc

%% main params
n_trials = 300;
mag = nan(1, n_trials);

%% prepare setting
setting = [];
setting.nTrial = n_trials;
% setting.n_stretch = 300;

% define decay function
setting.FH.decay = @(coeffs, x) ...
    coeffs.a0+(coeffs.a1-coeffs.a0)*exp(-x/coeffs.tau);

% define probs handle over interval -for uniform distribution-
setting.FH.probs = @(x) ones(1, numel(x))/numel(x);

% stimulus space
[setting, PST] = qSpace(setting); % the qModel was pretty much redundant?

% prior
this = qPrior(setting);

% preallocate with qLog
hist = qLog(setting);

evolution_pars = nan(n_trials, 3);
figure('units','normalized','outerposition',[0 0 1 1])


for iTrial = 1:n_trials
   
    this.trial = iTrial;
    
    % compute entropy
    this = qSelect(this, setting);
   
    % simulate observer response
    this = myqPR_observer(this, setting);
    
    % update prior
    this = qUpdate(this, PST); 
    
    % update coefficients
    this = qEstimate(this, setting);
    
    % store params
    evolution_pars(iTrial, 1:3) = structfun( @(x) x, this.my_est);
    hist = qLog(this, hist); % test for qLog
    
    % update mag
    if iTrial >1
        vect_diff = evolution_pars(iTrial,:)-evolution_pars(iTrial-1,:);
        mag(iTrial) = norm(vect_diff);
    end
    
    % plot
    myqPR_plot_vect(this, setting, evolution_pars, n_trials, mag); 
    
    pause(.05)
   
end


%% bootstrap parameters

% [this, hist] = qStretch(this, setting, hist, evolution_pars, PST);

%% compare vector difference, true parameters and final quest
der_mag = eval_stationarity(mag, 10);
idx_min_der = find(der_mag==min(der_mag));


