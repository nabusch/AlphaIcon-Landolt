function [this] = qUpdate(this, PST)
%% [this] = qUpdate(this, PST)
%  updates prior on the basis of the current response according to Bayes
%  theorem.

% All the functions in the present package aim to reproduce the work by
% Baek and colleagues (2016) "qPR: An adaptive partial-report procedure
% based on Bayesian inference".
%
% Created by Elio Balestrieri on 27-Jan-2019
% edited by eb on 28-Jan-2019

%% get params
r = this.correct;
prior = this.PT;
idxSOA = this.soaidx;

%% apply Bayes theorem
this.PT = myqPR_Rt_given_tauANDx(PST, r, idxSOA).*prior ./...
    sum(sum(sum(myqPR_Rt_given_tauANDx(PST, r, idxSOA).*prior)));


end

%% LOCAL
function p = myqPR_Rt_given_tauANDx(univ_p_resp, r, idxSOA)
% probability of r given the present coefficients
% other important step. Given the response obtained, this function selects,
% from the 4D matrix of all possible events, the 3D matrix corresponding to
% the present SOA.
% Notably, the p values are converted according to the response of the
% observer (p if correct, 1-p if wrong)

if r
    p = squeeze(univ_p_resp(:,:,:,idxSOA));
else
    p = 1-squeeze(univ_p_resp(:,:,:,idxSOA));
end

end

