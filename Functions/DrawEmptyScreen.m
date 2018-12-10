Screen(win,'FillRect', P.stim.background_color);
% my_fixationpoint(window, P.CenterX, P.CenterY, P.FixSize, P.FixColor);
my_optimal_fixationpoint(win, P.screen.cx, P.screen.cy, P.stim.fix_size, P.stim.fix_color, P.stim.background_color, P.screen.pixperdeg)
