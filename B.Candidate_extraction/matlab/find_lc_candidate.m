function [index_lh, index_rh, index_lh_s, index_lh_e, index_rh_s, index_rh_e] = find_lc_candidate(data, window_size, lc_thres, lc_duration, pad_duration)
    
    data = fillmissing(data, 'next');

    repHeading = zeros(size(data.Heading));
    radHeading = unwrap(deg2rad(data.Heading));
    for i = (window_size+1):(length(repHeading)-window_size)
        repHeading(i) = quantile(radHeading(i-window_size:i+window_size),0.5);
    end

    % 100Hz
%     lateral_displacement = -cumsum((radHeading-repHeading).*data.Speed*0.01);
    % 10Hz
    lateral_displacement = -cumsum((radHeading-repHeading).*data.Speed*0.1);
    lc_thres = lc_thres/3;

    sig_tanh = tanh([-pi*ones(1,pad_duration), linspace(-pi,pi,lc_duration+1), pi*ones(1,pad_duration)]);
    
    
    [istart, istop]=findsignal(lateral_displacement, (lc_thres).*sig_tanh, 'TimeAlignment', 'dtw','MaxNumSegments',120, 'Metric','euclidean', 'Annotate','all','MaxDistance',100, 'NormalizationLength',lc_duration+2*pad_duration+1, 'Normalization', 'Center');
    % Max Num segments  = 100Hz: Inf / 10Hz: 120
    index_lh = zeros(size(data.Heading));
    index_lh_s = [];
    index_lh_e = [];
    for i = 1:length(istart)
        if (lateral_displacement(istop(i))-lateral_displacement(istart(i)))<lc_thres/2
            continue
        end
        index_lh(istart(i):istop(i)) = 1;
        index_lh_s = [index_lh_s, istart(i)];
        index_lh_e = [index_lh_e, istop(i)];
    end

    [istart, istop]=findsignal(lateral_displacement, -(lc_thres).*sig_tanh, 'TimeAlignment', 'dtw','MaxNumSegments',120, 'Metric','euclidean', 'Annotate','all','MaxDistance',100, 'NormalizationLength',lc_duration+2*pad_duration+1, 'Normalization', 'Center');
    % Max Num segments  = 100Hz: Inf / 10Hz: 120
    index_rh = zeros(size(data.Heading));
    index_rh_s = [];
    index_rh_e = [];
    for i = 1:length(istart)
        if (lateral_displacement(istop(i))-lateral_displacement(istart(i)))>-lc_thres/2
            continue
        end
        index_rh(istart(i):istop(i)) = 1;
        index_rh_s = [index_rh_s, istart(i)];
        index_rh_e = [index_rh_e, istop(i)];
    end
    
end

