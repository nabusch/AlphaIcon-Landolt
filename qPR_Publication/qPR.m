function [this, hist, setting, sim] = qPR(varargin)

% QPR   An adaptive partial report procedure based on Bayesian Inference
%       Written by JB (Jongsoo.Baek@gmail.com)
%
%   SYNTAX:
%            [this, hist, setting, sim] = qPR('TrueParam',TrueParam,...
%                        'Priors',priors,'PriorWeights',weight,...
%                        'nTrial',nTrial,...
%                        'Figures','Off','PauseBeforeFirst','Off');
%
%
%   EXAMPLES:
%            [this, hist] = qPR;
%            this = qPR('TrueParam',[.25 .85 .05]);
%            this = qPR('Priors',[.35 .95 .3],'PriorWeights',[0 10 3]);
%            this = qPR('nTrial',100);
%            this = qPR('Figures','On','PauseBeforeFirst','Off');
%
%
%   DESCRITION:
%            qPR simulates a 10AFC partial report experiment. Without any
%            input arguement, qPR simulates 200 trials and returns this
%            (estimates), hist (simulation history), setting (qPR setting),
%            sim (simulation setting). The optional input arguement,
%            'TrueParam', defines simulated observers' true parameters,
%            a0, a1, tau. Default 'TrueParam' is set to [.15 .85 .250].
%            The second optional input arguement, 'Priors', defines your
%            guess about simulated obervers' true parameters, a0, a1, tau.
%            It is usually coupled with another input argument 'PriorWeights'.
%            'PriorWeights' describes your confidence for 'Priors'. A high
%            value represents a high confidence, and 0 represnet no confidence
%            (which means an uniform prior distrubition). The default
%            'PriorWeights' is [0,0,0]. The 'nTrial' arguement defines how
%            many trials you will simulate. The default value of 'nTrial' is
%            200 trials. The last two input arguement is related to presenting
%            result plots. The argument 'Figures' defines how frequently
%            this simulation refreshes result figures. It could be 'On'
%            (for every trial), 'Off' (for not showing figures), 'Last' (for
%            showing the final trial) or 'Fast' (for refreshing every 10th
%            trials). If you set another argument 'PauseBeforeFirst', to
%            'on', the program will pause before the first trial and wait
%            for your response. This would be useful if you want to review
%            settings of simulation (e.g. prior distributions)
%
%
%   REFERENCES:
%            Baek, J., Lesmes, A. L. & Lu, Z. (2014). Bayesian adaptive
%               estimation of the sensory memory decay function: the quick
%               Partial Report method. Journal of Vision, 14(10).
%               doi:10.1167/14.10.157 <a href="http://www.journalofvision.org/content/14/10/157.abstract">[JOV]</a>
%
%
%   CHANGELOG:
%            10/10/2014 JB   Initial beta release
%
%
%   CREDIT:
%            Jongsoo Baek, Ph.D (<a href="mailto:Jongsoo.Baek@gmail.com">Jongsoo.Baek@gmail.com</a>)
%            Luis Lesmes, Ph.D (<a href="luis.lesmes@adaptivesensorytech.com">luis.lesmes@adaptivesensorytech.com</a>)
%            Zhong-Lin Lu, Ph.D (<a href="lu.535@osu.edu">lu.535@osu.edu</a>)
%
%
%   COPYRIGHT:
%            The current qPR is a beta release. A stable version will be
%            avaiable on LOBES website (<a href="http://lobes.osu.edu">http://lobes.osu.edu</a>) soon. Please
%            do not distribute this code without authors' permission.


%% Settings %==============================================================

% Experiment Setup
mAFC = 10;                % number of choices
nTrial = 200;             % number of trials
StimDur = .02;            % unit: ms
fr = .01;                 % frame rate = 10ms per each frame

% Prior Setup
priors = [.3 .9 .350];
weights = [0 0 0];

%% Simulation Settings % ==================================================

% Defining Simulated Observer's Paramters (Simulation Only)
TrueParam = [.15 .85 .250];

% Parsing Optional Paramters of Simulation (Simulation Only)
inSim = inputParser;
FigOpt = {'On','Off','Last','Fast'};
InitFigOpt = {'On','Off','Delayed'};
addOptional(inSim,'Figures','On', @(x) any(validatestring(x,FigOpt)));
addOptional(inSim,'PauseBeforeFirst','Off', @(x) any(validatestring(x,InitFigOpt)));
addOptional(inSim,'TrueParam',TrueParam);
addOptional(inSim,'Priors',priors);
addOptional(inSim,'PriorWeights',weights);
addOptional(inSim,'nTrial',nTrial);
parse(inSim,varargin{:});

ResFig = inSim.Results.Figures;
nTrial = inSim.Results.nTrial;
InitFig = inSim.Results.PauseBeforeFirst;
priors = inSim.Results.Priors;
weights = inSim.Results.PriorWeights;
TrueParam = inSim.Results.TrueParam;

setting.mAFC = mAFC;
setting.nTrial = nTrial;
setting.StimDur = StimDur;
setting.fr = fr;
setting.priors = priors;
setting.weights = weights;

sim.TrueParam = TrueParam;

% Prepare paramter space, stimulus space, and prior probabilities
setting   = qSpace(setting);
this  = qPrior(setting);

% Conputing Simulated Observer's PF (Simulation Only)
sim.decayfnc = qModel(setting, TrueParam);

%% Preparations %==========================================================

% Prep for memory spaces (Optional)
hist = qLog(setting);

% Conditional probability lookup table for correct response
PST = qModel(setting);           % P(E|H)

%% Start Trials  %=====================================================

for iTrial = 1:nTrial

    % Computes entropy and optimal SOA for this trial
    this = qSelect(this,setting);

    % Plots the initial state (Simulation Only)
    if strcmp(InitFig,'On') && iTrial==1,
        qPlot(setting,sim,this,hist);
        keyboard;
    elseif strcmp(InitFig,'Delayed') && iTrial==1,
        qPlot(setting,sim,this,hist);
        pause(2);
    end % end if

    % Simulates observer's response (Simulation Only)
    this.pc = sim.decayfnc(this.soa);
    this.correct = lobesFlips(this.pc);

    % Keeps the posterior to use at the next trial
    this = qUpdate(this, PST); % Update this.PT

    % Gets current estimates for paramters of decay function
    this = qEstimate(this,setting);

    % Logs estimation history
    hist = qLog(this,hist);

    % Plottiing (Simulation Only)
    switch ResFig
        case 'On'
            qPlot(setting,sim,this,hist);pause(.1);
        case 'Last'
            if iTrial==nTrial,
                qPlot(setting,sim,this,hist);
            end
        case 'Fast'
            if ~rem(iTrial,10) || iTrial==nTrial,
                qPlot(setting,sim,this,hist);pause(.1);
            end
    end % end switch ResFig

end % end for iTrial