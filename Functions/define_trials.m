function INFO = define_trials(INFO)

%% Define what happens on each trial by permuting all experimental factors.

P = INFO.P; % just for shorthand.

% To randomize the orientation of the different Landolt rings within a
% trial, we draw from a big set of two times the set of orientations
% ==> any orientation can occur at most two times.
orientations = repmat(P.stim.target_orientation, 1, 2);

itrial = 0;

for irepeat = 1:P.paradigm.n_trials
    for isoa = 1:length(P.paradigm.soa)
        for icontrast = 1:size(P.stim.target_color,1)
            for isetsize = 1:length(P.stim.set_size)
                for iposition = 1:P.stim.set_size(isetsize)
                    itrial = itrial + 1;
                    randorientations = Shuffle(orientations);
                    
                    T(itrial).setsize = P.stim.set_size(isetsize);
                    T(itrial).position = iposition;
                    T(itrial).side     = sign(0.5*(length(P.stim.set_size(isetsize))+1)-P.stim.set_size(isetsize));
                    % negative=left; positive=right;
                    T(itrial).isoa     = isoa;
                    T(itrial).soa      = P.paradigm.soa(isoa);
                    T(itrial).orientations = randorientations(1:P.stim.set_size(isetsize));
                    T(itrial).target_color = P.stim.target_color(icontrast,:);
                    
                    T(itrial).button = [];
                    T(itrial).correct = [];
                    T(itrial).rt = [];
                    T(itrial).t_trial_on = [];
                    T(itrial).t_display_on = [];
                    T(itrial).t_display_off = [];
                    T(itrial).t_feedback_on = [];
                    T(itrial).dur_display = [];
                    T(itrial).t_cue_on = [];
                end
            end
        end
    end
end

INFO.T = Shuffle(T);



%% Done.