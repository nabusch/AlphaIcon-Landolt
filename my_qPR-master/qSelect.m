function [this] = qSelect(this, setting)
%% [this] = qSelect(this, setting)
% the function first computes entropy for each soa and each possible
% behavioural response (yes vs no). Then compute the entropy of the current
% at the current trial, compute the difference between the expected
% entropies and the current (information gain). The expected information
% gain is obtained by a weghted sum of the matrix obtained before and the
% expected behavioural response for each soa based on the current prior.
% The SOA maximizing the information gain (that is, minimizing entropy) is
% chosen for the subsequent trial.

% All the functions in the present package aim to reproduce the work by
% Baek and colleagues (2016) "qPR: An adaptive partial-report procedure
% based on Bayesian inference".
%
% Created by Elio Balestrieri on 27-Jan-2019
% edited by eb on 28-Jan-2019

n_soa = numel(setting.soa);
H_mat = nan(n_soa, 2);

% start compute posteriors for each SOA, for each possible response
for isoa = 1:n_soa
    nextthis = this;
    
    
    for iresp = [0 1]
        % compute for r ==1;
        nextthis.correct = iresp;
        nextthis.soaidx = isoa;

        % call to qUpdate
        out = qUpdate(nextthis, setting.PST);
        % compute entropy (but not sum yet)
        swap_mat = out.PT.*log(out.PT);
        % correction for lim xlogx as x->0 == 0
        swap_mat(isnan(swap_mat)) = 0;
        % put in the right pos, r=1 1st col, r=0 2nd col
        H_mat(isoa,abs(iresp-2)) = -sum(sum(sum(swap_mat)));

    end

    
end

% compute entropy of the current prior -same passages as before-
prior_H = this.PT.*log(this.PT);
prior_H(isnan(prior_H))=0;
prior_H = -sum(sum(sum(prior_H)));

% information gain as change between current prior and posterior
H_mat = prior_H-H_mat;
% linearize prior to facilitate computing
linear_prior = this.PT(:);
% compute probability of response based on the current prior
r1 = sum(setting.pc.*repmat(linear_prior, 1, n_soa))';
% weights matrix of response (correct vs wrong)
weight_r = [r1, 1-r1];
% expected information gain
info_gain = sum(H_mat.*weight_r,2);
% find max
this.soaidx = find(info_gain==max(info_gain));
% define SOA
this.soatime = setting.soa(this.soaidx);
% output entropy (information gain)
this.entropy = info_gain;

    
end

