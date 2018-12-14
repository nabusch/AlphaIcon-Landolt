# quick Partial Report Demo Software Package (Beta version)

This MATLAB code complements the quick Partial Report method presented in:  
Baek, J., Lesmes, A. L. & Lu, Z. (2014). Bayesian adaptive estimation of the sensory memory decay function: the quick Partial Report method. Journal of Vision, 14(10). doi:10.1167/14.10.157  [JOV](http://www.journalofvision.org/content/14/10/157.abstract) 

# Basic Usage 
The files in this folder implement the quick Partial Report (qPR) method. The qPR procedure can be simulated with 'qPR.m'. This program is heavily commented and provides the best view of how the programs below are used in the context of an experiment or simulation. To run, open MATLAB, change your current directory, and type 'qPR'. 
 
## SYNTAX:
             [this, hist, setting, sim] = qPR('TrueParam',TrueParam,...
                         'Priors',priors,'PriorWeights',weight,...
                         'nTrial',nTrial,...
                         'Figures','Off','PauseBeforeFirst','Off');
 
## EXAMPLES:
             [this, hist] = qPR;
             this = qPR('TrueParam',[.25 .85 .05]);
             this = qPR('Priors',[.35 .95 .3],'PriorWeights',[0 10 3]);
             this = qPR('nTrial',100);
             this = qPR('Figures','On','PauseBeforeFirst','Off');
 
## DESCRITION:
- Without any input arguement, qPR simulates 200 trials and returns this (estimates), hist (simulation history), setting (qPR setting), sim (simulation setting). 
- The optional input arguement, 'TrueParam', defines simulated observers' true parameters, a0, a1, tau. Default 'TrueParam' is set to [.15 .85 .250]. 
- The second optional input arguement, 'Priors', defines your guess about simulated obervers' true parameters, a0, a1, tau. It is usually coupled with another input argument 'PriorWeights'. 'PriorWeights' describes your confidence for 'Priors'. A high value represents a high confidence, and 0 represnet no confidence (which means an uniform prior distrubition). The default 'PriorWeights' is [0,0,0]. 
- The 'nTrial' arguement defines how many trials you will simulate. The default value of 'nTrial' is 200 trials. 
- The last two input arguement is related to presenting result plots. The argument 'Figures' defines how frequently this simulation refreshes result figures. It could be 'On' (for every trial), 'Off' (for not showing figures), 'Last' (for showing the final trial) or 'Fast' (for refreshing every 10th trials). The default value of 'Figures' is 'On'.
- If you set another argument 'PauseBeforeFirst', to 'on', the program will pause before the first trial and wait for your response. This would be useful if you want to review settings of simulation (e.g. prior distributions)
 
For more information, type 'help qPR'

# Contents
In addition to this readme file, the unzipped package should contain 12 MATLAB files:

- qPR.m / qPlot.m
    - The main program for simulation and  plotting results.
- qModel.p /  qSpace.p / qPrior.p / qSelect.p / qUpdate.p / qEstimate.p /  qHDI.p / qLog.p       - The qPR "engine" for pre- or post-trial analysis.   
- discretesamplev6.m /  lobesFlips.m
    - Short useful files that are called to manipulate (generate, sample) the parameter probability distributions used for Bayesian inference.