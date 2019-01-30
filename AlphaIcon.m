%%
clear
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
        isQuit = 0; % logfile will be automatically overwritten
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
switch INFO.P.qpr.use_qpr
    case 1
        INFO = qpr_initialize(INFO);
end



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
    switch INFO.P.qpr.use_qpr
        case 1
            [tsoa, INFO] = qpr_get_recommendation(INFO, itrial);
            INFO.T(itrial).soa = tsoa;
    end
    
    %-------------------------------------------------
    % Present the trial or simulate the trial.
    %-------------------------------------------------
    fprintf('#%d of %d. SOA: %2.3f secs.', itrial, length(INFO.T),INFO.T(itrial).soa);
    
    switch INFO.P.do_testrun
        case 2
            % do nothing, just simulation.
        otherwise
            % really present stimuli on the screen.
            [INFO, isQuit] = one_trial(INFO, win, itrial);
    end
    
    %-------------------------------------------------
    % Get the behavioral response for this trial.
    %-------------------------------------------------
    switch INFO.P.do_testrun
        case 0
            % really ask the subject for a button press.
            [INFO, isQuit] = get_response(INFO, win, itrial);
        otherwise
            % simulate beahvioral data based on qPR function
            INFO.QPR.this.pc = INFO.QPR.sim.decayfnc(INFO.QPR.this.soa);
            INFO.QPR.this.correct = lobesFlips(INFO.QPR.this.pc);
            INFO.T(itrial).correct = INFO.QPR.this.correct;
            INFO.T(itrial).rt = 999;
    end
    
    %-------------------------------------------------
    % Update qPR with results from this trial.
    %-------------------------------------------------
    switch INFO.P.qpr.use_qpr
        case 1
            INFO = qpr_update(INFO);
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
        fprintf('Correct: %d\n', INFO.T(itrial).correct);
    end
    
    % Do not save data now if this is a testrun; this would slow down too
    % much.
    if INFO.P.do_testrun == 2
        continue
    else
        save(INFO.logfilename, 'INFO');
    end
end



%% --------------------------------------------------------------------
% After last trial, close everything and exit.
%----------------------------------------------------------------------
save(INFO.logfilename, 'INFO');WaitSecs(2);
CloseAndCleanup(INFO.P)
sca
fprintf('\nDONE!\n\n');



%% DONE!
