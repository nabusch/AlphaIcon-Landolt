function [this] = qPrior(setting)
%% [this] = qPrior(setting)
%
% The function takes as input the setting structure mainly defined in 
% qSpace and yields as output the "this" structure containing the prior in
% "this.PT"

% All the functions in the present package aim to reproduce the work by
% Baek and colleagues (2016) "qPR: An adaptive partial-report procedure
% based on Bayesian inference".
%
% Created by Elio Balestrieri on 27-Jan-2019
% edited by eb on 28-Jan-2019


%% define vector of probabilities for the 3 parameters. 
% what the anonymous function FH.probs does is simply to assign uniform 
% probability vectors over n elements
inter.probs = structfun(setting.FH.probs, setting.inter.vals,...
    'UniformOutput', 0);

% get the number of parameters 
n_a0 = numel(setting.a0);
n_a1 = numel(setting.a1);
n_tau = numel(setting.tau);

% repeat the probability vectors over 3D
mat_a0 = repmat(inter.probs.a0', 1, n_a1, n_tau);
mat_a1 = repmat(inter.probs.a1, n_a0, 1, n_tau);
mat_tau = repmat(reshape(inter.probs.tau, 1, 1, n_tau), n_a0, n_a1, 1);

% multiply elementwise the 3, 3D matrices. In this way the sum over all 3D
% of the resulting matrix will give 1.
prior = mat_a0.*mat_a1.*mat_tau;

% output
this.PT = prior;

end

