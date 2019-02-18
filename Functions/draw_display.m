% draw_display

l = lines(P.stim.set_size);
l = Shuffle(l);

for ipos = 1:P.stim.set_size      
%     P.stim.target_gapcolor.*T.target_color
    
    my_landolt(win, xcoords(ipos) + P.screen.cx, ycoords(ipos) + P.screen.cy, ...
        P.stim.target_diameter*P.screen.pixperdeg, T.target_color, P.stim.target_thick*P.screen.pixperdeg, ...
        P.stim.target_gapcolor, P.stim.target_gap, ...
        T.orientations(ipos)-0.5*P.stim.target_gap);    
end