function [this] = qEstimate(this, setting)
% update coefficients

% All the functions in the present package aim to reproduce the work by
% Baek and colleagues (2016) "qPR: An adaptive partial-report procedure
% based on Bayesian inference".
%
% Created by Elio Balestrieri on 27-Jan-2019
% edited by eb on 28-Jan-2019

new_prior = this.PT;

% compute marginal posterior distributions
% dimord: a0, a1, tau
this.A0 = sum(sum(new_prior,3),2);
this.A1 = sum(sum(new_prior,3),1)';
this.Tau = squeeze(sum(sum(new_prior,2), 1));

% compute coefficients trough weitghted sum (dot product)
this.my_est.a0 = setting.inter.vals.a0*this.A0;
this.my_est.a1 = setting.inter.vals.a1*this.A1;
this.my_est.tau = setting.inter.vals.tau*this.Tau;

% compatibility mode
this.est = [this.my_est.a0, this.my_est.a1, this.my_est.tau];

end

