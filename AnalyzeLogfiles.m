cca
addpath('C:\Users\nbusch\Dropbox\Matlab\Palamedes/')

names = {
    'nb01', 'nb03', 'nb04'
};

dv = 'correct';
iv = {'soa', 'contrast'};
nsubjects = length(names);

for isub = 1:nsubjects
   
    clear INFO T
    load(fullfile('.\Logfiles', [names{isub} '_Logfile.mat']));

    P = INFO.P;
    T = struct2table(INFO.T);
    
    T.name = repmat(num2str(isub), [height(T), 1]);
    T.contrast = (mean([T.target_color],2) - mean(P.stim.background_color))./ mean(P.stim.background_color);
    
    RES(isub) = proc_longtable(T, iv, 'correct', 'name', 'mean');
    
    set_size(isub) = P.stim.set_size;
    duration(isub) = P.paradigm.dur_display;
    ntrials = sum([T.trial_completed]);
    
    RES(isub).correct(RES(isub).correct==1) = (ntrials-0.5)/ntrials;
    RES(isub).correct(RES(isub).correct==0) = 0.5/ntrials;
    
    pc{isub} = RES(isub).correct;
    dp{isub} = PAL_SDT_MAFC_PCtoDP(pc{isub}, P.stim.set_size);
    
%     soa{isub}      = [T.soa];
%     isoa{isub}     = [T.isoa];
%     correct{isub}  = [T.correct];
%     contrast{isub} = [T.target_color];
%     
%     
%     for i = 1:length(unique(soa{isub}))        
%         pc(i) = sum(isoa{isub}==i & correct{isub}) / sum(isoa{isub}==1);
%     end   
% 
%     pc(pc==1) = 0.99;
%     
%     pcorrect{:,isub} = pc;
%     
%     d=PAL_SDT_MAFC_PCtoDP(pc,4);
%     dP{:,isub} = d;
end

all_pc = reshape([pc{:}], [size(pc{1}), length(pc)]);

all_dp = reshape([dp{:}], [size(dp{1}), length(dp)]);
%%
[rows, cols] = my_subplotlayout(nsubjects+1);

plotdata = all_pc;
plotdata = cat(3, plotdata, mean(all_pc, length(iv)+1));

figure('color', 'w')
for isub = 1:nsubjects+1
    subplot(rows, cols, isub); hold all
    
    soas = RES(1).factor_levels{1};
    
    for icontrast = 1:2
        ph(icontrast) = plot(soas, plotdata(:,icontrast,isub), '-o');
    end
    
    if isub<=nsubjects
        gridxy([0],1/set_size(isub), 'color', [0.5 0.5 0.5])
        legend(ph, num2str(RES(isub).factor_levels{2}))
        
        title(names{isub})
    else
        title('average')
    end
    
    xlabel('soa')
    xlim([min(soas) max(soas)])
    ylim([0 1])
end



%%
% ntrials = length(correct{isub});
% 
% [s, sortidx] = sort(soa{isub});
%  [s, sortidx] = sort(soa{isub} + 0.1.*randn(1,ntrials));
% c = correct{isub}(sortidx);
% 
% figure
% plot(s, cumsum(c)./cumsum(1:ntrials))
%



figure('color', 'w')
for isub = 1:length(names)
    
    subplot(2,1,1); hold all
        lcols = lines;

        xdata = [unique(soa{isub})];
        ydata = dP{:,isub};
        
        ydata(xdata<0) = [];
        xdata(xdata<0) = [];
        
        fun   = @(x,xdata)x(1)+x(2)*exp(-xdata./x(3));
        x0 = [1 1 1];
        x(:,isub) = lsqcurvefit(fun,x0,xdata,ydata);

        times = linspace(min(xdata),max(xdata),100);
        p(isub) = plot(times,fun(x(:,isub),times),'-', 'color',lcols(isub,:));        

        plot(unique(soa{isub}), dP{:,isub}, ...
            'o', 'MarkerEdgeColor','w', 'MarkerFaceColor',lcols(isub,:))
        set(gca, 'xtick', unique(soa{isub}), 'XTickLabelRotation', 60)

        xlabel('SOA', 'fontweight', 'bold', 'fontsize', 10)
        ylabel('d-prime', 'fontweight', 'bold', 'fontsize', 10)
        title('Iconic memory', 'fontweight', 'bold', 'fontsize', 13)

        legstr{isub} = ['ss: ' num2str(set_size(isub)) ' dur: ' num2str(duration(isub))];
    
end

legend (p, legstr)

subplot(2,1,2); hold all

b=bar(x');
title('Model parameters', 'fontweight', 'bold', 'fontsize', 13)
set(gca, 'xtick', [1 2 3 4], 'xticklabel', legstr)
legend(b, {'a0', 'a1', 'tau'})

