function INFO = qpr_update(INFO)

% Keeps the posterior to use at the next trial
INFO.QPR.this = qUpdate(INFO.QPR.this, INFO.QPR.PST);

% Gets current estimates for paramters of decay function
INFO.QPR.this = qEstimate(INFO.QPR.this, INFO.QPR.setting);

% Logs estimation history
INFO.QPR.hist = qLog(INFO.QPR.this, INFO.QPR.hist);
