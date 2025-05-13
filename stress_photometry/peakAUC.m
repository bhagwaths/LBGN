function [peak_AUCs] = peakAUC(maxtab,v,ts1)

v_norm = v-median(v(ts1 < 0));
v_smooth = sgolayfilt(v_norm,2,11);

peak_idx = maxtab(:,1);
peak_times = maxtab(:,2);

peak_start_idx = [];
peak_end_idx = [];
peak_AUCs = [];

for i=1:numel(peak_times)
    start_idx = peak_idx(i);
    if start_idx > 2
        while v_smooth(start_idx-1) > v_smooth(start_idx)
            start_idx = start_idx - 1;
        end
        while start_idx > 1 && v_smooth(start_idx-1) < v_smooth(start_idx)
            start_idx = start_idx - 1;
        end
    end
    end_idx = peak_idx(i);
    while v_smooth(end_idx+1) > v_smooth(end_idx)
        end_idx = end_idx + 1;
    end
    while end_idx < length(v_smooth) && v_smooth(end_idx) > v_smooth(end_idx+1)
        end_idx = end_idx + 1;
    end
    peak_start_idx = [peak_start_idx; start_idx];
    peak_end_idx = [peak_end_idx; end_idx];

    peak_ts1 = ts1(peak_start_idx(i):peak_end_idx(i));
    peak_v = v(peak_start_idx(i):peak_end_idx(i));
    peak_AUC = trapz(peak_ts1, peak_v);
    peak_AUCs = [peak_AUCs; peak_AUC];
end

% colors = {[.8 1 1]; [1 .8 .8]};
% figure;
% for i=1:numel(peak_start_idx)
%     if mod(i,2)==1
%         color = colors{1};
%     else
%         color = colors{2};
%     end
%     patch([ts1(peak_start_idx(i)) ts1(peak_end_idx(i)) ts1(peak_end_idx(i)) ts1(peak_start_idx(i))],...
%     [-10 -10 50 50], color, 'EdgeColor','none'); hold on;
% end
% plot(ts1,v_norm,'LineWidth',2);
% xline(peak_times);
% yline(0,'--');

end