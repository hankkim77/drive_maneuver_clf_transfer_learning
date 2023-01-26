function [flag,dist] = evaluate_lc_candidate(data, lc_candidate_s, lc_candidate_e, direction, duration, padding, thres)
%EVALUATE_LC_CANDIDATE Summary of this function goes here
%   Detailed explanation goes here

if ~exist('thres','var')
    thres = 200;
end
if ~exist('padding','var')
    padding = 50;
end
if ~exist('duration','var')
    duration = 500;
end

sig = [zeros(1,padding), sin(linspace(0,2*pi, duration+1)), zeros(1,padding)];
sig((1:padding) + padding/2) = interp1([1:padding/2,(padding/2:padding)+padding],[sig(1:padding/2),sig((padding/2:padding)+padding)], (1:padding) + padding/2,'spline');
sig(end-(padding+duration/2)+1:end) = -flip(sig(1:(padding+duration/2)));

data.AccelY(isnan(data.AccelY)) = 0;
data.SAS_Angle(isnan(data.SAS_Angle)) = 0;
data.GyroZ(isnan(data.GyroZ)) = 0;

flag = zeros(size(lc_candidate_s));
dist = zeros(size(lc_candidate_s));
if strcmp(direction, 'right')
    sig = -sig;
end


for i = 1:length(lc_candidate_s)
    ACY = normalize(data.AccelY(lc_candidate_s(i)-padding:lc_candidate_e(i)+padding));
    ACY(isnan(ACY)) = 0;
    SAS = normalize(data.SAS_Angle(lc_candidate_s(i)-padding:lc_candidate_e(i)+padding));
    SAS(isnan(SAS)) = 0;
    GYZ = normalize(data.GyroZ(lc_candidate_s(i)-padding:lc_candidate_e(i)+padding));
    GYZ(isnan(GYZ)) = 0;

    d1 = dtw(rescale(ACY,-1,1), rescale(normalize(sig),-1,1));
    d2 = dtw(rescale(SAS,-1,1), rescale(normalize(sig),-1,1));
    d3 = dtw(rescale(GYZ,-1,1), rescale(normalize(sig),-1,1));
    dist(i) = d1+d2+d3;
    if dist(i)<thres
        flag(i) = 1;
    end

end

end

