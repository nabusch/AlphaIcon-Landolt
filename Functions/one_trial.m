function INFO = one_trial(INFO, win, itrial)

P = INFO.P; % just for shorthand
T = INFO.T(itrial);

cue_on  = 0;



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
    P.stim.set_size, P.stim.target_diameter, ...
    P.stim.target_diameter);



% --------------------------------------------------------
% Prestimulus interval
% --------------------------------------------------------
DrawEmptyScreen
Screen('DrawingFinished', win);
t_trial_on = Screen('Flip', win);

% Send trigger.
if P.setup.isEEG
    SendTrigger(...
        100+100*T.side + ... %left/right
        10*T.isoa, ...       % which event: trial on, display on, feedback on
        P.trigger.trig_dur);
end



% --------------------------------------------------------
% Pre-Cue if soa<0
% --------------------------------------------------------
if T.soa < 0
    cue_on = 1;
    DrawEmptyScreen
    draw_cue(T, P, xcoords, ycoords, win)
    Screen('DrawingFinished', win);
    t_precue_on = Screen('Flip', win, t_trial_on + dur_predisplay + T.soa);
end



% --------------------------------------------------------
% Display
% --------------------------------------------------------
DrawEmptyScreen

l = lines(P.stim.set_size);
l = Shuffle(l);

for ipos = 1:P.stim.set_size      
%     P.stim.target_gapcolor.*T.target_color
    
    my_landolt(win, xcoords(ipos) + P.screen.cx, ycoords(ipos) + P.screen.cy, ...
        P.stim.target_diameter*P.screen.pixperdeg, T.target_color, P.stim.target_thick*P.screen.pixperdeg, ...
        P.stim.target_gapcolor, P.stim.target_gap, ...
        T.orientations(ipos)-0.5*P.stim.target_gap);    
end

if T.soa <= 0%
    cue_on = 1;
    draw_cue(T, P, xcoords, ycoords, win)
end

Screen('DrawingFinished', win);
t_display_on = Screen('Flip', win, t_trial_on + dur_predisplay);

% Send trigger.
if P.setup.isEEG
    SendTrigger(...
        100+100*T.side + ... %left/right
        20*T.isoa, ...       % which event: trial on, display on, feedback on
        P.trigger.trig_dur);
end



% --------------------------------------------------------
% Turn off display
% --------------------------------------------------------
DrawEmptyScreen

if cue_on == 1
    draw_cue(T, P, xcoords, ycoords, win)
elseif T.soa <= P.paradigm.dur_display
    draw_cue(T, P, xcoords, ycoords, win)
end

Screen('DrawingFinished', win);
t_display_off = Screen('Flip', win, t_display_on + P.paradigm.dur_display);



% --------------------------------------------------------
% Show Cue at appropriate soa if it is not on already.
% --------------------------------------------------------
DrawEmptyScreen
draw_cue(T, P, xcoords, ycoords, win)

if cue_on == 1
    Screen('DrawingFinished', win);
else
    cue_on = 1;
    t_cue_on = Screen('Flip', win, t_display_on + T.soa);
end



% --------------------------------------------------------
% Log the timing of events in this trials.
% --------------------------------------------------------
T.t_trial_on     = t_trial_on;
T.t_display_on   = t_display_on;
T.t_display_off  = t_display_off;
T.dur_display    = t_display_off - t_display_on;
T.dur_display    = t_display_off - t_display_on;

if T.soa < 0
    T.t_cue_on = t_precue_on - t_trial_on;   
elseif T.soa == 0
    T.t_cue_on = t_display_on - t_trial_on;    
elseif T.soa == P.paradigm.dur_display
    T.t_cue_on = t_display_off - t_trial_on;    
elseif T.soa > P.paradigm.dur_display
    T.t_cue_on = t_cue_on - t_trial_on;    
else
    T.t_cue_on = 99; % this should never happen.
end



% --------------------------------------------------------
% The end.
% --------------------------------------------------------
