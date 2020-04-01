clear all; clc
addpath('../my_qPR')

names = {
    'niko_paris_02'
    };

nsubjects = length(names);

%%
for isub = 1:nsubjects
    load(fullfile('..', 'Logfiles', [names{isub} '_Logfile.mat']));
    
    P =   INFO.P; % just for shorthand
    T =   INFO.T; % just for shorthand
    qpr = INFO.qPR; % just for shorthand
    setting = qpr.setting;
    final_estimates = qpr.this.est;
    setting.TrueParam.a0 = final_estimates(1);
    setting.TrueParam.a1 = final_estimates(2);
    setting.TrueParam.tau = final_estimates(3);
    setting.priors = final_estimates;
    
    ntrials = INFO.ntrials;
    setsz = P.stim.set_size;
    lumin = mean(P.stim.target_color,2);
    
    tarcols =  mean(reshape([T.target_color],[3,ntrials]));
    
    acc = 0;
    for iss = 1:length(setsz)
        for ilum = 1:size(lumin,1)
            acc = acc+1;
            mytrials = find([T.setsize] == setsz(iss) & ...
                tarcols == lumin(ilum));
            
            correct = [T(mytrials).correct];
            soa =     [T(mytrials).soa];
            [sort_soa, sortidx] = sort(soa);
            sort_correct = correct(sortidx);
            [unique_soas, ~, soabin] = unique(sort_soa);
            RES(acc).unique_soas = unique_soas;
            for isoa = 1:length(unique_soas)            
                RES(acc).cum_correct(isoa) = sum(sort_correct' & soabin<=isoa)/sum(soabin<=isoa);
                RES(acc).correct(isoa)     = sum(sort_correct' & soabin==isoa)/sum(soabin==isoa);
                RES(acc).n(isoa)                 = sum(soabin==isoa);
            end
            
            % Initialize QPR
            clear this hist evolution_pars mag
            qpr.setting.nTrial = length(mytrials);
            this = qPrior(qpr.setting);
            hist = qLog(qpr.setting);
            [setting, PST] = qSpace(setting); % the qModel was pretty much redundant?
            evolution_pars = nan(length(mytrials), 3);
            
            for itrial = 1:length(mytrials)
                if mod(itrial, 50)==0
                    fprintf('Condition %d, trial %03d\n', acc, itrial)
                end
                this.trial = itrial;
                this = qSelect(this, setting);
                this.soatime = T(mytrials(itrial)).soa;
                this.soaidx = find(this.soatime == [qpr.setting.soa]);
                this.correct = T(mytrials(itrial)).correct;
                
                % update prior
                this = qUpdate(this, PST);
                
                % update coefficients
                this = qEstimate(this, setting);
                
                % store params
                evolution_pars(itrial, 1:3) = structfun( @(x) x, this.my_est);
                hist = qLog(this, hist); % test for qLog
                
                % update mag
                if itrial >1
                    vect_diff = evolution_pars(itrial,:)-evolution_pars(itrial-1,:);
                    mag(itrial) = norm(vect_diff);
                end                
            end
            
            RES(acc).hist = hist;
            RES(acc).this = this;
            RES(acc).mag = mag;
            RES(acc).evolution_pars = evolution_pars;
            
        end
    end
    
end

%% Plot the Figure.
x_vals = setting.soa;

line_cols = lines;

figure('color', 'w'); hold on;

for iPlot = 1:length(RES)
    
    coeffs = RES(iPlot).this.my_est
    y_vals = setting.FH.decay(coeffs, x_vals);
    
    ph(iPlot) = plot(x_vals, y_vals, 'LineWidth', 3, 'color', line_cols(iPlot, :));
    xlabel('SOA')
    ylabel('p correct')
    
    plot(0.01*iPlot+RES(iPlot).unique_soas, RES(iPlot).cum_correct, ...
        'o-', 'color', line_cols(iPlot, :), 'markerfacecolor', line_cols(iPlot, :))

    stem(0.01*iPlot+RES(iPlot).unique_soas, RES(iPlot).n./sum(RES(iPlot).n), ...
        'x-', 'color', line_cols(iPlot, :), 'markerfacecolor', line_cols(iPlot, :))
    
    ylim([0 1])
    gridxy([],1/P.stim.set_size, 'linestyle', '--')
    
    legstr{iPlot} = sprintf('cond %d', iPlot);
    
end

legend(ph, legstr)
