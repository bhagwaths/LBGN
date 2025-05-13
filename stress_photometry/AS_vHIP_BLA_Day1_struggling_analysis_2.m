day = 1;

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

groupNames = {'BLA', 'vHIP'};
groups = {'BLA'; 'BLA'; 'BLA'; 'BLA'; 'BLA'; 'BLA'; 'BLA'; 'vHIP'; 'vHIP'; 'vHIP'; 'vHIP'; 'vHIP'; 'vHIP'; 'vHIP'};
whichStreams = [12; 12; 12; 12; 12; 12; 12; 34; 34; 34; 34; 34; 34; 34];
onOff = 2; % onset=1, offset=2

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


struggling_files = {'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day1\AS-vHIP-BLA-1_Day1_DLC_struggling.csv';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day1\AS-vHIP-BLA-3_Day1_DLC_struggling.csv';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day1\AS-vHIP-BLA-4_Day1_DLC_struggling.csv';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day1\AS-vHIP-BLA-5_Day1_DLC_struggling.csv';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day1\AS-vHIP-BLA-6_Day1_DLC_struggling.csv';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day1\AS-vHIP-BLA-7_Day1_DLC_struggling.csv';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day1\AS-vHIP-BLA-8_Day1_DLC_struggling.csv';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day1\AS-vHIP-BLA-1_Day1_DLC_struggling.csv';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day1\AS-vHIP-BLA-2_Day1_DLC_struggling.csv';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day1\AS-vHIP-BLA-4_Day1_DLC_struggling.csv';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day1\AS-vHIP-BLA-5_Day1_DLC_struggling.csv';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day1\AS-vHIP-BLA-6_Day1_DLC_struggling.csv';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day1\AS-vHIP-BLA-7_Day1_DLC_struggling.csv';
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\struggling data\by day\Day1\AS-vHIP-BLA-8_Day1_DLC_struggling.csv'};

session_range = [0 7200]; % time range for struggling labels
TRANGE = [-5 35]; % window size [start time relative to epoc onset, window duration]
BASELINE_PER = [-5 0]; % baseline period within our window

AUC_range_pre = [-5 0]; % time range for AUC calculation (pre)
AUC_range_post = [0 30]; % time range for AUC calculation (post)

xlims = [-5 30]; % x-axis range on plot
ylims = [-.2 8]; % y-axis range on plot
plot_colors = {[0.04 .03 0.3]; [0.2 0.3 0.1]};

sig = .05;
consec_thresh = 14;
y = 7.8;

%%

mean_signal_combined = cell(1,numel(groupNames));
sem_signal_combined = cell(1,numel(groupNames));
mean_time_combined = cell(1,numel(groupNames));
mouse_names_grouped = cell(1,numel(groupNames));

for group=1:numel(groupNames)
    mean_signal_combined{group} = [];
    sem_signal_combined{group} = [];
    mean_time_combined{group} = [];
    mouse_names_grouped{group} = [];
end

num_events = cell(1,numel(groupNames));

for mouse=1:numel(mouse_names)
    group = find(strcmp(groups{mouse},groupNames));
    mouse_names_grouped{group} = [mouse_names_grouped{group}; mouse_names{mouse}];

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

    num_events{group} = [num_events{group}; numel(struggle_start_times)];

    [signals, times] = struggling_FN(struggle_start_times,struggle_end_times,photometry_files{mouse},whichStreams(mouse),onOff,TRANGE,BASELINE_PER);
    mean_signal = mean(signals,1);
    sem_signal = std(signals,[],1) / sqrt(size(signals,1));
    mean_time = mean(times,1);

    mean_signal_combined{group} = [mean_signal_combined{group}; mean_signal];
    sem_signal_combined{group} = [sem_signal_combined{group}; sem_signal];
    mean_time_combined{group} = [mean_time_combined{group}; mean_time];
end

%% Plot average trace at onset/offset
for group=1:numel(groupNames)
    mean_signal_final{group} = mean(mean_signal_combined{group},1);
    for col=1:size(sem_signal_combined{group},2)
        sem_signal_final(1,col) = propagate_error(sem_signal_combined{group}(:,col));
    end
    mean_time_final{group} = mean(mean_time_combined{group},1);

    figure;
    plot(mean_time_final{group}, mean_signal_final{group}, 'LineWidth', 2, 'Color', plot_colors{group}); hold on;
    errorplot3(mean_signal_final{group}-sem_signal_final, mean_signal_final{group}+sem_signal_final,...
        [min(mean_time_final{group}), max(mean_time_final{group})], plot_colors{group}, 0.3);
    xline(0,'LineStyle','--');
    bCI = bootstrapping(mean_signal_combined{group}, sig, consec_thresh, y); hold on;
    plot(mean_time_final{group},bCI,'Color',plot_colors{group},'LineWidth',2); hold on;
    if onOff==1
        title(sprintf('Struggling onset (%s)', groupNames{group}));
    elseif onOff==2
        title(sprintf('Struggling offset (%s)', groupNames{group}));
    end
    xlim(xlims); ylim(ylims);
end

%% Num events
for group=1:numel(groupNames)
    mean_num_events{group} = mean(num_events{group},1);
    sem_num_events{group} = std(num_events{group},[],1) / sqrt(size(num_events{group},1));
end

X = categorical({'Struggling events'});
X = reordercats(X,{'Struggling events'});
Y = cell2mat(mean_num_events);
figure;
h = bar(X, Y); hold on;
errorbar(h(1).XEndPoints,mean_num_events{1},sem_num_events{1},'LineStyle','none','Color','k','LineWidth',2);
errorbar(h(2).XEndPoints,mean_num_events{2},sem_num_events{2},'LineStyle','none','Color','k','LineWidth',2);
scatter(repmat(h(1).XEndPoints(1), size(num_events{1},1), 1),num_events{1},60,'MarkerFaceColor',[0 0.4470 0.7410],'MarkerEdgeColor','k','LineWidth',1)
scatter(repmat(h(2).XEndPoints(1), size(num_events{2},1), 1),num_events{2},60,'MarkerFaceColor',[0.8500 0.3250 0.0980],'MarkerEdgeColor','k','LineWidth',1)

legend(groupNames);
title('Number of events');

%% AUC
pre_AUC = cell(1,numel(groupNames));
post_AUC = cell(1,numel(groupNames));

for group=1:numel(groupNames)
    for i=1:size(mean_signal_combined{group},1)
        pre_idx = mean_time_combined{group}(i,:) >= AUC_range_pre(1) & mean_time_combined{group}(i,:) < AUC_range_pre(2);
        post_idx = mean_time_combined{group}(i,:) >= AUC_range_post(1) & mean_time_combined{group}(i,:) < AUC_range_post(2);

        pre_time = mean_time_combined{group}(i,pre_idx);
        post_time = mean_time_combined{group}(i,post_idx);

        pre_signal = mean_signal_combined{group}(i,pre_idx);
        post_signal = mean_signal_combined{group}(i,post_idx);
        
        pre_AUC{group} = [pre_AUC{group}; trapz(pre_time, pre_signal)];
        post_AUC{group} = [post_AUC{group}; trapz(post_time, post_signal) / 6];
    end
end

for group=1:numel(groupNames)
    mean_pre_AUC{group} = mean(pre_AUC{group},1);
    sem_pre_AUC{group} = std(pre_AUC{group},[],1) / sqrt(size(pre_AUC{group},1));

    mean_post_AUC{group} = mean(post_AUC{group},1);
    sem_post_AUC{group} = std(post_AUC{group},[],1) / sqrt(size(post_AUC{group},1));
end

X = categorical({sprintf('AUC (%d-%ds)', AUC_range_pre(1), AUC_range_pre(2)),...
    sprintf('AUC (%d-%ds)', AUC_range_post(1), AUC_range_post(2))});
X = reordercats(X,{sprintf('AUC (%d-%ds)', AUC_range_pre(1), AUC_range_pre(2)),...
    sprintf('AUC (%d-%ds)', AUC_range_post(1), AUC_range_post(2))});
Y = [cell2mat(mean_pre_AUC); cell2mat(mean_post_AUC)];
figure;
h = bar(X, Y); hold on;
errorbar(h(1).XEndPoints,[mean_pre_AUC{1}, mean_post_AUC{1}],[sem_pre_AUC{1}, sem_post_AUC{1}],'LineStyle','none','Color','k','LineWidth',2);
errorbar(h(2).XEndPoints,[mean_pre_AUC{2}, mean_post_AUC{2}],[sem_pre_AUC{2}, sem_post_AUC{2}],'LineStyle','none','Color','k','LineWidth',2);
scatter(repmat(h(1).XEndPoints(1), size(pre_AUC{1},1), 1),pre_AUC{1},60,'MarkerFaceColor',[0 0.4470 0.7410],'MarkerEdgeColor','k','LineWidth',1)
scatter(repmat(h(1).XEndPoints(2), size(post_AUC{1},1), 1),post_AUC{1},60,'MarkerFaceColor',[0 0.4470 0.7410],'MarkerEdgeColor','k','LineWidth',1)
scatter(repmat(h(2).XEndPoints(1), size(pre_AUC{2},1), 1),pre_AUC{2},60,'MarkerFaceColor',[0.8500 0.3250 0.0980],'MarkerEdgeColor','k','LineWidth',1)
scatter(repmat(h(2).XEndPoints(2), size(post_AUC{2},1), 1),post_AUC{2},60,'MarkerFaceColor',[0.8500 0.3250 0.0980],'MarkerEdgeColor','k','LineWidth',1)

legend(groupNames);
title('AUC');

%% Latency
times_to_max = cell(1,numel(groupNames));

for group=1:numel(groupNames)
    times_to_max{group} = [];
    for i=1:size(mean_time_combined{group},1)
        curr_mean_time = mean_time_combined{group}(i,:);
        curr_mean_signal = mean_signal_combined{group}(i,:);
        mean_time_trimmed = curr_mean_time(curr_mean_time >= 0);
        mean_signal_trimmed = curr_mean_signal(curr_mean_time >= 0);
        [~, max_idx] = max(mean_signal_trimmed);
        time_to_max = mean_time_trimmed(max_idx);
        times_to_max{group} = [times_to_max{group}; time_to_max];
    end

    mean_times_to_max{group} = mean(times_to_max{group},1);
    sem_times_to_max{group} = std(times_to_max{group},[],1) / sqrt(size(times_to_max{group},1));
end

X = categorical({'Struggling onset'});
X = reordercats(X,{'Struggling onset'});
Y = cell2mat(mean_times_to_max);
figure;
h = bar(X, Y); hold on;
errorbar(h(1).XEndPoints,mean_times_to_max{1},sem_times_to_max{1},'LineStyle','none','Color','k','LineWidth',2);
errorbar(h(2).XEndPoints,mean_times_to_max{2},sem_times_to_max{2},'LineStyle','none','Color','k','LineWidth',2);
scatter(repmat(h(1).XEndPoints(1), size(times_to_max{1},1), 1),times_to_max{1},60,'MarkerFaceColor',[0 0.4470 0.7410],'MarkerEdgeColor','k','LineWidth',1)
scatter(repmat(h(2).XEndPoints(1), size(times_to_max{2},1), 1),times_to_max{2},60,'MarkerFaceColor',[0.8500 0.3250 0.0980],'MarkerEdgeColor','k','LineWidth',1)

legend(groupNames);
title('Latency');

%% Write to Excel
if onOff==1
    output_path = sprintf('AS-vHIP-BLA_Day%d_onset.xlsx', day);
elseif onOff==2
    output_path = sprintf('AS-vHIP-BLA_Day%d_offset.xlsx', day);
end

for group=1:numel(groupNames)
    AUC_header_pre = sprintf('AUC (%d-%ds), onset', AUC_range_pre(1), AUC_range_pre(2));
    AUC_header_post = sprintf('AUC (%d-%ds), onset', AUC_range_post(1), AUC_range_post(2));

    curr_table=table(mouse_names_grouped{group},num_events{group},pre_AUC{group},post_AUC{group},times_to_max{group});
    curr_headers={'Name','Num events',AUC_header_pre, AUC_header_post,'Latency, onset'};
    curr_table.Properties.VariableNames=curr_headers;
    writetable(curr_table,output_path,'Range','A1','Sheet',groupNames{group});
end