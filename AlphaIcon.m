%%
clear
close all
addpath('./Functions');

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
% Open the display and set priority.
% ------------------------------------------------------------------------
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
INFO.tStart = {datestr(clock)};
isQuit = false;
tic;

fprintf('\nNow running %d trials.\n\n', length(INFO.T));

HideCursor

for itrial = 1:length(INFO.T)

    if(mod(itrial, INFO.P.paradigm.break_after_x_trials) == 1 || itrial == 1)
        PresentPause(win, INFO, itrial)
    end
    
    fprintf('#%d of %d. SOA: %2.3f secs.', itrial, length(INFO.T),INFO.T(itrial).soa);
    
    [INFO, isQuit] = one_trial(INFO, win, itrial);
    
    if isQuit==1
        CloseAndCleanup(INFO.P)
        break
    else
        INFO.T(itrial).trial_completed = 1;
        INFO.ntrials = itrial;
        INFO.tTotal  = toc;
        INFO.tFinish = {datestr(clock)};
        save(INFO.logfilename, 'INFO');
        fprintf('Correct: %d\n', INFO.T(itrial).correct);
    end 
end



%----------------------------------------------------------------------
% After last trial, close everything and exit.
%----------------------------------------------------------------------
WaitSecs(2);
CloseAndCleanup(INFO.P)
sca
fprintf('\nDONE!\n\n');



%% DONE!
