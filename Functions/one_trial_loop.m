function INFO = one_trial_loop(INFO, win, itrial)

P = INFO.P; T = INFO.T(itrial); % just for shorthand


% --------------------------------------------------------
% Prepare variables and stimuli
% --------------------------------------------------------
% Determine random pre-display interval.
dur_predisplay = 0;
while dur_predisplay < P.paradigm.dur_prestim_min || dur_predisplay > P.paradigm.dur_prestim_max
    dur_predisplay = exprnd(P.paradigm.dur_prestim_mean);
end

% Prepare the display.
[~, xcoords, ycoords] = PlaceObjectsOnACircle(...
    P.stim.display_diameter*P.screen.pixperdeg, ...
    T.setsize, P.stim.target_diameter, ...
    P.stim.target_diameter);


% --------------------------------------------------------
% Start the trial.
% --------------------------------------------------------
DrawEmptyScreen
Screen('DrawingFinished', win);
T.t_trial_on = Screen('Flip', win);

if P.setup.isEEG
    SendTrigger(...
        100+100*T.side + ... %left/right
        10*T.isoa, ...       % which event: trial on, display on, feedback on
        P.trigger.trig_dur);
end


% --------------------------------------------------------
% Present the rest of the trial in a loop.
% --------------------------------------------------------
t_req_disp_on  = (T.t_trial_on  + dur_predisplay) - P.screen.buffer;
t_req_disp_off = (t_req_disp_on + P.paradigm.dur_display) - P.screen.buffer;
t_req_cue_on   = (t_req_disp_on + T.soa) - P.screen.buffer;

is_trial_over       = 0;
n_displayframes_on  = 0;
n_displayframes_off = 0;
n_cueframes         = 0;

while ~is_trial_over
    
    now = GetSecs;% - T.t_trial_on;
    DrawEmptyScreen
    
    % Show the display if the time is right.
    if now > t_req_disp_on
        if now < t_req_disp_off
            draw_display;
            n_displayframes_on = n_displayframes_on + 1;
        else
            n_displayframes_off = n_displayframes_off + 1;
        end
    end
    
    % Show the cue if the time is right.
    if now > t_req_cue_on
        draw_cue(T, P, xcoords, ycoords, win)
        n_cueframes = n_cueframes + 1;
    end
    
    Screen('DrawingFinished', win);
    [VBLTimestamp, StimulusOnsetTime, FlipTimestamp] = Screen('Flip', win);
    
    % If this is display onset ...
    if n_displayframes_on == 1
        T.t_display_on = VBLTimestamp;
        
        % Send trigger.
        if P.setup.isEEG
            SendTrigger(...
                100+100*T.side + ... %left/right
                20*T.isoa, ...       % which event: trial on, display on, feedback on
                P.trigger.trig_dur);
        end
    end
    
    % If this is display offset ...
    if n_displayframes_off == 1
        T.t_display_off = VBLTimestamp;   
        T.dur_display   = T.t_display_off - T.t_display_on;
    end
    
    % If this is cue onset ...
    if n_cueframes == 1
        T.t_cue_on = VBLTimestamp;
    end
    
    % If everything has been shown, then this trial is over.
    if n_displayframes_on >= 1 && ...
            n_displayframes_off >= 1 && ...
            n_cueframes >= 1
        
        is_trial_over = 1;
    end
    
end

INFO.T(itrial) = T;
fprintf(' Over. ')

% --------------------------------------------------------
% The end.
% --------------------------------------------------------
