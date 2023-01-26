function res = candidate_extraction(data_path, options)
% 
%
%REQUIRED INPUT ( 10Hz )
%   data.TimeStamp
%       .SAS_Angle
%       .Heading
%       .Speed
%       .AccelY
%       .GyroZ
%       .CF_Gway_TSigLHSw
%       .CF_Gway_TSigRHSw
%
data = readtable(data_path);

if ~exist('options','var')
    options = struct();
    options.window_size = 25;
    options.lc_thres = 3;
    options.lc_duration = 50;
    options.lc_pad_duration = 6;
    options.eval_duration = 50;
    options.eval_pad_duration = 6;
    options.eval_thres = 200;
    options.handle_nan = false;
end


if options.handle_nan
    for i = 1:width(data)
        data.(i)(isnan(data.(i))) = 0;
    end
end

[index_lh, index_rh, index_lh_s, index_lh_e, index_rh_s, index_rh_e] = find_lc_candidate(data, options.window_size, options.lc_thres, options.lc_duration, options.lc_pad_duration);


[flag_left, dist_left] = evaluate_lc_candidate(data, index_lh_s, index_lh_e, 'left', options.eval_duration, options.eval_pad_duration, options.eval_thres);
[flag_right, dist_right] = evaluate_lc_candidate(data, index_rh_s, index_rh_e, 'right', options.eval_duration, options.eval_pad_duration, options.eval_thres);


res = [];

for i = 1:length(index_lh_s)
    if ~flag_left(i)
        continue
    end
    entry = struct();
    entry.direction = 1;
    entry.directionStr = "left";
    entry.eventIndex = floor((index_lh_s(i) + index_lh_e(i))/2);
    entry.eventIndexList = index_lh_s(i):index_lh_e(i);
    entry.eventTimeStamp = data.TimeStamp(entry.eventIndex);
    entry.eventTimeStampList = data.TimeStamp(entry.eventIndexList);
    entry.duration = entry.eventTimeStampList(end)- entry.eventTimeStampList(1);
    entry.intensity = dist_left(i);

    res = [res, entry];
end

for i = 1:length(index_rh_s)
    if ~flag_right(i)
        continue
    end
    entry = struct();
    entry.direction = 2;
    entry.directionStr = "right";
    entry.eventIndex = floor((index_rh_s(i) + index_rh_e(i))/2);
    entry.eventIndexList = index_rh_s(i):index_rh_e(i);
    entry.eventTimeStamp = data.TimeStamp(entry.eventIndex);
    entry.eventTimeStampList = data.TimeStamp(entry.eventIndexList);
    entry.duration = entry.eventTimeStampList(end)- entry.eventTimeStampList(1);
    entry.intensity = dist_right(i);

    pred = [res, entry];
end

save('pred.mat', 'pred')

end

