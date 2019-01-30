function [this, hist] = qStretch(this, setting, hist, evolution_pars, PST)

%[occ_soa_mat(:,1), occ_soa_mat(:,2)] = histcounts(hist.SOA, 1:30)'

[occ, idx] = histcounts(hist.SOA, 1:31);
occ_soa_mat = [occ', idx(1:end-1)']; 
occ_soa_mat = sortrows(occ_soa_mat, 1);

inf_soa = occ_soa_mat(end-3:end,2);

% define prob dist objects to provide [0 1] resp
acc = 0; pdobjs(numel(inf_soa)).soa=[];
for isoa = inf_soa'
    
    acc = acc+1;
    pc = mean(hist.CORR(hist.SOA==isoa));
    pdobjs(acc).p = makedist('Binomial','N',1,'p', pc);
    pdobjs(acc).soaidx = isoa;
    pdobjs(acc).soa = setting.soa(isoa);

end

% start bootstrapping
setting.boot = 1;
evolution_pars = [evolution_pars; nan(setting.n_stretch, 3)];
for iboot = setting.nTrial+1:setting.nTrial+setting.n_stretch

    % randomly select the soa among the most informative ones
    whichsoa = randi([1 4]);
    
    % provide response
    this = bootResp(whichsoa, pdobjs, this);
    
    % update prior
    this = qUpdate(this, PST); 
    
    % update coefficients
    this = qEstimate(this, setting);
    
    % store params
    evolution_pars(iboot, 1:3) = structfun( @(x) x, this.my_est);
    
    % plot
    myqPR_dynamic_plot(this, setting, evolution_pars, setting.nTrial); 
    
    pause(.05)

    
    
end
    
end


function this = bootResp(whichsoa, pdobjs, this)

    this.correct = random(pdobjs(whichsoa).p);
    this.soaidx = pdobjs(whichsoa).soaidx;
    this.soa = pdobjs(whichsoa).soa;

end