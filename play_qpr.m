P = INFO.P;

sim.decayfnc = P.qpr.sim_decayfnc;
sim.TrueParam = P.qpr.sim_true_param;

h = qPlot(P.qpr.setting,sim,P.qpr.this,P.qpr.hist)

%%
[INFO.P.qpr.hist.SOA(1:10)]
soas = [INFO.T.soa];
correct = [INFO.T.correct];

[sort_soa, sort_idx] = sort(soas);
sort_correct = correct(sort_idx);

plot(sort_soa, cumsum(sort_correct)./[1:length(sort_correct)])