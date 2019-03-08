function my_wedge(win, x, y, circrad, circolor, cirwidth, ...
    gapcolor, gapwidth, gapdeg)

rect = [round(x-circrad), round(y-circrad), round(x+circrad), round(y+circrad)];

Screen('FillOval', win, circolor, rect);

x_end = round(x + circrad*sind(gapdeg));
y_end = round(y + circrad*-cosd(gapdeg));


% Screen('FrameArc',win, gapcolor, rect, ...
%     gapdeg, gapwidth, 2*cirwidth);

Screen('FillArc', win, gapcolor, rect, ...
    gapdeg, gapwidth);