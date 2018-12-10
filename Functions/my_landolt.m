function my_landolt(win, x, y, circrad, circolor, cirwidth, ...
    gapcolor, gapwidth, gapdeg)

rect = [round(x-circrad), round(y-circrad), round(x+circrad), round(y+circrad)];

Screen('FrameOval', win, circolor, ...
    rect, cirwidth);

x_end = round(x + circrad*sind(gapdeg));
y_end = round(y + circrad*-cosd(gapdeg));

% Screen('DrawLine', win, [255 0 0], ...
%     round(x), round(y), x_end, y_end, 10);

Screen('FrameArc',win, gapcolor, rect, ...
    gapdeg, gapwidth, 2*cirwidth);


%%
% figure; hold all;
% circrad = 1;
% plot(circrad*sind(1:360), circrad.*cosd(1:360), '.');
% 
% for igappos = 1:length(P.stim.target_orientation)
%     
%     gapdeg = P.stim.target_orientation(igappos);
%     
%     x_end = 0 + circrad*sind(gapdeg);
%     y_end = 0 + circrad*-cosd(gapdeg);
%     text(x_end, y_end, num2str(igappos), 'fontsize', 14)
% end
% axis square