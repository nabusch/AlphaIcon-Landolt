function [INFO, isQuit] = one_trial(INFO, win, itrial)

P = INFO.P; % just for shorthand
T = INFO.T(itrial);

isQuit = 0;
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
% Wait for response.
% --------------------------------------------------------
if P.setup.isEEG
    SendTrigger(...
        100+100*T.side + ... %left/right
        30*T.isoa, ...       % which event: trial on, display on, feedback on
        P.trigger.trig_dur);
end

[T.button, isQuit, secs] = get_response(P);

% These vectors indicate the correct T.button to press for each numerical
% index of a gap orientation. E.g. a downward gap (6 o'clock) is numerical
% position 5 (see figure in Evernote), correct response would be T.button "2"
% on the number block of the keyboard.
gap_orientations = [0 45 90 135 180 225 270 315];
correct_response = [8  9  6   3   2   1   4   7];

if T.button == correct_response(gap_orientations==T.orientations(T.position))
    T.correct = 1;
    my_optimal_fixationpoint(win, P.screen.cx, P.screen.cy, P.stim.fix_size, [0 255 0], P.stim.background_color, P.screen.pixperdeg)

else
    T.correct = 0;
    my_optimal_fixationpoint(win, P.screen.cx, P.screen.cy, P.stim.fix_size, [255 0 0]       , P.stim.background_color, P.screen.pixperdeg)
end

T.rt = secs - (t_display_on + T.soa);

t_feedback_on = Screen('Flip', win);


T.t_trial_on     = t_trial_on;
T.t_display_on   = t_display_on;
T.t_display_off  = t_display_off;
T.t_feedback_on  = t_feedback_on;
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

INFO.T(itrial) = T;

WaitSecs(P.paradigm.dur_feedback);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% end of trial
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%