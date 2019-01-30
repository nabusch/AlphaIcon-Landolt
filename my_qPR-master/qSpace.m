function [setting, PST] = qSpace(setting)
%% [setting, PST] = qSpace(setting)
%
% The function creates the discretized parameter space for a0, a1, tau.
% a0 and a1 linearly defined over [0, .5] and [.5 1], respectively. Tau is
% logarithmically spaced over [0 .8].
%
% The function creates even all the parameters for the simulation, AND 2
% different versions of the same "probability of correct response space".
% This is in the present case a 4D space, with 3D for the 3 parameters and
% one time dimension, for the SOA. 2 Different versions of this space are
% prouced here: the first is a "linearized form", where all the parameters
% combinations are stored along the first dimension, leading in this way to
% a 2D matrix (paramsXtime). This version is stored in setting.pc, as the
% original function does.
%
% Furthermore I noticed that the function qModel was redundant (?), in the
% sense that was giving back the very same parameter space but over 4D. For
% this reason I decided not to use an additional for loop and the PST
% matrix, originally yielded by qModel, is output here (and additionally,
% to setting.PST)

% All the functions in the present package aim to reproduce the work by
% Baek and colleagues (2016) "qPR: An adaptive partial-report procedure
% based on Bayesian inference".
%
% Created by Elio Balestrieri on 27-Jan-2019
% edited by eb on 28-Jan-2019


%% params definition

% define size of probability space
n_a0 = 41; lower_a0 = 0; upper_a0 = .5;
n_a1 = 41; lower_a1 = .5; upper_a1 = 1;
n_tau = 40; lower_tau = .01; upper_tau = .8;
n_SOA = 30; lower_SOA = 0; upper_SOA = 3;

% discretize prior distribution over intervals
inter.vals.a0 = linspace(lower_a0, upper_a0, n_a0);  %---- end values is based on the amount of items to be maintained?
inter.vals.a1 = linspace(lower_a1, upper_a1, n_a1);
inter.vals.tau = logspace(log10(lower_tau), log10(upper_tau), n_tau);

% define SOAs points -discrete x-
SOA = [lower_SOA, exp(linspace(log(lower_SOA+.03), log(upper_SOA), n_SOA-1))]; % the closest to their function

% define coefficients' starting points
setting.priors = [.3, .9, .35];
setting.TrueParam.a0 = .15;
setting.TrueParam.a1 = .85;
setting.TrueParam.tau = .250;

% preallocate PST
PST = nan(n_a0, n_a1, n_tau, n_SOA);

%% create pc

% preallocate the 4D space
univ_p_resp = nan(n_a0*n_a1*n_tau, n_SOA);

% set accumulator
acc = 0;

% invert order of the dimension in order to take into account how mat(:)
% works, that is, along the first dimension. This implies to invert the 1st
% and the 3rd dimesnions, whereas the second is invariate.
for itau = 1:n_tau
    
    for ia1 = 1:n_a1
        
        for ia0 = 1:n_a0
            
            coeffs.a0 = inter.vals.a0(ia0);
            coeffs.a1 = inter.vals.a1(ia1);
            coeffs.tau = inter.vals.tau(itau);
            
            acc = acc+1;
            
            % the original indexing is maintained for PST
            [univ_p_resp(acc, :), PST(ia0, ia1, itau, :)] = ...
                deal(setting.FH.decay(coeffs, SOA));
            
        end
        
    end
    
end

% append. More is more, redundancy sometimes is useful.
setting.pc = univ_p_resp;
setting.soa = SOA;
setting.a0 = inter.vals.a0;
setting.a1 = inter.vals.a1;
setting.tau = inter.vals.tau;
setting.inter.vals = inter.vals;
setting.PST = PST;
setting.vectL.a0 = n_a0;
setting.vectL.a1 = n_a1;
setting.vectL.tau = n_tau;
setting.vectL.soa = n_SOA;
end



