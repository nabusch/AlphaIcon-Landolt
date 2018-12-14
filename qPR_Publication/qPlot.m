function h = qPlot(setting,sim,this,hist)

EST = hist.EST;
tData = sim.decayfnc;
tPrm = sim.TrueParam;
PT = this.PT;
if isfield(this,'correct')
    correct = this.correct;
    FirstTrial = 0;
else
    correct = 99;
    FirstTrial = 1;
end

nTrial = setting.nTrial;
a0 = setting.a0;
a1 = setting.a1;
tau = setting.tau;
soa = setting.soa;
StimDur = setting.StimDur;

iTrial = this.trial;

h = figure(1);
set(h,'Toolbar','none');

switch correct
    case 0
        rSymbol = 'x';
    case 1
        rSymbol = 'o';
    otherwise
        rSymbol = 'd';
end

FaceColor = [.25 .22 .25];
FaceAlpha = .1;

subplot(2,2,1)                      % PF
    soa4plot = sort([soa StimDur]);
    iPC = this.DecayFnc([1 1:end]);
    iCI1 = [this.DecayFncCI(1,[1 1:end]) fliplr(this.DecayFncCI(2,[1 1:end]))];
    iCI2 = [this.DecayFncCI(3,[1 1:end]) fliplr(this.DecayFncCI(4,[1 1:end]))];
    X = [soa4plot fliplr(soa4plot)];
    plot(soa4plot,tData([1 1:end]),'r','LineWidth',2);hold on;
    if FirstTrial
        title('\fontsize{18}Iconic Memory Decay Function (Before the experiment)');
    else
        if rem(iTrial,10)==1
            title(['\fontsize{18}Iconic Memory Decay Function (After ' num2str(iTrial) 'st trial)'])
        elseif  rem(iTrial,10)==2
            title(['\fontsize{18}Iconic Memory Decay Function (After ' num2str(iTrial) 'nd trial)'])
        elseif  rem(iTrial,10)==3
            title(['\fontsize{18}Iconic Memory Decay Function (After ' num2str(iTrial) 'rd trial)'])
        else
            title(['\fontsize{18}Iconic Memory Decay Function (After ' num2str(iTrial) 'th trial)'])
        end

        fill(X, iCI1, FaceColor,'FaceAlpha', FaceAlpha,'edgecolor','none');
        fill(X, iCI2, FaceColor,'FaceAlpha', FaceAlpha,'edgecolor','none');
        plot(soa4plot,iPC,'k','LineWidth',2);
    end

    plot(soa(this.soa),tData(this.soa),rSymbol,'MarkerSize',16,'Color','k','LineWidth',2);
    hold off
    xlabel('\fontsize{14}SOA (sec)');
    ylabel('\fontsize{14}Probability Correct');
    axis([min(soa) 3 0 1])

subplot(2,2,3)                      % Entropy and Next Stimulus
    plot(soa,this.entropy,'LineWidth',2);
    xlabel('\fontsize{14}SOA (sec)');
    ylabel('\fontsize{14}Information Gain');
    title('\fontsize{14}One-step ahead search')
    axis([min(soa) 3 0 .1])

subplot(2,6,4)                      % A0 History
    plot(1:iTrial, EST(1:iTrial,1),'LineWidth',2);hold on;
    line([1 nTrial], [tPrm(1) tPrm(1)],'Color','r','LineWidth',2);hold off;
    title('\fontsize{14}\ita_0 Estimate History');
    axis([1 nTrial min(a0) max(a0)]);
    xlabel('Trial');

subplot(2,6,5)                      % A1 History
    plot(1:iTrial, EST(1:iTrial,2),'LineWidth',2);hold on;
    line([1 nTrial], [tPrm(2) tPrm(2)],'Color','r','LineWidth',2);hold off;
    title('\fontsize{14}\it{a_1} Estimate History');
    axis([1 nTrial min(a1) max(a1)]);
    xlabel('Trial');

subplot(2,6,6)                      % Tau History
    plot(1:iTrial, EST(1:iTrial,3),'LineWidth',2);hold on;
    line([1 nTrial], [tPrm(3) tPrm(3)],'Color','r','LineWidth',2);hold off;
    title('\fontsize{14}\it\tau Estimate History');
    axis([1 nTrial min(tau) max(tau)]);
    xlabel('Trial');

subplot(2,6,10)                      % A0 PDF
    plot(a0,squeeze(sum(sum(PT,2),3)),'LineWidth',2);hold on;
    line([tPrm(1) tPrm(1)],[0 1],'Color','r','LineWidth',2);hold off;
    ylabel('\fontsize{14}Probability');
    title('\fontsize{14}\ita_0 Marginal Posterior');
    if FirstTrial, title('\fontsize{14}\ita_0 Prior');end
    axis([min(a0) max(a0) 0 .3]);

subplot(2,6,11)                      % A1 PDF
    plot(a1,squeeze(sum(sum(PT,1),3))','LineWidth',2);hold on;
    line([tPrm(2) tPrm(2)],[0 1],'Color','r','LineWidth',2);hold off;
    title('\fontsize{14}\ita_1 Marginal Posterior');
    if FirstTrial, title('\fontsize{14}\ita_1 Prior');end
    axis([min(a1) max(a1) 0 .3]);

subplot(2,6,12)                      % Tau PDF
    plot(tau,squeeze(sum(sum(PT,2),1)),'LineWidth',2);hold on;
    line([tPrm(3) tPrm(3)],[0 1],'Color','r','LineWidth',2);hold off;
    title('\fontsize{14}\it\tau Marginal Posterior');
    if FirstTrial, title('\fontsize{14}\it\tau Prior');end
    axis([min(tau) max(tau) 0 .3]);