function p = myqPR_Rt_given_tauANDx(univ_p_resp, r, idxSOA)
% probability of r given the present coefficients
% other important step. Given the response obtained by the simulated
% observer (see myqPR_observer function), this function selects, from the
% 4D matrix of all possible events, the 3D matrix corresponding to the
% present SOA.
% notably, the p values are converted according to the response of the
% observer (p if correct, 1-p if wrong)

if r
    p = squeeze(univ_p_resp(:,:,:,idxSOA));
else
    p = 1-squeeze(univ_p_resp(:,:,:,idxSOA));
end

end

