function [ev_index] = plot_pred(data_path, direction)
%% direction = 'right' or 'left'

data = readtable(data_path)
ans = candidate_extraction(data_path)
ev_index = [];

for i = 1: length(ans)
    ev_index0 = getfield(ans(i), 'eventIndexList');
    dir = getfield(ans(i), 'directionStr');
    
    if strcmp(direction, dir)
        ev_index = [ev_index, ev_index0];
    end

end

plot(data.TimeStamp, data.lateral_offset, 'b',data(ev_index,:).TimeStamp, data(ev_index,:).lateral_offset, 'r*', 'MarkerSize',3)