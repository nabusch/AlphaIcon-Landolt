function x = lobesFlips(p,varargin)
% lobesFlips    simulates coinflips based on p.

% 03/30/2013    JB modified the order of varargins
%               ndraws is optional

if nargin==1;
    ndraws = 1;
else
    ndraws = varargin{1};
end

% lobesFlips generates binanry outcomes according to the probability p.
unif = rand(ndraws,length(p));
index = find(unif<repmat(p,[ndraws 1]));
[nones,m] = size(index);
x = zeros(ndraws,length(p));
if (nones ~=0)
    x(index) = ones(nones,m);
end
