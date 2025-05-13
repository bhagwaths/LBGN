mouse_names = {'AS-vHIP-BLA-1';
            'AS-vHIP-BLA-3';
            'AS-vHIP-BLA-4';
            'AS-vHIP-BLA-5';
            'AS-vHIP-BLA-6';
            'AS-vHIP-BLA-7';
            'AS-vHIP-BLA-8';
            'AS-vHIP-BLA-1';
            'AS-vHIP-BLA-2';
            'AS-vHIP-BLA-4';
            'AS-vHIP-BLA-5';
            'AS-vHIP-BLA-6';
            'AS-vHIP-BLA-7';
            'AS-vHIP-BLA-8'};

plot_colors = {[0.04 .03 0.3]; [0.2 0.3 0.1]};

groupNames = {'BLA', 'vHIP'};
groups = {'BLA'; 'BLA'; 'BLA'; 'BLA'; 'BLA'; 'BLA'; 'BLA'; 'vHIP'; 'vHIP'; 'vHIP'; 'vHIP'; 'vHIP'; 'vHIP'; 'vHIP'};

STREAM_STORE1 = {'ax05A', 'a_05C'}; % same order as groupNames
STREAM_STORE2 = {'ax70A', 'a_70C'};
STREAM_STORE3 = {'aFi1r', 'aFi1r'};

% photometry_files = {'D:\photometry analyzed\AS-vHIP-BLA_stress\day 1 120224\AS_vHIP_BLA_1-240816-084831';
%             'D:\photometry analyzed\AS-vHIP-BLA_stress\day 1 120224\AS_vHIP_BLA_3-240816-113157';
%             'D:\photometry analyzed\AS-vHIP-BLA_stress\day 1 120224\AS_vHIP_BLA_4-241202-122100';
%             'D:\photometry analyzed\AS-vHIP-BLA_stress\day 1 120224\AS_vHIP_BLA_5-240816-141239';
%             'D:\photometry analyzed\AS-vHIP-BLA_stress\day 1 120224\AS_vHIP_BLA_6-241202-150136';
%             'D:\photometry analyzed\AS-vHIP-BLA_stress\day 1 120224\AS_vHIP_BLA_7-240816-165607';
%             'D:\photometry analyzed\AS-vHIP-BLA_stress\day 1 120224\AS_vHIP_BLA_8-241202-174523';
%             'D:\photometry analyzed\AS-vHIP-BLA_stress\day 1 120224\AS_vHIP_BLA_1-240816-084831';
%             'D:\photometry analyzed\AS-vHIP-BLA_stress\day 1 120224\AS_vHIP_BLA_2-241202-093735';
%             'D:\photometry analyzed\AS-vHIP-BLA_stress\day 1 120224\AS_vHIP_BLA_4-241202-122100';
%             'D:\photometry analyzed\AS-vHIP-BLA_stress\day 1 120224\AS_vHIP_BLA_5-240816-141239';
%             'D:\photometry analyzed\AS-vHIP-BLA_stress\day 1 120224\AS_vHIP_BLA_6-241202-150136';
%             'D:\photometry analyzed\AS-vHIP-BLA_stress\day 1 120224\AS_vHIP_BLA_7-240816-165607';
%             'D:\photometry analyzed\AS-vHIP-BLA_stress\day 1 120224\AS_vHIP_BLA_8-241202-174523'};

photometry_files = {'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day1\AS_vHIP_BLA_1-240816-084831';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day1\AS_vHIP_BLA_3-240816-113157';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day1\AS_vHIP_BLA_4-241202-122100';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day1\AS_vHIP_BLA_5-240816-141239';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day1\AS_vHIP_BLA_6-241202-150136';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day1\AS_vHIP_BLA_7-240816-165607';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day1\AS_vHIP_BLA_8-241202-174523';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day1\AS_vHIP_BLA_1-240816-084831';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day1\AS_vHIP_BLA_2-241202-093735';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day1\AS_vHIP_BLA_4-241202-122100';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day1\AS_vHIP_BLA_5-240816-141239';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day1\AS_vHIP_BLA_6-241202-150136';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day1\AS_vHIP_BLA_7-240816-165607';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day1\AS_vHIP_BLA_8-241202-174523'};


% struggling_files = {'D:\photometry analyzed\AS-vHIP-BLA_stress\day 1 120224\struggling_day1\AS-vHIP-BLA-1_Day1_DLC_struggling.csv';
% 'D:\photometry analyzed\AS-vHIP-BLA_stress\day 1 120224\struggling_day1\AS-vHIP-BLA-3_Day1_DLC_struggling.csv';
% 'D:\photometry analyzed\AS-vHIP-BLA_stress\day 1 120224\struggling_day1\AS-vHIP-BLA-4_Day1_DLC_struggling.csv';
% 'D:\photometry analyzed\AS-vHIP-BLA_stress\day 1 120224\struggling_day1\AS-vHIP-BLA-5_Day1_DLC_struggling.csv';
% 'D:\photometry analyzed\AS-vHIP-BLA_stress\day 1 120224\struggling_day1\AS-vHIP-BLA-6_Day1_DLC_struggling.csv';
% 'D:\photometry analyzed\AS-vHIP-BLA_stress\day 1 120224\struggling_day1\AS-vHIP-BLA-7_Day1_DLC_struggling.csv';
% 'D:\photometry analyzed\AS-vHIP-BLA_stress\day 1 120224\struggling_day1\AS-vHIP-BLA-8_Day1_DLC_struggling.csv';
% 'D:\photometry analyzed\AS-vHIP-BLA_stress\day 1 120224\struggling_day1\AS-vHIP-BLA-1_Day1_DLC_struggling.csv';
% 'D:\photometry analyzed\AS-vHIP-BLA_stress\day 1 120224\struggling_day1\AS-vHIP-BLA-2_Day1_DLC_struggling.csv';
% 'D:\photometry analyzed\AS-vHIP-BLA_stress\day 1 120224\struggling_day1\AS-vHIP-BLA-4_Day1_DLC_struggling.csv';
% 'D:\photometry analyzed\AS-vHIP-BLA_stress\day 1 120224\struggling_day1\AS-vHIP-BLA-5_Day1_DLC_struggling.csv';
% 'D:\photometry analyzed\AS-vHIP-BLA_stress\day 1 120224\struggling_day1\AS-vHIP-BLA-6_Day1_DLC_struggling.csv';
% 'D:\photometry analyzed\AS-vHIP-BLA_stress\day 1 120224\struggling_day1\AS-vHIP-BLA-7_Day1_DLC_struggling.csv';
% 'D:\photometry analyzed\AS-vHIP-BLA_stress\day 1 120224\struggling_day1\AS-vHIP-BLA-8_Day1_DLC_struggling.csv'};

struggling_files = {'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day1\AS-vHIP-BLA-1_Day1_DLC_struggling.csv'
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day1\AS-vHIP-BLA-3_Day1_DLC_struggling.csv'
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day1\AS-vHIP-BLA-4_Day1_DLC_struggling.csv'
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day1\AS-vHIP-BLA-5_Day1_DLC_struggling.csv'
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day1\AS-vHIP-BLA-6_Day1_DLC_struggling.csv'
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day1\AS-vHIP-BLA-7_Day1_DLC_struggling.csv'
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day1\AS-vHIP-BLA-8_Day1_DLC_struggling.csv'
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day1\AS-vHIP-BLA-1_Day1_DLC_struggling.csv'
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day1\AS-vHIP-BLA-2_Day1_DLC_struggling.csv'
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day1\AS-vHIP-BLA-4_Day1_DLC_struggling.csv'
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day1\AS-vHIP-BLA-5_Day1_DLC_struggling.csv'
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day1\AS-vHIP-BLA-6_Day1_DLC_struggling.csv'
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day1\AS-vHIP-BLA-7_Day1_DLC_struggling.csv'
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day1\AS-vHIP-BLA-8_Day1_DLC_struggling.csv'};

session_range = [5400 7200]; % time range for struggling labels

TRANGES = {[-1720 9028]; % 1
[-1419 8875]; % 3
[-1557 8872]; % 4
[-1547 9029]; % 5
[-1779 9033]; % 6
[-1397 8745]; % 7
[-1464 8721]; % 8
[-1720 9028]; % 1
[-1742 9018]; % 2
[-1557 8872]; % 4
[-1547 9029]; % 5
[-1779 9033]; % 6
[-1397 8745]; % 7
[-1464 8721]}; % 8

BASELINE_PERS = {[-1720 -113]; % 1
[-1419 -109]; % 3
[-1557 -265]; % 4
[-1547 -315]; % 5
[-1779 -338]; % 6
[-1397 -150]; % 7
[-1464 -224]; % 8
[-1720 -113]; % 1
[-1742 -219]; % 2
[-1557 -265]; % 4
[-1547 -315]; % 5
[-1779 -338]; % 6
[-1397 -150]; % 7
[-1464 -224]}; % 8

onset_times = {1720; % 1
1419; % 3
1557; % 4
1547; % 5
1779; % 6
1397; % 7
1464; % 8
1720; % 1
1742; % 2
1557; % 4
1547; % 5
1779; % 6
1397; % 7
1464}; % 8

FPS = 9.96;

%%

sig = .05;
consec_thresh = 14;
y = 5.4;

xlims = [-5 30];
ylims = [-.5 5.5];

AUC_range_pre = [-5 0]; % time range for AUC calculation (pre)
AUC_range_post = [0 15]; % time range for AUC calculation (post)

AUC_output_file = 'AS-vHIP-BLA_Day1_AUC_120min.xlsx';
latency_output_file = 'AS-vHIP-BLA_Day1_latency_120min.xlsx';
ampl_output_file = 'AS-vHIP-BLA_Day1_ampl_120min.xlsx';
num_events_output_file = 'AS-vHIP-BLA_Day1_num_events_120min.xlsx';

%%

num_struggle = cell(1,numel(groupNames));
num_struggle_high = cell(1,numel(groupNames));
num_struggle_low = cell(1,numel(groupNames));

mean_signal_onset_combined = cell(1,numel(groupNames));
sem_signal_onset_combined = cell(1,numel(groupNames));
mean_time_onset_combined = cell(1,numel(groupNames));

mean_high_struggle_onset_combined = cell(1,numel(groupNames));
mean_low_struggle_onset_combined = cell(1,numel(groupNames));
sem_high_struggle_onset_combined = cell(1,numel(groupNames));
sem_low_struggle_onset_combined = cell(1,numel(groupNames));

mean_signal_offset_combined = cell(1,numel(groupNames));
sem_signal_offset_combined = cell(1,numel(groupNames));
mean_time_offset_combined = cell(1,numel(groupNames));

mean_high_struggle_offset_combined = cell(1,numel(groupNames));
mean_low_struggle_offset_combined = cell(1,numel(groupNames));
sem_high_struggle_offset_combined = cell(1,numel(groupNames));
sem_low_struggle_offset_combined = cell(1,numel(groupNames));

for group=1:numel(groupNames)
    num_struggle{group} = [];
    num_struggle_high{group} = [];
    num_struggle_low{group} = [];

    mean_signal_onset_combined{group} = [];
    sem_signal_onset_combined{group} = [];
    mean_time_onset_combined{group} = [];

    mean_high_struggle_onset_combined{group} = [];
    mean_low_struggle_onset_combined{group} = [];
    sem_high_struggle_onset_combined{group} = [];
    sem_low_struggle_onset_combined{group} = [];

    mean_signal_offset_combined{group} = [];
    sem_signal_offset_combined{group} = [];
    mean_time_offset_combined{group} = [];

    mean_high_struggle_offset_combined{group} = [];
    mean_low_struggle_offset_combined{group} = [];
    sem_high_struggle_offset_combined{group} = [];
    sem_low_struggle_offset_combined{group} = [];

    mean_struggle_speeds{group} = [];
    struggle_speeds{group} = [];
    signal_onset_combined{group} = [];
end

for mouse=1:numel(mouse_names)
    group = find(strcmp(groups{mouse},groupNames));
    STREAM_STORES = {STREAM_STORE1{group}, STREAM_STORE2{group}, STREAM_STORE3{group}};

    photometry_data = TDTbin2mat(photometry_files{mouse});
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
    struggling_data.Frames = struggling_data.Frames / FPS;
    struggling_data.Properties.VariableNames{'Frames'} = 'Time';

    struggling_data = struggling_data(struggling_data.Time >= session_range(1) & struggling_data.Time <= session_range(2), :);
    
    struggle_start_idx = find(struggling_data.Struggling(1:end-1) == 0 & struggling_data.Struggling(2:end) == 100) + 1;
    struggle_end_idx = find(struggling_data.Struggling(1:end-1) == 100 & struggling_data.Struggling(2:end) == 0);

    if numel(struggle_end_idx) < numel(struggle_start_idx)
        struggle_start_idx(end) = [];
    end

    struggle_start_times = struggling_data.Time(struggle_start_idx);
    struggle_end_times = struggling_data.Time(struggle_end_idx);
    
    % Struggling onset
    signals_onset = [];
    times_onset = [];
    for i=1:numel(struggle_start_times)
        [~, curr_idx] = min(abs(signal.ts1 - struggle_start_times(i)));
        curr_signal = signal.zall(curr_idx+xlims(1)*10:curr_idx+xlims(2)*10);
        curr_time = signal.ts1(curr_idx+xlims(1)*10:curr_idx+xlims(2)*10) - signal.ts1(curr_idx);
        signals_onset = [signals_onset; curr_signal];
        times_onset = [times_onset; curr_time];
    end
    
    num_struggle{group} = [num_struggle{group}; size(signals_onset,1)];
    
    mean_signal_onset = mean(signals_onset,1);
    sem_signal_onset = std(signals_onset,[],1) / sqrt(size(signals_onset,1));
    mean_time_onset = mean(times_onset,1);

    mean_signal_onset_combined{group} = [mean_signal_onset_combined{group}; mean_signal_onset];
    sem_signal_onset_combined{group} = [sem_signal_onset_combined{group}; sem_signal_onset];
    mean_time_onset_combined{group} = [mean_time_onset_combined{group}; mean_time_onset];
    signal_onset_combined{group} = [signal_onset_combined{group}; signals_onset];

    % Struggling offset
    signals_offset = [];
    times_offset = [];
    for i=1:numel(struggle_end_times)
        [~, curr_idx] = min(abs(signal.ts1 - struggle_end_times(i)));
        curr_signal = signal.zall(curr_idx+xlims(1)*10:curr_idx+xlims(2)*10);
        curr_time = signal.ts1(curr_idx+xlims(1)*10:curr_idx+xlims(2)*10) - signal.ts1(curr_idx);
        signals_offset = [signals_offset; curr_signal];
        times_offset = [times_offset; curr_time];
    end
    
    mean_signal_offset = mean(signals_offset,1);
    sem_signal_offset = std(signals_offset,[],1) / sqrt(size(signals_offset,1));
    mean_time_offset = mean(times_offset,1);

    mean_signal_offset_combined{group} = [mean_signal_offset_combined{group}; mean_signal_offset];
    sem_signal_offset_combined{group} = [sem_signal_offset_combined{group}; sem_signal_offset];
    mean_time_offset_combined{group} = [mean_time_offset_combined{group}; mean_time_offset];

    % Classify high/low struggling
    if struggle_start_idx(1) > struggle_end_idx(1)
        struggle_end_idx(1) = [];
    end

    mean_struggle_dist = [];
    max_struggle_dist = [];
    struggle_durations = [];
    for i=1:numel(struggle_start_idx)
        curr_struggle_dist = struggling_data.Distance(struggle_start_idx(i):struggle_end_idx(i));
        mean_struggle_dist(i,:) = mean(curr_struggle_dist);
        struggle_durations(i,:) = length(curr_struggle_dist);
    end

    struggle_features = [mean_struggle_dist, struggle_durations];
    struggle_features_norm = zscore(struggle_features);
    struggle_speed = mean_struggle_dist;
    rng(1);
    k_idx = kmeans(struggle_features_norm,2);

    if mean(signals_onset(k_idx==1,:),'all') > mean(signals_onset(k_idx==2,:),'all')
        num_struggle_high{group} = [num_struggle_high{group}; size(signals_onset(k_idx==1,:),1)];
        num_struggle_low{group} = [num_struggle_low{group}; size(signals_onset(k_idx==2,:),1)];

        mean_high_struggle_onset_combined{group} = [mean_high_struggle_onset_combined{group};...
            mean(signals_onset(k_idx==1,:),1)];
        mean_low_struggle_onset_combined{group} = [mean_low_struggle_onset_combined{group};...
            mean(signals_onset(k_idx==2,:),1)];
        sem_high_struggle_onset_combined{group} = [sem_high_struggle_onset_combined{group};...
            std(signals_onset(k_idx==1,:),[],1) / sqrt(size(signals_onset(k_idx==1,:),1))];
        sem_low_struggle_onset_combined{group} = [sem_low_struggle_onset_combined{group};...
            std(signals_onset(k_idx==2,:),[],1) / sqrt(size(signals_onset(k_idx==2,:),1))];

        mean_high_struggle_offset_combined{group} = [mean_high_struggle_offset_combined{group};...
            mean(signals_offset(k_idx==1,:),1)];
        mean_low_struggle_offset_combined{group} = [mean_low_struggle_offset_combined{group};...
            mean(signals_offset(k_idx==2,:),1)];
        sem_high_struggle_offset_combined{group} = [sem_high_struggle_offset_combined{group};...
            std(signals_offset(k_idx==1,:),[],1) / sqrt(size(signals_offset(k_idx==1,:),1))];
        sem_low_struggle_offset_combined{group} = [sem_low_struggle_offset_combined{group};...
            std(signals_offset(k_idx==2,:),[],1) / sqrt(size(signals_offset(k_idx==2,:),1))];
    else
        num_struggle_high{group} = [num_struggle_high{group}; size(signals_onset(k_idx==2,:),1)];
        num_struggle_low{group} = [num_struggle_low{group}; size(signals_onset(k_idx==1,:),1)];

        mean_high_struggle_onset_combined{group} = [mean_high_struggle_onset_combined{group};...
            mean(signals_onset(k_idx==2,:),1)];
        mean_low_struggle_onset_combined{group} = [mean_low_struggle_onset_combined{group};...
            mean(signals_onset(k_idx==1,:),1)];
        sem_high_struggle_onset_combined{group} = [sem_high_struggle_onset_combined{group};...
            std(signals_onset(k_idx==2,:),[],1) / sqrt(size(signals_onset(k_idx==2,:),1))];
        sem_low_struggle_onset_combined{group} = [sem_low_struggle_onset_combined{group};...
            std(signals_onset(k_idx==1,:),[],1) / sqrt(size(signals_onset(k_idx==1,:),1))];

        mean_high_struggle_offset_combined{group} = [mean_high_struggle_offset_combined{group};...
            mean(signals_offset(k_idx==2,:),1)];
        mean_low_struggle_offset_combined{group} = [mean_low_struggle_offset_combined{group};...
            mean(signals_offset(k_idx==1,:),1)];
        sem_high_struggle_offset_combined{group} = [sem_high_struggle_offset_combined{group};...
            std(signals_offset(k_idx==2,:),[],1) / sqrt(size(signals_offset(k_idx==2,:),1))];
        sem_low_struggle_offset_combined{group} = [sem_low_struggle_offset_combined{group};...
            std(signals_offset(k_idx==1,:),[],1) / sqrt(size(signals_offset(k_idx==1,:),1))];
    end

    mean_struggle_speeds{group} = [mean_struggle_speeds{group}; mean(struggle_speed,1)];
    struggle_speeds{group} = [struggle_speeds{group}; struggle_speed];
end

%% Plot average trace at onset/offset
for group=1:numel(groupNames)
    mean_signal_onset_final{group} = mean(mean_signal_onset_combined{group},1);
    for col=1:size(sem_signal_onset_combined{group},2)
        sem_signal_onset_final(1,col) = propagate_error(sem_signal_onset_combined{group}(:,col));
    end
    mean_time_onset_final{group} = mean(mean_time_onset_combined{group},1);

    mean_signal_offset_final{group} = mean(mean_signal_offset_combined{group},1);
    for col=1:size(sem_signal_offset_combined{group},2)
        sem_signal_offset_final(1,col) = propagate_error(sem_signal_offset_combined{group}(:,col));
    end
    mean_time_offset_final{group} = mean(mean_time_offset_combined{group},1);

    mean_high_struggle_onset_final{group} = mean(mean_high_struggle_onset_combined{group},1);
    for col=1:size(sem_high_struggle_onset_combined{group},2)
        sem_high_struggle_onset_final(1,col) = propagate_error(sem_high_struggle_onset_combined{group}(:,col));
    end

    mean_low_struggle_onset_final{group} = mean(mean_low_struggle_onset_combined{group},1);
    for col=1:size(sem_low_struggle_onset_combined{group},2)
        sem_low_struggle_onset_final(1,col) = propagate_error(sem_low_struggle_onset_combined{group}(:,col));
    end

    mean_high_struggle_offset_final{group} = mean(mean_high_struggle_offset_combined{group},1);
    for col=1:size(sem_high_struggle_offset_combined{group},2)
        sem_high_struggle_offset_final(1,col) = propagate_error(sem_high_struggle_offset_combined{group}(:,col));
    end

    mean_low_struggle_offset_final{group} = mean(mean_low_struggle_offset_combined{group},1);
    for col=1:size(sem_low_struggle_offset_combined{group},2)
        sem_low_struggle_offset_final(1,col) = propagate_error(sem_low_struggle_offset_combined{group}(:,col));
    end

    figure;
    plot(mean_time_onset_final{group}, mean_signal_onset_final{group}, 'LineWidth', 2, 'Color', plot_colors{group}); hold on;
    errorplot3(mean_signal_onset_final{group}-sem_signal_onset_final, mean_signal_onset_final{group}+sem_signal_onset_final,...
        [min(mean_time_onset_final{group}), max(mean_time_onset_final{group})], plot_colors{group}, 0.3);
    xline(0,'LineStyle','--');
    onset_bCI = bootstrapping(mean_signal_onset_combined{group}, sig, consec_thresh, y); hold on;
    plot(mean_time_onset_final{group},onset_bCI,'Color',plot_colors{group},'LineWidth',2); hold on;
    title(sprintf('Struggling onset (%s)', groupNames{group}));
    xlim(xlims); ylim(ylims);

    figure;
    plot(mean_time_offset_final{group}, mean_signal_offset_final{group}, 'LineWidth', 2, 'Color', plot_colors{group}); hold on;
    errorplot3(mean_signal_offset_final{group}-sem_signal_offset_final, mean_signal_offset_final{group}+sem_signal_offset_final,...
        [min(mean_time_offset_final{group}), max(mean_time_offset_final{group})], plot_colors{group}, 0.3);
    xline(0,'LineStyle','--');
    offset_bCI = bootstrapping(mean_signal_offset_combined{group}, sig, consec_thresh, y); hold on;
    plot(mean_time_offset_final{group},offset_bCI,'Color',plot_colors{group},'LineWidth',2); hold on;
    title(sprintf('Struggling offset (%s)', groupNames{group}));
    xlim(xlims); ylim(ylims);

    figure;
    plot(mean_time_onset_final{group}, mean_high_struggle_onset_final{group}, 'LineWidth', 2, 'Color', plot_colors{group}); hold on;
    errorplot3(mean_high_struggle_onset_final{group}-sem_high_struggle_onset_final,...
        mean_high_struggle_onset_final{group}+sem_high_struggle_onset_final,...
        [min(mean_time_onset_final{group}), max(mean_time_onset_final{group})], plot_colors{group}, 0.3);
    xline(0,'LineStyle','--');
    high_onset_bCI = bootstrapping(mean_high_struggle_onset_combined{group}, sig, consec_thresh, y); hold on;
    plot(mean_time_onset_final{group},high_onset_bCI,'Color',plot_colors{group},'LineWidth',2); hold on;
    title(sprintf('High struggling onset (%s)', groupNames{group}));
    xlim(xlims); ylim(ylims);

    figure;
    plot(mean_time_onset_final{group}, mean_low_struggle_onset_final{group}, 'LineWidth', 2, 'Color', plot_colors{group}); hold on;
    errorplot3(mean_low_struggle_onset_final{group}-sem_low_struggle_onset_final,...
        mean_low_struggle_onset_final{group}+sem_low_struggle_onset_final,...
        [min(mean_time_onset_final{group}), max(mean_time_onset_final{group})], plot_colors{group}, 0.3);
    xline(0,'LineStyle','--');
    low_onset_bCI = bootstrapping(mean_low_struggle_onset_combined{group}, sig, consec_thresh, y); hold on;
    plot(mean_time_onset_final{group},low_onset_bCI,'Color',plot_colors{group},'LineWidth',2); hold on;
    title(sprintf('Low struggling onset (%s)', groupNames{group}));
    xlim(xlims); ylim(ylims);

    figure;
    plot(mean_time_offset_final{group}, mean_high_struggle_offset_final{group}, 'LineWidth', 2, 'Color', plot_colors{group}); hold on;
    errorplot3(mean_high_struggle_offset_final{group}-sem_high_struggle_offset_final,...
        mean_high_struggle_offset_final{group}+sem_high_struggle_offset_final,...
        [min(mean_time_offset_final{group}), max(mean_time_offset_final{group})], plot_colors{group}, 0.3);
    xline(0,'LineStyle','--');
    high_offset_bCI = bootstrapping(mean_high_struggle_offset_combined{group}, sig, consec_thresh, y); hold on;
    plot(mean_time_offset_final{group},high_offset_bCI,'Color',plot_colors{group},'LineWidth',2); hold on;
    title(sprintf('High struggling offset (%s)', groupNames{group}));
    xlim(xlims); ylim(ylims);

    figure;
    plot(mean_time_offset_final{group}, mean_low_struggle_offset_final{group}, 'LineWidth', 2, 'Color', plot_colors{group}); hold on;
    errorplot3(mean_low_struggle_offset_final{group}-sem_low_struggle_offset_final,...
        mean_low_struggle_offset_final{group}+sem_low_struggle_offset_final,...
        [min(mean_time_offset_final{group}), max(mean_time_offset_final{group})], plot_colors{group}, 0.3);
    xline(0,'LineStyle','--');
    low_offset_bCI = bootstrapping(mean_low_struggle_offset_combined{group}, sig, consec_thresh, y); hold on;
    plot(mean_time_offset_final{group},low_offset_bCI,'Color',plot_colors{group},'LineWidth',2); hold on;
    title(sprintf('Low struggling offset (%s)', groupNames{group}));
    xlim(xlims); ylim(ylims);
end

%% AUC
pre_onset_AUC = cell(1,numel(groupNames));
post_onset_AUC = cell(1,numel(groupNames));
post_onset_AUC_combined = cell(1,numel(groupNames));

pre_offset_AUC = cell(1,numel(groupNames));
post_offset_AUC = cell(1,numel(groupNames));

pre_high_onset_AUC = cell(1,numel(groupNames));
post_high_onset_AUC = cell(1,numel(groupNames));

pre_high_offset_AUC = cell(1,numel(groupNames));
post_high_offset_AUC = cell(1,numel(groupNames));

pre_low_onset_AUC = cell(1,numel(groupNames));
post_low_onset_AUC = cell(1,numel(groupNames));

pre_low_offset_AUC = cell(1,numel(groupNames));
post_low_offset_AUC = cell(1,numel(groupNames));

AUC_pre_duration = AUC_range_pre(2) - AUC_range_pre(1);
AUC_post_duration = AUC_range_post(2) - AUC_range_post(1);
AUC_pre_post_ratio = AUC_post_duration / AUC_pre_duration;

for group=1:numel(groupNames)
    post_idx = mean_time_onset_combined{group}(1,:) >= AUC_range_post(1) & mean_time_onset_combined{group}(1,:) < AUC_range_post(2);
    post_time = mean_time_onset_combined{group}(1,post_idx);
    post_onset_AUC_combined{group} = [post_onset_AUC_combined{group}; trapz(post_time,signal_onset_combined{group}(:,post_idx),2)];

    for i=1:size(mean_signal_onset_combined{group},1)
        pre_idx = mean_time_onset_combined{group}(i,:) >= AUC_range_pre(1) & mean_time_onset_combined{group}(i,:) < AUC_range_pre(2);
        post_idx = mean_time_onset_combined{group}(i,:) >= AUC_range_post(1) & mean_time_onset_combined{group}(i,:) < AUC_range_post(2);

        pre_time = mean_time_onset_combined{group}(i,pre_idx);
        post_time = mean_time_onset_combined{group}(i,post_idx);

        pre_onset_signal = mean_signal_onset_combined{group}(i,pre_idx);
        post_onset_signal = mean_signal_onset_combined{group}(i,post_idx);
        
        pre_onset_AUC{group} = [pre_onset_AUC{group}; trapz(pre_time, pre_onset_signal)];
        post_onset_AUC{group} = [post_onset_AUC{group}; trapz(post_time, post_onset_signal) / AUC_pre_post_ratio];
    end

    for i=1:size(mean_signal_offset_combined{group},1)
        pre_idx = mean_time_offset_combined{group}(i,:) < 0;
        post_idx = mean_time_offset_combined{group}(i,:) >= 0;

        pre_time = mean_time_offset_combined{group}(i,pre_idx);
        post_time = mean_time_offset_combined{group}(i,post_idx);

        pre_offset_signal = mean_signal_offset_combined{group}(i,pre_idx);
        post_offset_signal = mean_signal_offset_combined{group}(i,post_idx);
        
        pre_offset_AUC{group} = [pre_offset_AUC{group}; trapz(pre_time, pre_offset_signal)];
        post_offset_AUC{group} = [post_offset_AUC{group}; trapz(post_time, post_offset_signal) / AUC_pre_post_ratio];
    end

    for i=1:size(mean_high_struggle_onset_combined{group},1)
        pre_idx = mean_time_onset_combined{group}(i,:) >= AUC_range_pre(1) & mean_time_onset_combined{group}(i,:) < AUC_range_pre(2);
        post_idx = mean_time_onset_combined{group}(i,:) >= AUC_range_post(1) & mean_time_onset_combined{group}(i,:) < AUC_range_post(2);

        pre_time = mean_time_onset_combined{group}(i,pre_idx);
        post_time = mean_time_onset_combined{group}(i,post_idx);

        pre_onset_signal = mean_high_struggle_onset_combined{group}(i,pre_idx);
        post_onset_signal = mean_high_struggle_onset_combined{group}(i,post_idx);
        
        pre_high_onset_AUC{group} = [pre_high_onset_AUC{group}; trapz(pre_time, pre_onset_signal)];
        post_high_onset_AUC{group} = [post_high_onset_AUC{group}; trapz(post_time, post_onset_signal) / AUC_pre_post_ratio];
    end
    
    for i=1:size(mean_high_struggle_offset_combined{group},1)
        pre_idx = mean_time_offset_combined{group}(i,:) >= AUC_range_pre(1) & mean_time_offset_combined{group}(i,:) < AUC_range_pre(2);
        post_idx = mean_time_offset_combined{group}(i,:) >= AUC_range_post(1) & mean_time_offset_combined{group}(i,:) < AUC_range_post(2);

        pre_time = mean_time_offset_combined{group}(i,pre_idx);
        post_time = mean_time_offset_combined{group}(i,post_idx);

        pre_offset_signal = mean_high_struggle_offset_combined{group}(i,pre_idx);
        post_offset_signal = mean_high_struggle_offset_combined{group}(i,post_idx);
        
        pre_high_offset_AUC{group} = [pre_high_offset_AUC{group}; trapz(pre_time, pre_offset_signal)];
        post_high_offset_AUC{group} = [post_high_offset_AUC{group}; trapz(post_time, post_offset_signal) / AUC_pre_post_ratio];
    end

    for i=1:size(mean_low_struggle_onset_combined{group},1)
        pre_idx = mean_time_onset_combined{group}(i,:) >= AUC_range_pre(1) & mean_time_onset_combined{group}(i,:) < AUC_range_pre(2);
        post_idx = mean_time_onset_combined{group}(i,:) >= AUC_range_post(1) & mean_time_onset_combined{group}(i,:) < AUC_range_post(2);

        pre_time = mean_time_onset_combined{group}(i,pre_idx);
        post_time = mean_time_onset_combined{group}(i,post_idx);

        pre_onset_signal = mean_low_struggle_onset_combined{group}(i,pre_idx);
        post_onset_signal = mean_low_struggle_onset_combined{group}(i,post_idx);
        
        pre_low_onset_AUC{group} = [pre_low_onset_AUC{group}; trapz(pre_time, pre_onset_signal)];
        post_low_onset_AUC{group} = [post_low_onset_AUC{group}; trapz(post_time, post_onset_signal) / AUC_pre_post_ratio];
    end

    for i=1:size(mean_low_struggle_offset_combined{group},1)
        pre_idx = mean_time_offset_combined{group}(i,:) >= AUC_range_pre(1) & mean_time_offset_combined{group}(i,:) < AUC_range_pre(2);
        post_idx = mean_time_offset_combined{group}(i,:) >= AUC_range_post(1) & mean_time_offset_combined{group}(i,:) < AUC_range_post(2);

        pre_time = mean_time_offset_combined{group}(i,pre_idx);
        post_time = mean_time_offset_combined{group}(i,post_idx);

        pre_offset_signal = mean_low_struggle_offset_combined{group}(i,pre_idx);
        post_offset_signal = mean_low_struggle_offset_combined{group}(i,post_idx);
        
        pre_low_offset_AUC{group} = [pre_low_offset_AUC{group}; trapz(pre_time, pre_offset_signal)];
        post_low_offset_AUC{group} = [post_low_offset_AUC{group}; trapz(post_time, post_offset_signal) / AUC_pre_post_ratio];
    end

    curr_AUCs = [pre_onset_AUC{group}, post_onset_AUC{group}, pre_offset_AUC{group}, post_offset_AUC{group},...
        pre_high_onset_AUC{group}, post_high_onset_AUC{group}, pre_high_offset_AUC{group}, post_high_offset_AUC{group},...
        pre_low_onset_AUC{group}, post_low_onset_AUC{group}, pre_low_offset_AUC{group}, post_low_offset_AUC{group}];
    curr_AUCs_table = array2table(curr_AUCs);
    curr_AUCs_table.Properties.VariableNames = {sprintf('Onset (%d-%ds)',AUC_range_pre(1),AUC_range_pre(2)),...
        sprintf('Onset (%d-%ds)',AUC_range_post(1),AUC_range_post(2)), sprintf('Offset (%d-%ds)',AUC_range_pre(1),AUC_range_pre(2)),...
        sprintf('Offset (%d-%ds)',AUC_range_post(1),AUC_range_post(2)), sprintf('High-strgl onset (%d-%ds)', AUC_range_pre(1),AUC_range_pre(2)),...
        sprintf('High-strgl onset (%d-%ds)', AUC_range_post(1),AUC_range_post(2)), sprintf('High-strgl offset (%d-%ds)', AUC_range_pre(1),AUC_range_pre(2)),...
        sprintf('High-strgl offset (%d-%ds)', AUC_range_post(1),AUC_range_post(2)), sprintf('Low-strgl onset (%d-%ds)', AUC_range_pre(1),AUC_range_pre(2)),...
        sprintf('Low-strgl onset (%d-%ds)', AUC_range_post(1),AUC_range_post(2)), sprintf('Low-strgl offset (%d-%ds)', AUC_range_pre(1),AUC_range_pre(2)),...
        sprintf('Low-strgl offset (%d-%ds)', AUC_range_post(1),AUC_range_post(2))};
    writetable(curr_AUCs_table, AUC_output_file, 'Sheet', groupNames{group});
end

%% Latency
onset_times_to_max = cell(1,numel(groupNames));
offset_times_to_max = cell(1,numel(groupNames));

high_onset_times_to_max = cell(1,numel(groupNames));
low_onset_times_to_max = cell(1,numel(groupNames));

high_offset_times_to_max = cell(1,numel(groupNames));
low_offset_times_to_max = cell(1,numel(groupNames));

for group=1:numel(groupNames)
    onset_times_to_max{group} = [];
    offset_times_to_max{group} = [];
    high_onset_times_to_max{group} = [];
    low_onset_times_to_max{group} = [];
    high_offset_times_to_max{group} = [];
    low_offset_times_to_max{group} = [];

    onset_max_signals{group} = [];
    offset_max_signals{group} = [];
    high_onset_max_signals{group} = [];
    low_onset_max_signals{group} = [];
    high_offset_max_signals{group} = [];
    low_offset_max_signals{group} = [];

    for i=1:size(mean_time_onset_combined{group},1)
        curr_mean_time_onset = mean_time_onset_combined{group}(i,:);
        curr_mean_signal_onset = mean_signal_onset_combined{group}(i,:);
        mean_time_onset_trimmed = curr_mean_time_onset(curr_mean_time_onset >= 0);
        mean_signal_onset_trimmed = curr_mean_signal_onset(curr_mean_time_onset >= 0);
        [onset_max_signal, onset_max_idx] = max(mean_signal_onset_trimmed);
        onset_time_to_max = mean_time_onset_trimmed(onset_max_idx);
        onset_times_to_max{group} = [onset_times_to_max{group}; onset_time_to_max];
        onset_max_signals{group} = [onset_max_signals{group}; onset_max_signal];

        curr_mean_signal_onset = mean_high_struggle_onset_combined{group}(i,:);
        mean_signal_onset_trimmed = curr_mean_signal_onset(curr_mean_time_onset >= 0);
        [high_onset_max_signal, high_onset_max_idx] = max(mean_signal_onset_trimmed);
        high_onset_time_to_max = mean_time_onset_trimmed(high_onset_max_idx);
        high_onset_times_to_max{group} = [high_onset_times_to_max{group}; high_onset_time_to_max];
        high_onset_max_signals{group} = [high_onset_max_signals{group}; high_onset_max_signal];

        curr_mean_signal_onset = mean_low_struggle_onset_combined{group}(i,:);
        mean_signal_onset_trimmed = curr_mean_signal_onset(curr_mean_time_onset >= 0);
        [low_onset_max_signal, low_onset_max_idx] = max(mean_signal_onset_trimmed);
        low_onset_time_to_max = mean_time_onset_trimmed(low_onset_max_idx);
        low_onset_times_to_max{group} = [low_onset_times_to_max{group}; low_onset_time_to_max];
        low_onset_max_signals{group} = [low_onset_max_signals{group}; low_onset_max_signal];

        curr_mean_time_offset = mean_time_offset_combined{group}(i,:);
        curr_mean_signal_offset = mean_signal_offset_combined{group}(i,:);
        mean_time_offset_trimmed = curr_mean_time_offset(curr_mean_time_offset >= 0);
        mean_signal_offset_trimmed = curr_mean_signal_offset(curr_mean_time_offset >= 0);
        [offset_max_signal, offset_max_idx] = max(mean_signal_offset_trimmed);
        offset_time_to_max = mean_time_offset_trimmed(offset_max_idx);
        offset_times_to_max{group} = [offset_times_to_max{group}; offset_time_to_max];
        offset_max_signals{group} = [offset_max_signals{group}; offset_max_signal];

        curr_mean_signal_offset = mean_high_struggle_offset_combined{group}(i,:);
        mean_signal_offset_trimmed = curr_mean_signal_offset(curr_mean_time_offset >= 0);
        [high_offset_max_signal, high_offset_max_idx] = max(mean_signal_offset_trimmed);
        high_offset_time_to_max = mean_time_offset_trimmed(high_offset_max_idx);
        high_offset_times_to_max{group} = [high_offset_times_to_max{group}; high_offset_time_to_max];
        high_offset_max_signals{group} = [high_offset_max_signals{group}; high_offset_max_signal];

        curr_mean_signal_offset = mean_low_struggle_offset_combined{group}(i,:);
        mean_signal_offset_trimmed = curr_mean_signal_offset(curr_mean_time_offset >= 0);
        [low_offset_max_signal, low_offset_max_idx] = max(mean_signal_offset_trimmed);
        low_offset_time_to_max = mean_time_offset_trimmed(low_offset_max_idx);
        low_offset_times_to_max{group} = [low_offset_times_to_max{group}; low_offset_time_to_max];
        low_offset_max_signals{group} = [low_offset_max_signals{group}; low_offset_max_signal];
    end

    mean_onset_times_to_max{group} = mean(onset_times_to_max{group},1);
    sem_onset_times_to_max{group} = std(onset_times_to_max{group},[],1) / sqrt(size(onset_times_to_max{group},1));
    mean_offset_times_to_max{group} = mean(offset_times_to_max{group},1);
    sem_offset_times_to_max{group} = std(offset_times_to_max{group},[],1) / sqrt(size(offset_times_to_max{group},1));

    mean_high_onset_times_to_max{group} = mean(high_onset_times_to_max{group},1);
    sem_high_onset_times_to_max{group} = std(high_onset_times_to_max{group},[],1) / sqrt(size(high_onset_times_to_max{group},1));
    mean_low_onset_times_to_max{group} = mean(low_onset_times_to_max{group},1);
    sem_low_onset_times_to_max{group} = std(low_onset_times_to_max{group},[],1) / sqrt(size(low_onset_times_to_max{group},1));

    mean_high_offset_times_to_max{group} = mean(high_offset_times_to_max{group},1);
    sem_high_offset_times_to_max{group} = std(high_offset_times_to_max{group},[],1) / sqrt(size(high_offset_times_to_max{group},1));
    mean_low_offset_times_to_max{group} = mean(low_offset_times_to_max{group},1);
    sem_low_offset_times_to_max{group} = std(low_offset_times_to_max{group},[],1) / sqrt(size(low_offset_times_to_max{group},1));
end

header = {"Onset", "Offset","High-strgl onset","High-strgl offset","Low-strgl onset","Low-strgl offset"};
for group=1:numel(groupNames)
    latency_combined = [onset_times_to_max{group}, offset_times_to_max{group},...
        high_onset_times_to_max{group}, high_offset_times_to_max{group},...
        low_onset_times_to_max{group}, low_offset_times_to_max{group}];
    writecell(header, latency_output_file, 'Sheet', groupNames{group}, 'Range', 'A1');
    writematrix(latency_combined, latency_output_file, 'Sheet', groupNames{group}, 'Range', 'A2');
end

for group=1:numel(groupNames)
    ampl_combined = [onset_max_signals{group}, offset_max_signals{group},...
        high_onset_max_signals{group}, high_offset_max_signals{group},...
        low_onset_max_signals{group}, low_offset_max_signals{group}];
    writecell(header, ampl_output_file, 'Sheet', groupNames{group}, 'Range', 'A1');
    writematrix(ampl_combined, ampl_output_file, 'Sheet', groupNames{group}, 'Range', 'A2');
end

X = categorical({'Struggling onset', 'Struggling offset', 'High struggling onset', 'High struggling offset',...
    'Low struggling onset', 'Low struggling offset'});
X = reordercats(X,{'Struggling onset', 'Struggling offset', 'High struggling onset', 'High struggling offset',...
    'Low struggling onset', 'Low struggling offset'});
Y = [cell2mat(mean_onset_times_to_max); cell2mat(mean_offset_times_to_max);...
    cell2mat(mean_high_onset_times_to_max); cell2mat(mean_high_offset_times_to_max);
    cell2mat(mean_low_onset_times_to_max); cell2mat(mean_low_offset_times_to_max)];
figure;
h = bar(X, Y); hold on;
errorbar(h(1).XEndPoints,[mean_onset_times_to_max{1}, mean_offset_times_to_max{1}...
    mean_high_onset_times_to_max{1}, mean_high_offset_times_to_max{1}...
    mean_low_onset_times_to_max{1}, mean_low_offset_times_to_max{1}],...
    [sem_onset_times_to_max{1}, sem_offset_times_to_max{1}...
    sem_high_onset_times_to_max{1}, sem_high_offset_times_to_max{1}...
    sem_low_onset_times_to_max{1}, sem_low_offset_times_to_max{1}],'LineStyle','none','Color','k','LineWidth',2);
errorbar(h(2).XEndPoints,[mean_onset_times_to_max{2}, mean_offset_times_to_max{2}...
    mean_high_onset_times_to_max{2}, mean_high_offset_times_to_max{2}...
    mean_low_onset_times_to_max{2}, mean_low_offset_times_to_max{2}],...
    [sem_onset_times_to_max{2}, sem_offset_times_to_max{2}...
    sem_high_onset_times_to_max{2}, sem_high_offset_times_to_max{2}...
    sem_low_onset_times_to_max{2}, sem_low_offset_times_to_max{2}],'LineStyle','none','Color','k','LineWidth',2);
scatter(repmat(h(1).XEndPoints(1), size(onset_times_to_max{1},1), 1),onset_times_to_max{1},60,'MarkerFaceColor',[0 0.4470 0.7410],'MarkerEdgeColor','k','LineWidth',1);
scatter(repmat(h(1).XEndPoints(2), size(offset_times_to_max{1},1), 1),offset_times_to_max{1},60,'MarkerFaceColor',[0 0.4470 0.7410],'MarkerEdgeColor','k','LineWidth',1);
scatter(repmat(h(1).XEndPoints(3), size(high_onset_times_to_max{1},1), 1),high_onset_times_to_max{1},60,'MarkerFaceColor',[0 0.4470 0.7410],'MarkerEdgeColor','k','LineWidth',1);
scatter(repmat(h(1).XEndPoints(4), size(high_offset_times_to_max{1},1), 1),high_offset_times_to_max{1},60,'MarkerFaceColor',[0 0.4470 0.7410],'MarkerEdgeColor','k','LineWidth',1);
scatter(repmat(h(1).XEndPoints(5), size(low_onset_times_to_max{1},1), 1),low_onset_times_to_max{1},60,'MarkerFaceColor',[0 0.4470 0.7410],'MarkerEdgeColor','k','LineWidth',1);
scatter(repmat(h(1).XEndPoints(6), size(low_offset_times_to_max{1},1), 1),low_offset_times_to_max{1},60,'MarkerFaceColor',[0 0.4470 0.7410],'MarkerEdgeColor','k','LineWidth',1);

scatter(repmat(h(2).XEndPoints(1), size(onset_times_to_max{2},1), 1),onset_times_to_max{2},60,'MarkerFaceColor',[0.8500 0.3250 0.0980],'MarkerEdgeColor','k','LineWidth',1);
scatter(repmat(h(2).XEndPoints(2), size(offset_times_to_max{2},1), 1),offset_times_to_max{2},60,'MarkerFaceColor',[0.8500 0.3250 0.0980],'MarkerEdgeColor','k','LineWidth',1);
scatter(repmat(h(2).XEndPoints(3), size(high_onset_times_to_max{2},1), 1),high_onset_times_to_max{2},60,'MarkerFaceColor',[0.8500 0.3250 0.0980],'MarkerEdgeColor','k','LineWidth',1);
scatter(repmat(h(2).XEndPoints(4), size(high_offset_times_to_max{2},1), 1),high_offset_times_to_max{2},60,'MarkerFaceColor',[0.8500 0.3250 0.0980],'MarkerEdgeColor','k','LineWidth',1);
scatter(repmat(h(2).XEndPoints(5), size(low_onset_times_to_max{2},1), 1),low_onset_times_to_max{2},60,'MarkerFaceColor',[0.8500 0.3250 0.0980],'MarkerEdgeColor','k','LineWidth',1);
scatter(repmat(h(2).XEndPoints(6), size(low_offset_times_to_max{2},1), 1),low_offset_times_to_max{2},60,'MarkerFaceColor',[0.8500 0.3250 0.0980],'MarkerEdgeColor','k','LineWidth',1);

legend(groupNames);
title('Time to max');

%% Num events

header = {'All', 'High', 'Low'};
for group=1:numel(groupNames)
    curr_num_events = [num_struggle{group}, num_struggle_high{group}, num_struggle_low{group}];
    writecell(header,num_events_output_file,'Range','A1','Sheet',groupNames{group});
    writematrix(curr_num_events,num_events_output_file,'Range','A2','Sheet',groupNames{group});
end

%% Correlation between struggle intensity and struggle-related Ca2+ transient size
figure;
for group=1:numel(groupNames)
    scatter(struggle_speeds{group},post_onset_AUC_combined{group},100,'MarkerEdgeColor',plot_colors{group},...
        'MarkerFaceColor',plot_colors{group}); hold on;    
    p = polyfit(struggle_speeds{group},post_onset_AUC_combined{group},1);
    y_fit = polyval(p,struggle_speeds{group});
    plot(struggle_speeds{group},y_fit,'Color',plot_colors{group},'LineWidth',1.5,'LineStyle',':');

    [r_value,p_value] = corr(struggle_speeds{group},post_onset_AUC_combined{group},'Type','Pearson');
    x_text = mean(struggle_speeds{group});
    y_text = polyval(p,x_text)+0.4;
    text(x_text,y_text,sprintf('r = %.2f, p = %.3f',r_value,p_value),'FontSize',12,'HorizontalAlignment','right');

    xlabel('Struggling speed');
    ylabel('AUC');
    title('Struggling intensity vs. struggle onset Ca2+ transient size')
end