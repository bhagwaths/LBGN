mouse_names = {'AS-VHIP-BLA-1';
            'AS-vHIP-BLA-2';
            'AS-vHIP-BLA-3';
            'AS-vHIP-BLA-4';
            'AS-vHIP-BLA-5';
            'AS-vHIP-BLA-6';
            'AS-vHIP-BLA-7';
            'AS-vHIP-BLA-8'};

photometry_files = {'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day1\AS_vHIP_BLA_1-240816-084831';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day1\AS_vHIP_BLA_2-241202-093735';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day1\AS_vHIP_BLA_3-240816-113157';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day1\AS_vHIP_BLA_4-241202-122100';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day1\AS_vHIP_BLA_5-240816-141239';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day1\AS_vHIP_BLA_6-241202-150136';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day1\AS_vHIP_BLA_7-240816-165607';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day1\AS_vHIP_BLA_8-241202-174523'};

struggling_files = {'D:\AS-vHIP-BLA_struggling_analysis\Day1\AS-vHIP-BLA-1_Day1_DLC_struggling.csv';
'D:\AS-vHIP-BLA_struggling_analysis\Day1\AS-vHIP-BLA-2_Day1_DLC_struggling.csv';
'D:\AS-vHIP-BLA_struggling_analysis\Day1\AS-vHIP-BLA-3_Day1_DLC_struggling.csv';
'D:\AS-vHIP-BLA_struggling_analysis\Day1\AS-vHIP-BLA-4_Day1_DLC_struggling.csv';
'D:\AS-vHIP-BLA_struggling_analysis\Day1\AS-vHIP-BLA-5_Day1_DLC_struggling.csv';
'D:\AS-vHIP-BLA_struggling_analysis\Day1\AS-vHIP-BLA-6_Day1_DLC_struggling.csv';
'D:\AS-vHIP-BLA_struggling_analysis\Day1\AS-vHIP-BLA-7_Day1_DLC_struggling.csv';
'D:\AS-vHIP-BLA_struggling_analysis\Day1\AS-vHIP-BLA-8_Day1_DLC_struggling.csv'};

session_range = [0 7200]; % time range for struggling labels

TRANGES = {[-1720 9028];
[-1742 9018];
[-1419 8875];
[-1557 8872];
[-1547 9029];
[-1779 9033];
[-1397 8745];
[-1464 8721]};

BASELINE_PERS = {[-1720 -113];
[-1742 -219];
[-1419 -109];
[-1557 -265];
[-1547 -315];
[-1779 -338];
[-1397 -150];
[-1464 -224]};

onset_times = {1720;
1742;
1419;
1557;
1547;
1779;
1397;
1464};

STREAM_STORE1 = {'ax05A', 'a_05C'};
STREAM_STORE2 = {'ax70A', 'a_70C'};
STREAM_STORE3 = {'aFi1r', 'aFi1r'};

times_onset_combined = cell(1,numel(STREAM_STORE1));
signals_onset_combined = cell(1,numel(STREAM_STORE1));

times_offset_combined = cell(1,numel(STREAM_STORE1));
signals_offset_combined = cell(1,numel(STREAM_STORE1));

for stream=1:numel(STREAM_STORE1)
    times_onset_combined{stream} = [];
    signals_onset_combined{stream} = [];

    times_offset_combined{stream} = [];
    signals_offset_combined{stream} = [];
end

for mouse=1:numel(mouse_names)
    for stream=1:numel(STREAM_STORE1)
        photometry_data = TDTbin2mat(photometry_files{mouse});
        STREAM_STORES = {STREAM_STORE1{stream}, STREAM_STORE2{stream}, STREAM_STORE3{stream}};
    
        TRANGE = TRANGES{mouse};
        BASELINE_PER = BASELINE_PERS{mouse};
        
        photometry_data.epocs.Session.name = 'Session';
        photometry_data.epocs.Session.onset = onset_times{mouse};
        photometry_data.epocs.Session.offset = 1638; % not used
        photometry_data.epocs.Session.data = 1;
        
        EPOC = 'Session';
        ARTIFACT = inf;
        N = 100;
        
        photometry_data = TDTfilter(photometry_data,EPOC,'TIME',TRANGE);
        remove_artifacts(photometry_data.streams, ARTIFACT, STREAM_STORES);
        [signal.zall, signal.zerror, signal.ts1, signal.Y_dF_all] = process_signal(photometry_data.streams, STREAM_STORES, TRANGE, BASELINE_PER, N);

        struggling_data = readtable(struggling_files{mouse});
        struggling_data.Frames = struggling_data.Frames / 10;
        struggling_data.Properties.VariableNames{'Frames'} = 'Time';

        struggling_data = struggling_data(struggling_data.Time >= session_range(1) & struggling_data.Time <= session_range(2), :);
        
        struggle_start_idx = find(struggling_data.Struggling(1:end-1) == 0 & struggling_data.Struggling(2:end) == 100) + 1;
        struggle_end_idx = find(struggling_data.Struggling(1:end-1) == 100 & struggling_data.Struggling(2:end) == 0);

        if numel(struggle_end_idx) < numel(struggle_start_idx)
            struggle_start_idx(end) = [];
        end

        struggle_start_times = struggling_data.Time(struggle_start_idx);
        struggle_end_times = struggling_data.Time(struggle_end_idx);
        
        struggle_mean_dists = [];
        for i=1:numel(struggle_start_idx)
            curr_dists = struggling_data.Distance(struggle_start_idx(i):struggle_end_idx(i));
            mean_curr_dist = mean(curr_dists);
            struggle_mean_dists = [struggle_mean_dists; mean_curr_dist];
        end
        median_dist = median(struggle_mean_dists);

        figure;
        for i=1:numel(struggle_start_times)
            patch([struggle_start_times(i), struggle_start_times(i), struggle_end_times(i), struggle_end_times(i)], [-2 80 80 -2], [0.85 0.85 0.85], 'EdgeColor','none'); hold on;
        end
        plot(signal.ts1, signal.zall, 'LineWidth', 2);
        xline(0, 'LineStyle', '--', 'Label', 'Trial start');
        title(sprintf('%s (%s, %s)', mouse_names{mouse}, STREAM_STORE1{stream}, STREAM_STORE2{stream}), 'Interpreter', 'none');
        xlabel('Time (s)');
        ylabel('ΔF/F');

        sig = .05;
        consec_thresh = 3.3;
        y = 3.25;
        
        % Struggling onset
        signals_onset = [];
        times_onset = [];
        for i=1:numel(struggle_start_times)
            [~, curr_idx] = min(abs(signal.ts1 - struggle_start_times(i)));
            curr_signal = signal.zall(curr_idx-50:curr_idx+300);
            curr_time = signal.ts1(curr_idx-50:curr_idx+300) - signal.ts1(curr_idx);
            signals_onset = [signals_onset; curr_signal];
            times_onset = [times_onset; curr_time];

            signals_onset_combined{stream} = [signals_onset_combined{stream}; curr_signal];
            times_onset_combined{stream} = [times_onset_combined{stream}; curr_time];
        end
        
        mean_signal_onset = mean(signals_onset,1);
        sem_signal_onset = std(signals_onset,[],1) / sqrt(size(signals_onset,1));
        
        mean_time_onset = mean(times_onset,1);
        
        figure;
        plot(mean_time_onset, mean_signal_onset, 'LineWidth', 2);
        errorplot3(mean_signal_onset-sem_signal_onset,mean_signal_onset+sem_signal_onset,...
            [min(mean_time_onset), max(mean_time_onset)],[0 0.4470 0.7410],0.3);
        xline(0,'LineStyle','--','Label','Struggling onset');
        bootstrapping(signals_onset, sig, consec_thresh, y);
        title(sprintf('%s (%s, %s), struggling onset', mouse_names{mouse}, STREAM_STORE1{stream}, STREAM_STORE2{stream}), 'Interpreter', 'none');
        xlim([-5 30]); ylim([-1 5]);

        % Struggling offset
        signals_offset = [];
        times_offset = [];
        for i=1:numel(struggle_end_times)
            [~, curr_idx] = min(abs(signal.ts1 - struggle_end_times(i)));
            curr_signal = signal.zall(curr_idx-50:curr_idx+300);
            curr_time = signal.ts1(curr_idx-50:curr_idx+300) - signal.ts1(curr_idx);
            signals_offset = [signals_offset; curr_signal];
            times_offset = [times_offset; curr_time];

            signals_offset_combined{stream} = [signals_offset_combined{stream}; curr_signal];
            times_offset_combined{stream} = [times_offset_combined{stream}; curr_time];
        end

        mean_signal_offset = mean(signals_offset,1);
        sem_signal_offset = std(signals_offset,[],1) / sqrt(size(signals_offset,1));
        
        mean_time_offset = mean(times_offset,1);

        figure;
        plot(mean_time_offset, mean_signal_offset, 'LineWidth', 2);
        errorplot3(mean_signal_offset-sem_signal_offset,mean_signal_offset+sem_signal_offset,...
            [min(mean_time_offset), max(mean_time_offset)],[0 0.4470 0.7410],0.3);
        xline(0,'LineStyle','--','Label','Struggling offset');
        bootstrapping(signals_offset, sig, consec_thresh, y);
        title(sprintf('%s (%s, %s), struggling offset', mouse_names{mouse}, STREAM_STORE1{stream}, STREAM_STORE2{stream}), 'Interpreter', 'none');
        xlim([-5 30]); ylim([-1 5]);
    end
end

for stream=1:numel(STREAM_STORE1)
    mean_signals_onset_combined = mean(signals_onset_combined{stream},1);
    mean_times_onset_combined = mean(times_onset_combined{stream},1);
    sem_signals_onset_combined = std(signals_onset_combined{stream},1) / sqrt(size(signals_onset_combined{stream},1));

    mean_signals_offset_combined = mean(signals_offset_combined{stream},1);
    mean_times_offset_combined = mean(times_offset_combined{stream},1);
    sem_signals_offset_combined = std(signals_offset_combined{stream},1) / sqrt(size(signals_offset_combined{stream},1));

    figure;
    plot(mean_times_onset_combined, mean_signals_onset_combined, 'LineWidth', 2); hold on;
    errorplot3(mean_signals_onset_combined-sem_signals_onset_combined, mean_signals_onset_combined+sem_signals_onset_combined,...
    [min(mean_times_onset_combined) max(mean_times_onset_combined)],[0 0.4470 0.7410],0.3);
    xline(0,'LineStyle','--','Label','Struggling onset');
    bootstrapping(signals_onset_combined{stream}, sig, consec_thresh, y); hold on;
    title(sprintf('All mice (%s, %s), struggling onset', STREAM_STORE1{stream}, STREAM_STORE2{stream}), 'Interpreter', 'none');
    xlim([-5 30]); ylim([-1 5]);

    figure;
    plot(mean_times_offset_combined, mean_signals_offset_combined, 'LineWidth', 2); hold on;
    errorplot3(mean_signals_offset_combined-sem_signals_offset_combined, mean_signals_offset_combined+sem_signals_offset_combined,...
    [min(mean_times_offset_combined) max(mean_times_offset_combined)],[0 0.4470 0.7410],0.3);
    xline(0,'LineStyle','--','Label','Struggling offset');
    bootstrapping(signals_offset_combined{stream}, sig, consec_thresh, y); hold on;
    title(sprintf('All mice (%s, %s), struggling offset', STREAM_STORE1{stream}, STREAM_STORE2{stream}), 'Interpreter', 'none');
    xlim([-5 30]); ylim([-1 5]);
end