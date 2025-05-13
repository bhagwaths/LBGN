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

photometry_files = {'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day8\AS_vHIP_BLA_1-240823-075000';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day8\AS_vHIP_BLA_3-240823-102953';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day8\AS_vHIP_BLA_4-241209-111830';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day8\AS_vHIP_BLA_5-240823-130739';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day8\AS_vHIP_BLA_6-241209-135710';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day8\AS_vHIP_BLA_7-240823-155901';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day8\AS_vHIP_BLA_8-241209-164755';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day8\AS_vHIP_BLA_1-240823-075000';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day8\AS_vHIP_BLA_2-241209-083901';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day8\AS_vHIP_BLA_4-241209-111830';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day8\AS_vHIP_BLA_5-240823-130739';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day8\AS_vHIP_BLA_6-241209-135710';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day8\AS_vHIP_BLA_7-240823-155901';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day8\AS_vHIP_BLA_8-241209-164755'};

struggling_files = {'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day8\AS-vHIP-BLA-1_Day8_DLC_struggling.csv';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day8\AS-vHIP-BLA-3_Day8_DLC_struggling.csv';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day8\AS-vHIP-BLA-4_Day8_DLC_struggling.csv';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day8\AS-vHIP-BLA-5_Day8_DLC_struggling.csv';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day8\AS-vHIP-BLA-6_Day8_DLC_struggling.csv';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day8\AS-vHIP-BLA-7_Day8_DLC_struggling.csv';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day8\AS-vHIP-BLA-8_Day8_DLC_struggling.csv';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day8\AS-vHIP-BLA-1_Day8_DLC_struggling.csv';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day8\AS-vHIP-BLA-2_Day8_DLC_struggling.csv';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day8\AS-vHIP-BLA-4_Day8_DLC_struggling.csv';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day8\AS-vHIP-BLA-5_Day8_DLC_struggling.csv';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day8\AS-vHIP-BLA-6_Day8_DLC_struggling.csv';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day8\AS-vHIP-BLA-7_Day8_DLC_struggling.csv';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day8\AS-vHIP-BLA-8_Day8_DLC_struggling.csv'};

session_range = [0 7200]; % time range for struggling labels

TRANGES = {[-1794 8952]; % 1
[-1292 8726]; % 3
[-1417 8747]; % 4
[-2095 9354]; % 5
[-1597 9322]; % 6
[-1407 8979]; % 7
[-1583 8984]; % 8
[-1794 8952]; % 1
[-1770 8943]; % 2
[-1417 8747]; % 4
[-2095 9354]; % 5
[-1597 9322]; % 6
[-1407 8979]; % 7
[-1583 8984]}; % 8

BASELINE_PERS = {[-1794 -487]; % 1
[-1292 -88]; % 3
[-1417 -86]; % 4
[-2095 -670]; % 5
[-1597 -70]; % 6
[-1407 -158]; % 7
[-1583 -135]; % 8
[-1794 -487]; % 1
[-1770 -248]; % 2
[-1417 -86]; % 4
[-2095 -670]; % 5
[-1597 -70]; % 6
[-1407 -158]; % 7
[-1583 -135]}; % 8

onset_times = {1794; % 1
1292; % 3
1417; % 4
2095; % 5
1597; % 6
1407; % 7
1583; % 8
1794; % 1
1770; % 2
1417; % 4
2095; % 5
1597; % 6
1407; % 7
1583}; % 8

FPS = 9.96;

%%

sig = .05;
consec_thresh = 14;
y = 5.4;

xlims = [-5 30];
ylims = [-.5 5.5];

AUC_range_pre = [-5 0]; % time range for AUC calculation (pre)
AUC_range_post = [0 15]; % time range for AUC calculation (post)

AUC_output_file = 'AS-vHIP-BLA_Day8_AUC_total.xlsx';
latency_output_file = 'AS-vHIP-BLA_Day8_latency_total.xlsx';

%%

mean_signal_onset_combined = cell(1,numel(groupNames));
sem_signal_onset_combined = cell(1,numel(groupNames));
mean_time_onset_combined = cell(1,numel(groupNames));

mean_signal_offset_combined = cell(1,numel(groupNames));
sem_signal_offset_combined = cell(1,numel(groupNames));
mean_time_offset_combined = cell(1,numel(groupNames));

for group=1:numel(groupNames)
    mean_signal_onset_combined{group} = [];
    sem_signal_onset_combined{group} = [];
    mean_time_onset_combined{group} = [];

    mean_signal_offset_combined{group} = [];
    sem_signal_offset_combined{group} = [];
    mean_time_offset_combined{group} = [];
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
        if 
        [~, curr_idx] = min(abs(signal.ts1 - struggle_start_times(i)));
        curr_signal = signal.zall(curr_idx+xlims(1)*10:curr_idx+xlims(2)*10);
        curr_time = signal.ts1(curr_idx+xlims(1)*10:curr_idx+xlims(2)*10) - signal.ts1(curr_idx);
        signals_onset = [signals_onset; curr_signal];
        times_onset = [times_onset; curr_time];
    end
    
    mean_signal_onset = mean(signals_onset,1);
    sem_signal_onset = std(signals_onset,[],1) / sqrt(size(signals_onset,1));
    mean_time_onset = mean(times_onset,1);

    mean_signal_onset_combined{group} = [mean_signal_onset_combined{group}; mean_signal_onset];
    sem_signal_onset_combined{group} = [sem_signal_onset_combined{group}; sem_signal_onset];
    mean_time_onset_combined{group} = [mean_time_onset_combined{group}; mean_time_onset];

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
end

%% AUC
pre_onset_AUC = cell(1,numel(groupNames));
post_onset_AUC = cell(1,numel(groupNames));

pre_offset_AUC = cell(1,numel(groupNames));
post_offset_AUC = cell(1,numel(groupNames));

AUC_pre_duration = AUC_range_pre(2) - AUC_range_pre(1);
AUC_post_duration = AUC_range_post(2) - AUC_range_post(1);
AUC_pre_post_ratio = AUC_post_duration / AUC_pre_duration;

for group=1:numel(groupNames)
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

    curr_AUCs = [pre_onset_AUC{group}, post_onset_AUC{group}, pre_offset_AUC{group}, post_offset_AUC{group}];
    curr_AUCs_table = array2table(curr_AUCs);
    curr_AUCs_table.Properties.VariableNames = {sprintf('Onset (%d-%ds)',AUC_range_pre(1),AUC_range_pre(2)),...
        sprintf('Onset (%d-%ds)',AUC_range_post(1),AUC_range_post(2)), sprintf('Offset (%d-%ds)',AUC_range_pre(1),AUC_range_pre(2)),...
        sprintf('Offset (%d-%ds)',AUC_range_post(1),AUC_range_post(2))};
    writetable(curr_AUCs_table, AUC_output_file, 'Sheet', groupNames{group});
end

%% Latency
onset_times_to_max = cell(1,numel(groupNames));
offset_times_to_max = cell(1,numel(groupNames));

for group=1:numel(groupNames)
    onset_times_to_max{group} = [];
    offset_times_to_max{group} = [];
    for i=1:size(mean_time_onset_combined{group},1)
        curr_mean_time_onset = mean_time_onset_combined{group}(i,:);
        curr_mean_signal_onset = mean_signal_onset_combined{group}(i,:);
        mean_time_onset_trimmed = curr_mean_time_onset(curr_mean_time_onset >= 0);
        mean_signal_onset_trimmed = curr_mean_signal_onset(curr_mean_time_onset >= 0);
        [~, onset_max_idx] = max(mean_signal_onset_trimmed);
        onset_time_to_max = mean_time_onset_trimmed(onset_max_idx);
        onset_times_to_max{group} = [onset_times_to_max{group}; onset_time_to_max];

        curr_mean_time_offset = mean_time_offset_combined{group}(i,:);
        curr_mean_signal_offset = mean_signal_offset_combined{group}(i,:);
        mean_time_offset_trimmed = curr_mean_time_offset(curr_mean_time_offset >= 0);
        mean_signal_offset_trimmed = curr_mean_signal_offset(curr_mean_time_offset >= 0);
        [~, offset_max_idx] = max(mean_signal_offset_trimmed);
        offset_time_to_max = mean_time_offset_trimmed(offset_max_idx);
        offset_times_to_max{group} = [offset_times_to_max{group}; offset_time_to_max];
    end

    mean_onset_times_to_max{group} = mean(onset_times_to_max{group},1);
    sem_onset_times_to_max{group} = std(onset_times_to_max{group},[],1) / sqrt(size(onset_times_to_max{group},1));
    mean_offset_times_to_max{group} = mean(offset_times_to_max{group},1);
    sem_offset_times_to_max{group} = std(offset_times_to_max{group},[],1) / sqrt(size(offset_times_to_max{group},1));
end

header = {"Onset", "Offset"};
for group=1:numel(groupNames)
    latency_combined = [onset_times_to_max{group}, offset_times_to_max{group}];
    writecell(header, latency_output_file, 'Sheet', groupNames{group}, 'Range', 'A1');
    writematrix(latency_combined, latency_output_file, 'Sheet', groupNames{group}, 'Range', 'A2');
end

X = categorical({'Struggling onset', 'Struggling offset'});
X = reordercats(X,{'Struggling onset', 'Struggling offset'});
Y = [cell2mat(mean_onset_times_to_max); cell2mat(mean_offset_times_to_max)];
figure;
h = bar(X, Y); hold on;
errorbar(h(1).XEndPoints,[mean_onset_times_to_max{1}, mean_offset_times_to_max{1}],[sem_onset_times_to_max{1}, sem_offset_times_to_max{1}],'LineStyle','none','Color','k','LineWidth',2);
errorbar(h(2).XEndPoints,[mean_onset_times_to_max{2}, mean_offset_times_to_max{2}],[sem_onset_times_to_max{2}, sem_offset_times_to_max{2}],'LineStyle','none','Color','k','LineWidth',2);
scatter(repmat(h(1).XEndPoints(1), size(onset_times_to_max{1},1), 1),onset_times_to_max{1},60,'MarkerFaceColor',[0 0.4470 0.7410],'MarkerEdgeColor','k','LineWidth',1)
scatter(repmat(h(1).XEndPoints(2), size(offset_times_to_max{1},1), 1),offset_times_to_max{1},60,'MarkerFaceColor',[0 0.4470 0.7410],'MarkerEdgeColor','k','LineWidth',1)
scatter(repmat(h(2).XEndPoints(1), size(onset_times_to_max{2},1), 1),onset_times_to_max{2},60,'MarkerFaceColor',[0.8500 0.3250 0.0980],'MarkerEdgeColor','k','LineWidth',1)
scatter(repmat(h(2).XEndPoints(2), size(offset_times_to_max{2},1), 1),offset_times_to_max{2},60,'MarkerFaceColor',[0.8500 0.3250 0.0980],'MarkerEdgeColor','k','LineWidth',1)

legend(groupNames);
title('Time to max');