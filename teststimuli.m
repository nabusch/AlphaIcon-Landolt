% Clear the workspace and the screen
close all;
clearvars;
sca

INFO.P = get_params;
INFO = define_trials(INFO);
P = INFO.P; % just for shorthand
itrial = 1;
T = INFO.T(itrial);

[~, xcoords, ycoords] = PlaceObjectsOnACircle(...
    P.stim.display_diameter*P.screen.pixperdeg, ...
    P.stim.set_size, P.stim.target_diameter, ...
    P.stim.target_diameter);


% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Get the screen numbers
screens = Screen('Screens');

% Select the external screen if it is present, else revert to the native
% screen
screenNumber = max(screens);

% Define black, white and grey
black = BlackIndex(screenNumber);
white = WhiteIndex(screenNumber);
grey = white / 2;

% Open an on screen win and color it grey
[win, winRect] = PsychImaging('Openwindow', screenNumber, grey);



for ipos = 1:P.stim.set_size    
    my_landolt(win, xcoords(ipos) + P.screen.cx, ycoords(ipos) + P.screen.cx, ...
        P.stim.target_diameter, T.target_color, P.stim.target_thick, ...
        P.stim.background_color, P.stim.target_gap, T.orientations(ipos));    
end

% Flip to the screen
Screen('Flip', win);

% Now we have drawn to the screen we wait for a keyboard button press (any
% key) to terminate the demo
KbStrokeWait;

% Clear the screen
sca;