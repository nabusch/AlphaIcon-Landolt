function DrawCue(T, P, xcoords, ycoords, win)

pos = T.position;
% pos=t;

%%
% The '-' is necessary for converting y-ccordinates because for matlab
% functions negative y coordinates are below the point of origin, while for
% PTB functions positive y coordinates are below point of origin (upper
% left corner of monitor).

[THETA,~] = cart2pol(round(xcoords(pos)), ...
    round(-ycoords(pos)));

x1 = round((P.screen.pixperdeg * P.stim.cue_offset) * cos(THETA));
y1 = -round((P.screen.pixperdeg * P.stim.cue_offset) * sin(THETA));

x2 = round((P.screen.pixperdeg*P.stim.cue_offset + P.screen.pixperdeg*P.stim.cue_length) * cos(THETA));
y2 = -round((P.screen.pixperdeg*P.stim.cue_offset + P.screen.pixperdeg*P.stim.cue_length) * sin(THETA));

%%

% figure; hold all
% plot(round(xcoords(pos)), -round(ycoords(pos)), 'ko')
% plot(x1, y1, 'ro')
% plot(x2, y2, 'ro')
% gridxy(0,0)


%%


Screen('DrawLine', win, P.stim.cue_color, ...
    P.screen.cx+x1, P.screen.cy+y1, P.screen.cx+x2, P.screen.cy+y2, ...
    P.screen.pixperdeg*P.stim.cue_thick);
