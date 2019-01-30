function [this] = myqPR_observer(this, setting)
% simulate observer response
% the function gives a binomial response (0 1, wrong vs correct) for the
% simulated observer with the pre-specified coefficents (a0, a1, tau)
% stored in real_coeffs.

p = setting.FH.decay(setting.TrueParam , this.soatime);
this.correct = randsample([1 0], 1, true, [p, 1-p]);

end

