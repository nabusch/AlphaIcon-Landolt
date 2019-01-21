function [tsoa, INFO] = qpr_get_recommendation(INFO, itrial)

% tsoa: SOA in ms

% Computes entropy and optimal SOA for this trial
INFO.QPR.this = qSelect(INFO.QPR.this, INFO.QPR.setting);
% Use this SOA for this trial.
tsoa = INFO.QPR.setting.soa(INFO.QPR.this.soa);
