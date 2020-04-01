clear all; clc

names = {
    'test3'
    };

nsubjects = length(names);
addpath('../my_qPR')

% edited by eb on 11-Mar-2019 
% corrected the isoa bug

%%
for isub = 1:nsubjects
    load(fullfile('..\Logfiles', [names{isub} '_Logfile.mat']));
    
    P = INFO.P; % just for shorthand
    T = INFO.T; % just for shorthand
    qpr = INFO.qPR; % just for shorthand
    
    ntrials = INFO.ntrials;
    setsz = P.stim.set_size;
    lumin = mean(P.stim.target_color,2);
    
    tarcols =  mean(reshape([T.target_color],[3,ntrials]));
    
    acc = 0;
    mytrials = nan(ntrials, length(setsz)*length(lumin));
    for iss = 1:length(setsz)
        for ilum = 1:size(lumin,1)
            acc = acc+1;
            mytrials(:, acc) = [T.setsize] == setsz(iss) & ...
               tarcols == lumin(ilum);
        end
    end
    
    % added by EB for compatibility
    % get evolution_pars mat
    
    evolution_pars = INFO.qPR.evolution_pars;
    
    % append vect of soas
    % evolution_pars(:,4) = [INFO.T.isoa]';         %% SOURCE OF WEIRD APPROXIMATION of qpr values (eb 2019-03-11)
    evolution_pars(:,4) = INFO.qPR.hist.SOA';        % the "hist" subfield has the right SOA indexes actually used during the data collection
    evolution_pars(:,7) = [INFO.T.correct]';
    INFO.qPR.evolution_pars = evolution_pars;
end

%%
[ph, out_table] = post_hoc_qPR(INFO, mytrials)



