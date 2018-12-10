function IsQuit = test_logfile(INFO)
% Test if logfile exists.
IsQuit = 0;

if exist(INFO.logfilename)
    disp('#######################################')
    disp('#######################################')
    asktext = ['File exists: ', INFO.logfilename, '! Overwrite [y/n]?\n'];

    
    answer = 0;
    
    while answer==0
        r = input(asktext, 's');
        if r=='y'
            decision = 1; % overwrite
            disp('OVERWRITING LOGFILES NOW.')
            answer = 1;
        elseif r=='n' % do not overwrite and quit
            disp('Will not overwrite. Exit programm.')
            answer = 1;
            IsQuit = 1;
        end
    end

end  