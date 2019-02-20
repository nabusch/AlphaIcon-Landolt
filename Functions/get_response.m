function [INFO, isQuit] = get_response(INFO, win, itrial)

P = INFO.P; % just for shorthand
T = INFO.T(itrial);

isQuit = 0;



% --------------------------------------------------------
% Send trigger indicating onset of response display.
% --------------------------------------------------------
if P.setup.isEEG
    SendTrigger(...
        100+100*T.side + ... %left/right
        30*T.isoa, ...       % which event: trial on, display on, feedback on
        P.trigger.trig_dur);
end



% --------------------------------------------------------
% Wait for button press.
% --------------------------------------------------------
[T.button, isQuit, secs] = get_buttonpress(P);



% --------------------------------------------------------
% Interpret and log the response information.
% --------------------------------------------------------
% These vectors indicate the correct T.button to press for each numerical
% index of a gap orientation. E.g. a downward gap (6 o'clock) is numerical
% position 5 (see figure in Evernote), correct response would be T.button "2"
% on the number block of the keyboard.
gap_orientations = [0 45 90 135 180 225 270 315];
correct_response = [8  9  6   3   2   1   4   7];

if T.button == correct_response(gap_orientations==T.orientations(T.position))
    T.correct = 1;
else
    T.correct = 0;
end

T.rt = secs - (T.t_display_on + T.soa);

INFO.T(itrial) = T;



% --------------------------------------------------------
% Present the feedback.
% --------------------------------------------------------
if P.paradigm.do_feedback
    switch T.correct
        case 1
            my_optimal_fixationpoint(win, P.screen.cx, P.screen.cy, ...
                P.stim.fix_size, [0 100 50], P.stim.background_color, P.screen.pixperdeg)
            
        case 0
            my_optimal_fixationpoint(win, P.screen.cx, P.screen.cy, ...
                P.stim.fix_size, [100 50 0], P.stim.background_color, P.screen.pixperdeg)
    end
end

Screen('Flip', win);
WaitSecs(P.paradigm.dur_feedback);

