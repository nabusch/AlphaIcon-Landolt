
T = INFO.T;
soas = unique([T.soa]);

for isoa = 1:length(soas)
    
    thissoa = soas(isoa);
    n(isoa) = sum([T.soa]==thissoa);
    pc(isoa) = sum([T.soa]==thissoa & [T.correct]) / n(isoa);
    n(isoa) = sum([T.soa]==thissoa);
end

figure;hold all
plot(soas, pc, 'o')

tData = q.sim.decayfnc;


q = INFO.QPR;
% PF
soa4plot = sort([q.setting.soa q.setting.StimDur]);

iPC = q.this.DecayFnc([1 1:end]);
plot(soa4plot,iPC,'k','LineWidth',2);
plot(soa4plot,tData([1 1:end]),'r','LineWidth',2);hold on;
legend('empirical', 'apriori')

%%

qPlot(q.setting,q.sim,q.this,q.hist)
