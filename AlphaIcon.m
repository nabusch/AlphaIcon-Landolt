%%
% clear
close all
addpath('./Functions');
addpath('qPR_Publication')

%%
name  ='test';

INFO.name              = name;
INFO.logfilename       = ['Logfiles' filesep name '_Logfile.mat'];
INFO.P = get_params;



%% ------------------------------------------------------------------------
% Test if logfile exists for this subject.
% If yes, confirm to overwrite or quit.
% ------------------------------------------------------------------------
switch name
    case 'test'
        isQuit = 0;
        % logfile will be automatically overwritten
    otherwise
        isQuit = test_logfile(INFO);
end

if isQuit
    CloseAndCleanup(P)
    return
end



%% -----------------------------------------------------------------------
% Define what do do on each trial.
% ------------------------------------------------------------------------
INFO = define_trials(INFO);
% t=struct2table(INFO.T);



%% -----------------------------------------------------------------------
% Define the qPR structure for the adaptive "staircase".
% ------------------------------------------------------------------------

INFO.P.qpr.nTrial  = length(INFO.T);

% Prepare parameter space, stimulus space, and prior probabilities
INFO.QPR.setting = qSpace(INFO.P.qpr);
INFO.QPR.this    = qPrior(INFO.QPR.setting);

% Prep for memory spaces (Optional)
INFO.QPR.hist = qLog(INFO.QPR.setting);

% Conditional probability lookup table for correct response
INFO.QPR.PST = qModel(INFO.QPR.setting);           % P(E|H)

% Conputing Simulated Observer's PF (Simulation Only)
INFO.QPR.sim.TrueParam = INFO.P.qpr.sim_true_param;
INFO.QPR.sim.decayfnc   = qModel(INFO.QPR.setting, INFO.QPR.sim.TrueParam);



%% -----------------------------------------------------------------------
% Open the display and set priority.
% ------------------------------------------------------------------------
if INFO.P.do_testrun < 2
    PsychDefaultSetup(1);
    Screen('Preference', 'SkipSyncTests', INFO.P.setup.skipsync);
    Screen('Resolution', INFO.P.screen.screen_num, INFO.P.screen.width, ...
        INFO.P.screen.height, INFO.P.screen.rate);
    
    [win, winrect] = PsychImaging('Openwindow', ...
        INFO.P.screen.screen_num, INFO.P.stim.background_color);
    
    Priority(MaxPriority(win));
    
    if INFO.P.setup.useCLUT
        addpath('./CLUT');
        load(INFO.P.setup.CLUTfile);
        Screen('LoadNormalizedGammaTable',win,inverseCLUT);
    end
        
    HideCursor
end


%% ------------------------------------------------------------------------
% Open EEG trigger port if required.
% ------------------------------------------------------------------------
if INFO.P.setup.isEEG
    OpenTriggerPort;
    SendTrigger(INFO.P.trigger.trig_start, INFO.P.trigger.trig_start);
end



%%----------------------------------------------------------------------
% Run across trials.
%----------------------------------------------------------------------
fprintf('\nNow running %d trials.\n\n', length(INFO.T));

INFO.tStart = {datestr(clock)};
isQuit = false;
tic;

for itrial = 1:length(INFO.T)
    
    %-------------------------------------------------
    % Present a break if necessary.
    %-------------------------------------------------
    if ~INFO.P.do_testrun
        if(mod(itrial, INFO.P.paradigm.break_after_x_trials) == 1 || itrial == 1)
            PresentPause(win, INFO, itrial)
        end
    end
    %-------------------------------------------------    
    % Let qPR make a recommendation for this trials SOA, if desired.
    %-------------------------------------------------
    if INFO.P.qpr.use_qpr
        % Computes entropy and optimal SOA for this trial
        INFO.QPR.this = qSelect(INFO.QPR.this, INFO.QPR.setting);
        % Use this SOA for this trial.
        tsoa = INFO.QPR.setting.soa(INFO.QPR.this.soa);
        INFO.T(itrial).soa = tsoa;
    end
    
    %-------------------------------------------------
    % Present the trial or simulate the trial.
    %-------------------------------------------------
    fprintf('#%d of %d. SOA: %2.3f secs.', itrial, length(INFO.T),INFO.T(itrial).soa);

    if INFO.P.do_testrun == 2 % skip one_trial, just simulate        
        % Simulates observer's response (Simulation Only)
        INFO.QPR.this.pc = INFO.QPR.sim.decayfnc(INFO.QPR.this.soa);
        INFO.QPR.this.correct = lobesFlips(INFO.QPR.this.pc);        
        INFO.T(itrial).correct = INFO.QPR.this.correct;
    else
        [INFO, isQuit] = one_trial(INFO, win, itrial);
    end     
        
    %-------------------------------------------------
    % Update qPR with results from this trial.
    %-------------------------------------------------
    if INFO.P.qpr.use_qpr
        
        % Keeps the posterior to use at the next trial
        INFO.QPR.this = qUpdate(INFO.QPR.this, INFO.QPR.PST);
        
        % Gets current estimates for paramters of decay function
        INFO.QPR.this = qEstimate(INFO.QPR.this, INFO.QPR.setting);
        
        % Logs estimation history
        INFO.QPR.hist = qLog(INFO.QPR.this, INFO.QPR.hist);
    end
    
    %-------------------------------------------------
    % Save results for this trial or quit the experiment.
    %-------------------------------------------------
    if isQuit==1
        CloseAndCleanup(INFO.P)
        break
    else
        INFO.T(itrial).trial_completed = 1;
        INFO.ntrials = itrial;
        INFO.tTotal  = toc;
        INFO.tFinish = {datestr(clock)};
%         save(INFO.logfilename, 'INFO');
        fprintf('Correct: %d\n', INFO.T(itrial).correct);
    end
end



%% --------------------------------------------------------------------
% After last trial, close everything and exit.
%----------------------------------------------------------------------
WaitSecs(2);
CloseAndCleanup(INFO.P)
sca
fprintf('\nDONE!\n\n');



%% DONE!
