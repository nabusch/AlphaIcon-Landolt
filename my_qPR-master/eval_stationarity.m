function [out_vect] = eval_stationarity(vect, step)

acc = step+1;
n_el = numel(vect);
out_vect = nan(size(vect));

while acc<=n_el
    
    red_vect = vect(acc-step:acc);
    m_rv = mean(red_vect);
    var = sum((m_rv-red_vect).^2);
    out_vect(acc) = var;
    acc = acc+1;
    
end


end

