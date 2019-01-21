function qpr_recompute(Q, P, soas, correct)

% Use this function after the experiment is finished to recompute the
% psychometric function for only a subset of trials, e.g. for a specific
% experimental condtion.


newsetting.mAFC       = P.qpr.mAFC;
newsetting.StimDur    = P.qpr.StimDur;
newsetting.fr         = P.qpr.fr;
newsetting.weights    = [0 0 0];
newsetting.qpr.priors = Q.est; % We use as priors the parameters estimated for the full dataset.

q_new = qSpace(newsetting);

for itrial = 1:length(soas)
    
    
INFO.QPR.this = qSelect(INFO.QPR.this, INFO.QPR.setting);

        INFO.QPR.this.pc = INFO.QPR.sim.decayfnc(INFO.QPR.this.soa);
        INFO.QPR.this.correct = lobesFlips(INFO.QPR.this.pc);    
        
INFO.QPR.this = qUpdate(INFO.QPR.this, INFO.QPR.PST);

% Gets current estimates for paramters of decay function
INFO.QPR.this = qEstimate(INFO.QPR.this, INFO.QPR.setting);

% Logs estimation history
INFO.QPR.hist = qLog(INFO.QPR.this, INFO.QPR.hist);
    
end


