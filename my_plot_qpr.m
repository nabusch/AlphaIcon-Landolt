%% Load results file.
clear; close all
name = 'test3';
logfilename = ['./Logfiles' filesep name '_Logfile.mat'];
load(logfilename);

%% Prepare data to plot.

for isetsize = 1:length(INFO.P.stim.set_size)
    for icontrast = 1:size(INFO.P.stim.target_color,1)
        
        thissetsize  = INFO.P.stim.set_size(isetsize);
        thiscontrast = INFO.P.stim.target_color(icontrast);
        trials = [INFO.T.setsize]' == thissetsize & all(vertcat(INFO.T.target_color) == thiscontrast,2);
        
        T = INFO.T(trials);
        soas = unique([T.soa]);
        
        for isoa = 1:length(soas)
            % how many trials at this SOA?
            n(isoa,isetsize,icontrast) = sum([T.soa]==soas(isoa));
            
            % proportion of correct trials at this SOA
            pc(isoa,isetsize,icontrast) = mean([T([T.soa]==soas(isoa)).correct]);
        end
        
        Q = INFO.QPR;
    end
end


Q.this = qEstimate(Q.this, Q.setting);




% Reconstruct psychometric function based on parameter estimates.
tData = Q.sim.decayfnc;
soa4plot = sort([Q.setting.soa Q.setting.StimDur]);
iPC = Q.this.DecayFnc([1 1:end]);

%% Show results using qPR's own plot function.
qPlot(Q.setting, Q.sim, Q.this, Q.hist)

%% Use my own visualization and make sure that it matches,
figure('color', 'w');hold all

% Show proportion correct at each SOA.
scatter(soas, pc, 'o', 'filled')

% Show the decay function estimated from the empirical data.
plot(soa4plot,iPC,'k','LineWidth',2);

% Show the apriori decayfunction.
plot(soa4plot,tData([1 1:end]),'r','LineWidth',2);

legend('pc and n trials', 'apriori', 'empirical')

text(soas, pc, int2str(n'))
