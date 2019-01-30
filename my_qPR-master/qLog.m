function hist = qLog(varargin)
%% hist = qLog(varargin)
% mimicks the same data storage implemented by qLog, for compatibility.
% IMPORTANT! fields missing from the "hist" struct, namely those storing
% the different probability of response hypothesized at each iteration
% form the adaptive procedure, confidence interval and so on and so forth.

% All the functions in the present package aim to reproduce the work by
% Baek and colleagues (2016) "qPR: An adaptive partial-report procedure
% based on Bayesian inference".
%
% Created by Elio Balestrieri on 28-Jan-2019

if length(varargin)==1
    
    % extract setting struct
    s = varargin{1};
    n_trials = s.nTrial;
    
    % preallocate
    hist = []; n_vars = numel(fieldnames(s.inter.vals));
    hist.EST = nan(n_trials, n_vars);
    hist.A0 = nan(n_trials, s.vectL.a0);
    hist.A1 = nan(n_trials, s.vectL.a1);
    hist.TAU = nan(n_trials, s.vectL.tau);
    [hist.SOA, hist.SOAMS, hist.CORR] = deal(nan(1, n_trials));
    hist.INFOGAIN = nan(n_trials, s.vectL.soa);
    
elseif length(varargin) ==2
    
    t = varargin{1};
    hist = varargin{2};
    hist.EST(t.trial,:) = t.est;
    hist.A0(t.trial,:) = t.A0;
    hist.A1(t.trial,:) = t.A1;
    hist.TAU(t.trial,:) = t.Tau;
    hist.SOA(t.trial) = t.soaidx;
    hist.SOAMS(t.trial) = t.soatime;
    hist.CORR(t.trial) = t.correct;
    hist.INFOGAIN(t.trial,:) = t.entropy';
    
else
    
    error('wrong number of arguments')
    
end

    

end

