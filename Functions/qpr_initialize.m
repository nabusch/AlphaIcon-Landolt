function INFO = qpr_initialize(INFO)

INFO.P.qpr.nTrial  = length(INFO.T);

% Prepare parameter space, stimulus space, and prior probabilities
INFO.QPR.setting = qSpace(INFO.P.qpr);
INFO.QPR.this    = qPrior(INFO.QPR.setting);

% Prep for memory spaces (Optional)
INFO.QPR.hist = qLog(INFO.QPR.setting);

% Conditional probability lookup table for correct response
INFO.QPR.PST = qModel(INFO.QPR.setting);           % P(E|H)

% Conputing Simulated Observer's PF (Simulation Only)
INFO.QPR.sim.TrueParam = INFO.P.qpr.sim_true_param;
INFO.QPR.sim.decayfnc   = qModel(INFO.QPR.setting, INFO.QPR.sim.TrueParam);
