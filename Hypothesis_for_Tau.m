% a0 is the asymptotic performance level, often associated with residual
% information in short-term memory after iconic memory decays completely;
% a1 is the performance level when x = 0; 
% and tau is the time constant of iconic memory decay, the time it takes
% for the observer’s partial-report superiority effect to drop to 37% of
% its initial level.

% Exponential decay formula by Gegenfurtner & Sperling.
soa = -1:0.5:1.5;

A0 = 0.2;
A1 = 1;
% C1 = 0.1;
% C2 = 0.3;
tau1 = 0.4;
tau2 = 0.8;

y1 = A0 + (A1-A0)*exp(-soa./tau1);
y2 = A0 + A1*exp(-soa./tau1);
% y2 = A0 + (A1-A0)*exp(-soa./tau2);

figure('color', 'w')
hold all
plot(soa, y1, 'r')
% plot(soa, y2, 'b')



ylim([0 3])
xlabel('SOA')
ylabel('performance')

legend(['tau = ' num2str(tau1)], ...
    ['tau = ' num2str(tau2)])

% gridxy(tau1,0.37)

% smaller tau --> faster/steeper decay.
% We expect that strong alpha is bad for perception. Thus:
% strong alpha --> smaller tau
% weak alpha --> larger tau
% Thus, if we fit the model for bins of alpha:
% bin1 (weak alpha) - bin2 (strong alpha) = a positive difference.
