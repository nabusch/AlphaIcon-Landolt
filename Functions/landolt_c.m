function landolt_c(S,E,position,degree)
%LANDOLT C Draws a landolt ring  with gap at left or right position (without flipping).
%%%% Requires the following screen parameter from S
% S.pixperdeg       = Pixel per degree.
% S.disp            = PTB Windowpointer.
%%%% Requires the following screen parameter from E
% E.targetsize      = Radius of landolt ring in degree.
% E.targethick      = Thickness of landolt ring in degree.
% E.gapsize         = Gap size in pixel (see DrawLine).
% E.targetpos_left  = Predefined coordinates of landolt ring center (left)
% E.targetpos_right = Predefined coordinates of landolt ring center (right)
% E.background      = RGB Background Color.
% E.targetcol       = RGB Target Color.
%%%% Furher arguments
% position          = Determines screen position of landolt ring. Enter string, either 'left' or 'right'.
% degree            = Position of gap in radiants.


% position of landolt c center
p_left              = E.targetpos_left;
p_right             = E.targetpos_right;

% outer and inner circle radius
lradius             = round(E.targetsize/2*S.pixperdeg);                         
iradius             = lradius - round(E.targethick*S.pixperdeg);              

% landolt ring definition
outer_ring_left     =   [ p_left(1)-lradius     p_left(2)-lradius   p_left(1)+lradius   p_left(2)+lradius ];
outer_ring_right    =   [ p_right(1)-lradius    p_right(2)-lradius  p_right(1)+lradius  p_right(2)+lradius ];
inner_ring_left     =   [ p_left(1)-iradius     p_left(2)-iradius   p_left(1)+iradius   p_left(2)+iradius ];
inner_ring_right    =   [ p_right(1)-iradius    p_right(2)-iradius  p_right(1)+iradius  p_right(2)+iradius ];

% determine point on perimeter for chosen degree
peri_left       =   [ 1.1*lradius*cos(degree)+p_left(1)     1.1*lradius*sin(degree)+p_left(2)];
peri_right      =   [ 1.1*lradius*cos(degree)+p_right(1)    1.1*lradius*sin(degree)+p_right(2)];

% coordinates for line which draws the gap 
gap_left        =   [p_left(1)  p_left(2)   peri_left(1)    peri_left(2)];
gap_right       =   [p_right(1) p_right(2)  peri_right(1)   peri_right(2)];

% check chosen position
if strcmp(position,'left')
    outer_ring  = outer_ring_left;
    inner_ring  = inner_ring_left;
    gap         = gap_left;
elseif strcmp(position,'right')
    outer_ring  = outer_ring_right;
    inner_ring  = inner_ring_right;
    gap         = gap_right; 
end

% Draw landolt c
Screen('FillOval',S.disp, E.targetcol, outer_ring); 
Screen('FillOval',S.disp, E.background, inner_ring); 
Screen('DrawLine',S.disp, E.background, gap(1), gap(2), gap(3), gap(4),E.gapsize);      

end