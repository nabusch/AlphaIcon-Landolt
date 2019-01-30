function [ Report, isQuit, secs ] = get_buttonpress(P)

%%
% WaitSecs(0.200);
Report = 0;
isQuit = 0;
keyIsDown = 0;

while Report==0
    [keyIsDown,secs,keyCode] = KbCheck;
    if keyIsDown
        if keyCode(P.keys.quitkey)
            Report = 99; isQuit = 1;
            return;
        else            
            Report = str2num(KbName(find(keyCode)));
        end;        
    end;
end;

