function myqPR_plot_vect(this, setting, evolution_pars, n_trials, mag)
% shows trial by trial updates by plotting

real_coeffs = setting.TrueParam;

strt_coeffs = this.my_est;

SOA = setting.soa;

FH = setting.FH;

vectWeights.a0 = this.A0;
vectWeights.a1 = this.A1;
vectWeights.tau = this.Tau;

E_H = this.entropy;

inter = setting.inter; 

%coords_3D

% subplot 1 -decay function-
subplot(2, 5, [1 2])
plot(SOA, FH.decay(real_coeffs, SOA), 'r', 'LineWidth', 3); hold on;
plot(SOA, FH.decay(strt_coeffs, SOA), 'k', 'LineWidth', 2); hold off;
title('decay function')

% subplot 2 -vect difference magnitude-
subplot(2, 5, [6 7])
plot(1:n_trials, mag, 'k', 'LineWidth',2)
title('diff vector norm')
%ylim([0, .1])


% % fancy prior dist
% subplot(2, 5, 7)
% scatter3(coords_3D(:,1),coords_3D(:,2), coords_3D(:,3), 5,[0 0 0], 'filled')
% title('Params space')
% xlabel('a0'); ylabel('a1'); zlabel('tau');
% xlim(minmax(inter.vals.a0)); ylim(minmax(inter.vals.a1));
% zlim(minmax(inter.vals.tau))


% subplot 3&4 -params trends- + weights
str_vals = {'a0', 'a1', 'tau'};
acc = 0;
for iPlot = 3:5
    acc = acc+1;
    subplot(2,5, iPlot)
    plot(1:n_trials, ones(1,n_trials)*real_coeffs.(str_vals{acc}),...
        'r', 'LineWidth', 3); hold on;
    plot(1:n_trials, evolution_pars(1:n_trials,acc), 'k', 'LineWidth', 2);
    
    if isfield(setting, 'boot')
        plot(n_trials+1:n_trials+setting.n_stretch,...
            evolution_pars(n_trials+1:n_trials+setting.n_stretch,acc),...
            'b', 'LineWidth', 2);          
        plot(1:n_trials+setting.n_stretch, ...
            ones(1,n_trials+setting.n_stretch)*real_coeffs.(str_vals{acc}),...
        'r', 'LineWidth', 3); hold on;
    
    end
    
    hold off;
    
    ylim(minmax(inter.vals.(str_vals{acc})))
    title(['estim val: ', str_vals{acc}])
    
    subplot(2, 5, iPlot+5)
    plot(inter.vals.(str_vals{acc}), vectWeights.(str_vals{acc}),...
        'k', 'LineWidth', 2); hold on;
    plot(ones(1,2)*real_coeffs.(str_vals{acc}), [-.01, .4],'r',...
        'LineWidth', 2); hold off;
    xlim(minmax(inter.vals.(str_vals{acc})))
    ylim([-.01, .4])
    title(['coeff weights: ', str_vals{acc}])

end

end