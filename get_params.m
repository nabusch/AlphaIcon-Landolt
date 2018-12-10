function [P] = get_params



%% ------------------------------------------------------------------------
% Set the computer-specific parameters.
%  ------------------------------------------------------------------------
computername = getenv('COMPUTERNAME');
switch computername
    case 'X1YOGA'
        
        thescreen = max(Screen('Screens'));
        myres = Screen('Resolution', thescreen);
        
        P.screen.screen_num   = thescreen;%max(nscreens); 0 is you have only one screen (like a laptop) 1 or 2 if you have multiple screens one is usually the matlab screen
        P.screen.width        = myres.width;
        P.screen.height       = myres.height;
        P.screen.rate         = myres.hz;
        P.screen.size         = [36 27]; %screen size in centimeters.
        P.screen.viewdist     = 55; % distance between subject and monitor
        
        P.setup.isEEG         = 0;
        P.setup.skipsync      = 1;
        P.setup.useCLUT       = 0;
        P.setup.CLUTfile      = 'inverse_CLUT 26 April 2012, 16-48.mat';
        
    case 'BUSCH02'
        
        thescreen = max(Screen('Screens'));
        myres = Screen('Resolution', thescreen);
        
        P.screen.screen_num   = thescreen;%max(nscreens); 0 is you have only one screen (like a laptop) 1 or 2 if you have multiple screens one is usually the matlab screen
        P.screen.width        = myres.width;
        P.screen.height       = myres.height;
        P.screen.rate         = myres.hz;
        P.screen.size         = [36 27]; %screen size in centimeters.
        P.screen.viewdist     = 55; % distance between subject and monitor
        
        P.setup.isEEG         = 0;
        P.setup.skipsync      = 1;
        P.setup.useCLUT       = 0;
        P.setup.CLUTfile      = 'inverse_CLUT 26 April 2012, 16-48.mat';
end

% Note: from this line onwards, variables coding the size of things
% indicate size in degrees visual angle. Internally, the functions
% executing stimulus genration and presentation will recompute these sizes
% into pixels.

%% ------------------------------------------------------------------------
%  Parameters of the screen.
%  Calculate size of a pixel in visual angles.
% ------------------------------------------------------------------------
P.screen.cx = round(P.screen.width/2); % x coordinate of screen center
P.screen.cy = round(P.screen.height/2); % y coordinate of screen center

[P.screen.pixperdeg, P.screen.degperpix] = VisAng(P);
P.screen.pixperdeg = mean(P.screen.pixperdeg);
P.screen.degperpix = mean(P.screen.degperpix);

P.screen.white = WhiteIndex(P.screen.screen_num);
P.screen.black = BlackIndex(P.screen.screen_num);



%% -----------------------------------------------------------------------
% Parameters of the display and stimuli
% ------------------------------------------------------------------------
P.stim.background_color = [100 100 100];
P.stim.display_diameter = 3; % degrees vis ang
P.stim.set_size = 10;

P.stim.target_diameter = 0.6; % degree vis ang
P.stim.target_thick = 0.2;
P.stim.target_color = [160 160 160; 255 255 255];
P.stim.target_gap = 20; % degrees of the full circle
P.stim.target_gapcolor = P.stim.background_color; % degrees of the full circle
% P.stim.target_gapcolor = [0 0 1]; % degrees of the full circle
P.stim.target_orientation = [0 45 90 135 180 225 270 315];

P.stim.cue_offset = 0.5; % in degs vis ang.
P.stim.cue_length = 1.5;
P.stim.cue_thick  = 0.1;
P.stim.cue_color  = [0 0 0];

P.stim.fix_size = 0.6;
P.stim.fix_color = [0 0 0];



%% -----------------------------------------------------------------------
% Parameters of the procedure & timing
%  -----------------------------------------------------------------------
P.paradigm.n_trials  = 2; % per permutation of a ll conditions

P.paradigm.break_after_x_trials = 20;    % Present a break after so many trials.

P.paradigm.dur_display      = 0.050;
P.paradigm.dur_prestim_mean = 2.0;
P.paradigm.dur_prestim_min  = 1.200;
P.paradigm.dur_prestim_max  = 3.500;
P.paradigm.dur_feedback     = 0.200;

P.paradigm.soa      = [
    -0.140
    0
    P.paradigm.dur_display + 0.000
    P.paradigm.dur_display + 0.020
    P.paradigm.dur_display + 0.040
    P.paradigm.dur_display + 0.080
    P.paradigm.dur_display + 0.160
    P.paradigm.dur_display + 0.320
    P.paradigm.dur_display + 1.200
];



%% -----------------------------------------------------------------------
% Trigger parameters
%  -----------------------------------------------------------------------
P.trigger.trig_dur   = 0.005;
P.trigger.trig_start = 250;
P.trigger.trig_stop  = 251;
P.trigger.trig_response = 252;



%% ------------------------------------------------------------------------
%  Define relevant buttons
%  ------------------------------------------------------------------------
KbName('UnifyKeyNames');
P.keys.upkey = KbName('UpArrow');
P.keys.downkey = KbName('DownArrow');
P.keys.lkey  = KbName('LeftArrow');
P.keys.rkey    = KbName('RightArrow');
P.keys.quitkey = KbName('ESCAPE');
P.keys.one   = KbName('1');
P.keys.two   = KbName('2');
P.keys.three = KbName('3');
P.keys.four  = KbName('4');
P.keys.five  = KbName('5');
P.keys.six   = KbName('6');
P.keys.seven = KbName('7');
P.keys.eight = KbName('8');
P.keys.nine  = KbName('9');



%% Done.

