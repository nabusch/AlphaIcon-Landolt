function [ph, count_ex] = myqPR_optimize_resp(ph, count_ex)
%% sort response from existing data
% while trying to respect the entropy constraints

% get trial number for the current observer
% n_trl = size(ph.data, 1);

% sort entropies and info gains
this_inf_gain = [(1:30)', ph.this.entropy];
this_inf_gain = sortrows(this_inf_gain, 2, 'descend');

% create where idxsoa are put together
for iSoa = 1:numel(ph.setting.soa)
    trialdist(iSoa,1) = iSoa;
    trialdist(iSoa, 2) = sum(ph.data(:,4)==iSoa);
end

% at some trials, for non-clear reasons, entropy is equivalent (??)
% choose then the idx with the higher information gain AND the highest
% number of trials
[putative_entropies, ph.sugg_soa] = deal(ph.this.soaidx);
subset_soa = trialdist(putative_entropies, :);
optimal_soa = subset_soa(subset_soa(:,2)==max(subset_soa(:,2)),1);

% get logical vector for the soa currently indicated by the qPR
test_trln = ph.data(:,4)==optimal_soa;

if sum(test_trln)>0 && any(ph.not_sorted_trls(test_trln))
    idx_this = find( test_trln & ph.not_sorted_trls ,1,'first');
else
    count_ex = count_ex+1;
    ph.count_ex = ph.count_ex +1;
    % start searchlight for most suitable point 
    acc_sl = 1;
    while true
        
        optimal_soa = this_inf_gain(acc_sl, 1);
        lgcl_sl_soa = ph.data(:,4)==optimal_soa;
        
        if sum(lgcl_sl_soa)>0 && any(ph.not_sorted_trls(lgcl_sl_soa))
            
            idx_this = find(lgcl_sl_soa & ph.not_sorted_trls, 1, 'first');
            break
            
        else
            
            acc_sl = acc_sl+1;
            
        end
        
    end
     
end

% update the actual soa that has been used in order to allow correct prior
% updating and parameters estimation
ph.this.soatime = ph.setting.soa(optimal_soa);
ph.this.soaidx = optimal_soa;

% remember to null the entry for idx (with a nan) in order not to be
% sorted anymore afterward
ph.not_sorted_trls(idx_this) = 0;

% find response provided by user at the trial selected
ph.this.correct = ph.data(idx_this, 7);

end

