stage = "retrieval";

animalNames = {'hSyn-1';
           'hSyn-2';
           'hSyn-3';
           'hSyn-4';
           'hSyn-5';
           'hSyn-6';
           'hSyn-7';
           'hSyn-8';
           'AS-1';
           'AS-3';
           'AS-4';
           'AS-5';
           'AS-7'};

plot_colors = {[0 0.4470 0.7410]; [0.8500 0.3250 0.0980]};
perm_test_color = [0.4660 0.6740 0.1880];

groupNames = {'hSyn'; 'AS'};
groups = {'hSyn'; 'hSyn'; 'hSyn'; 'hSyn'; 'hSyn'; 'hSyn'; 'hSyn'; 'hSyn'; 'AS'; 'AS'; 'AS'; 'AS'; 'AS'};

photometry_files = {'C:\Users\bhagwaths\Documents\AS-hSyn\2retrieval\2AS_hSyn_1-240329-094256';
'C:\Users\bhagwaths\Documents\AS-hSyn\2retrieval\2AS_hSyn_2-240711-124532';
'C:\Users\bhagwaths\Documents\AS-hSyn\2retrieval\2AS_hSyn_3-240329-101303';
'C:\Users\bhagwaths\Documents\AS-hSyn\2retrieval\2AS_hSyn_4-240711-131550';
'C:\Users\bhagwaths\Documents\AS-hSyn\2retrieval\2AS_hSyn_5-240329-104316';
'C:\Users\bhagwaths\Documents\AS-hSyn\2retrieval\2AS_hSyn_6-240711-134550';
'C:\Users\bhagwaths\Documents\AS-hSyn\2retrieval\2AS_hSyn_7-240329-111513';
'C:\Users\bhagwaths\Documents\AS-hSyn\2retrieval\2AS_hSyn_8-240711-141749';
'C:\Users\bhagwaths\Documents\AS-hSyn\2retrieval\2AS_hSyn_1-240329-094256';
'C:\Users\bhagwaths\Documents\AS-hSyn\2retrieval\2AS_hSyn_3-240329-101303';
'C:\Users\bhagwaths\Documents\AS-hSyn\2retrieval\2AS_hSyn_4-240711-131550';
'C:\Users\bhagwaths\Documents\AS-hSyn\2retrieval\2AS_hSyn_5-240329-104316';
'C:\Users\bhagwaths\Documents\AS-hSyn\2retrieval\2AS_hSyn_7-240329-111513'};

freezing_files = {'C:\Users\bhagwaths\Documents\AS-hSyn\2retrieval\FreezingOutput_processed\2.AS-hSyn-1_FreezingOutput_processed.csv';
'C:\Users\bhagwaths\Documents\AS-hSyn\2retrieval\FreezingOutput_processed\2.AS-hSyn-2_FreezingOutput_processed.csv';
'C:\Users\bhagwaths\Documents\AS-hSyn\2retrieval\FreezingOutput_processed\2.AS-hSyn-3_FreezingOutput_processed.csv';
'C:\Users\bhagwaths\Documents\AS-hSyn\2retrieval\FreezingOutput_processed\2.AS-hSyn-4_FreezingOutput_processed.csv';
'C:\Users\bhagwaths\Documents\AS-hSyn\2retrieval\FreezingOutput_processed\2.AS-hSyn-5_FreezingOutput_processed.csv';
'C:\Users\bhagwaths\Documents\AS-hSyn\2retrieval\FreezingOutput_processed\2.AS-hSyn-6_FreezingOutput_processed.csv';
'C:\Users\bhagwaths\Documents\AS-hSyn\2retrieval\FreezingOutput_processed\2.AS-hSyn-7_FreezingOutput_processed.csv';
'C:\Users\bhagwaths\Documents\AS-hSyn\2retrieval\FreezingOutput_processed\2.AS-hSyn-8_FreezingOutput_processed.csv';
'C:\Users\bhagwaths\Documents\AS-hSyn\2retrieval\FreezingOutput_processed\2.AS-hSyn-1_FreezingOutput_processed.csv';
'C:\Users\bhagwaths\Documents\AS-hSyn\2retrieval\FreezingOutput_processed\2.AS-hSyn-3_FreezingOutput_processed.csv';
'C:\Users\bhagwaths\Documents\AS-hSyn\2retrieval\FreezingOutput_processed\2.AS-hSyn-4_FreezingOutput_processed.csv';
'C:\Users\bhagwaths\Documents\AS-hSyn\2retrieval\FreezingOutput_processed\2.AS-hSyn-5_FreezingOutput_processed.csv';
'C:\Users\bhagwaths\Documents\AS-hSyn\2retrieval\FreezingOutput_processed\2.AS-hSyn-7_FreezingOutput_processed.csv'};

TRANGE = [-180 630];
BASELINE_PER = [-180 -1];

CS_onset_times = [0, 90, 180, 270, 360];
TTLonOff = [1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1];

STREAM_STORE1 = {'ax05A'; 'ax05B'};
STREAM_STORE2 = {'ax60A'; 'ax70B'};
STREAM_STORE3 = 'aFi1r';

EPOC = 'Session';
N = 100;
ARTIFACT = inf;

FPS = 30;
freeze_threshold = 30;
move_threshold = 30;

sig = .05;
consec_thresh = 3.3;

AUC_output_file = 'AS-hSyn_retrieval_AUC.xlsx';
latency_output_file = 'AS-hSyn_retrieval_latency.xlsx';

%

mean_CS_onset_signals_combined = cell(1,numel(groupNames));
sem_CS_onset_signals_combined = cell(1,numel(groupNames));

mean_freeze_onset_signals_combined = cell(1,numel(groupNames));
sem_freeze_onset_signals_combined = cell(1,numel(groupNames));

mean_move_onset_signals_combined = cell(1,numel(groupNames));
sem_move_onset_signals_combined = cell(1,numel(groupNames));

for mouse=1:numel(animalNames)
    group_id = find(strcmp(groups{mouse},groupNames));
    STREAM_STORES = {STREAM_STORE1{group_id}, STREAM_STORE2{group_id}, STREAM_STORE3};

    photometry_data = read_photometry_data_old(photometry_files{mouse}, TTLonOff(mouse));
    photometry_data = TDTfilter(photometry_data,EPOC,'TIME',TRANGE);
    remove_artifacts(photometry_data.streams, ARTIFACT, STREAM_STORES);
    [signal.zall, signal.zerror, signal.ts1, signal.Y_dF_all] = process_signal(photometry_data.streams, STREAM_STORES, TRANGE, BASELINE_PER, N);
    
    freezing_data = readtable(freezing_files{mouse});
    Frames = freezing_data.Frames;
    Freezing = freezing_data.Freezing;
    last_s = TRANGE(1)+TRANGE(2);

     [freeze_onset_times, freeze_offset_times, move_onset_times, move_offset_times] = get_freeze_move_eps(Frames, Freezing, ...
         freeze_threshold, move_threshold, FPS, TRANGE(1), last_s);

    if length(freeze_onset_times) ~= length(freeze_offset_times)
        freeze_offset_times = [freeze_offset_times, last_s];
    end
    
    if length(move_onset_times) ~= length(move_offset_times)
        move_offset_times = [move_offset_times, last_s];
    end

    % CS onset
    CS_onset_signals = [];

    for i=1:numel(CS_onset_times)
        curr_CS = CS_onset_times(i);
        curr_CS_signal = signal.zall(signal.ts1 >= curr_CS - 5 & signal.ts1 < curr_CS + 30);
        CS_onset_signals = add_adj_vector(CS_onset_signals, curr_CS_signal);
    end

    mean_CS_onset_signal = mean(CS_onset_signals,1);
    sem_CS_onset_signal = std(CS_onset_signals,[],1) / sqrt(size(CS_onset_signals,1));

    mean_CS_onset_signals_combined{group_id} = add_adj_vector(mean_CS_onset_signals_combined{group_id}, mean_CS_onset_signal);
    sem_CS_onset_signals_combined{group_id} = add_adj_vector(sem_CS_onset_signals_combined{group_id}, sem_CS_onset_signal);
    
    % Freezing onset
    freeze_onset_signals = [];

    for eps=1:numel(freeze_onset_times)
        curr_freeze_time = freeze_onset_times(eps);
        if (curr_freeze_time-TRANGE(1)) > 5 && (last_s-curr_freeze_time) > 30
            curr_freeze_signal = signal.zall(signal.ts1 >= curr_freeze_time - 5 & signal.ts1 < curr_freeze_time + 30);
            freeze_onset_signals = add_adj_vector(freeze_onset_signals, curr_freeze_signal);
        end
    end

    mean_freeze_onset_signal = mean(freeze_onset_signals,1);
    sem_freeze_onset_signal = std(freeze_onset_signals,[],1) / sqrt(size(freeze_onset_signals,1));

    mean_freeze_onset_signals_combined{group_id} = add_adj_vector(mean_freeze_onset_signals_combined{group_id}, mean_freeze_onset_signal);
    sem_freeze_onset_signals_combined{group_id} = add_adj_vector(sem_freeze_onset_signals_combined{group_id}, sem_freeze_onset_signal);

    % Moving onset
    move_onset_signals = [];

    for eps=1:numel(move_onset_times)
        curr_move_time = move_onset_times(eps);
        if (curr_move_time-TRANGE(1)) > 5 && (last_s-curr_move_time) > 30
            curr_move_signal = signal.zall(signal.ts1 >= curr_move_time - 5 & signal.ts1 < curr_move_time + 30);
            move_onset_signals = add_adj_vector(move_onset_signals, curr_move_signal);
        end
    end

    mean_move_onset_signal = mean(move_onset_signals,1);
    sem_move_onset_signal = std(move_onset_signals,[],1) / sqrt(size(move_onset_signals,1));

    mean_move_onset_signals_combined{group_id} = add_adj_vector(mean_move_onset_signals_combined{group_id}, mean_move_onset_signal);
    sem_move_onset_signals_combined{group_id} = add_adj_vector(sem_move_onset_signals_combined{group_id}, sem_move_onset_signal);
end

for group_id=1:numel(groupNames)
    mean_CS_onset_final{group_id} = mean(mean_CS_onset_signals_combined{group_id},1);
    for col=1:size(sem_CS_onset_signals_combined{group_id},2)
        sem_CS_onset_final{group_id}(1,col) = propagate_error(sem_CS_onset_signals_combined{group_id}(:,col));
    end
    
    mean_freeze_onset_final{group_id} = mean(mean_freeze_onset_signals_combined{group_id},1);
    for col=1:size(sem_freeze_onset_signals_combined{group_id},2)
        sem_freeze_onset_final{group_id}(1,col) = propagate_error(sem_freeze_onset_signals_combined{group_id}(:,col));
    end
    
    mean_move_onset_final{group_id} = mean(mean_move_onset_signals_combined{group_id},1);
    for col=1:size(sem_move_onset_signals_combined{group_id},2)
        sem_move_onset_final{group_id}(1,col) = propagate_error(sem_move_onset_signals_combined{group_id}(:,col));
    end
end

% Plot traces
figure;
title('CS onset'); hold on;
y = 2.5;
for group_id=1:numel(groupNames)
    plot(linspace(-5,30,numel(mean_CS_onset_final{group_id})), mean_CS_onset_final{group_id}, 'LineWidth', 2, 'Color', plot_colors{group_id});
    errorplot3(mean_CS_onset_final{group_id}-sem_CS_onset_final{group_id}, mean_CS_onset_final{group_id}+sem_CS_onset_final{group_id}, ...
        [-5 30], plot_colors{group_id}, 0.3);
    xline(0,'LineStyle','--');
    CS_onset_bCI = bootstrapping(mean_CS_onset_signals_combined{group_id}, sig, consec_thresh, y-(group_id*0.1)); hold on;
    plot(linspace(-5,30,numel(mean_CS_onset_final{group_id})),CS_onset_bCI,'Color',plot_colors{group_id},'LineWidth',2); hold on;
end

if numel(groupNames)==2
    perm_CS = permutation_test(mean_CS_onset_signals_combined{1}, mean_CS_onset_signals_combined{2}, sig, consec_thresh, y);
    plot(linspace(-5,30,numel(mean_CS_onset_final{1})),perm_CS,'Color',perm_test_color,'LineWidth', 2);
end

figure;
title('Freezing onset'); hold on;
y = 0.25;
for group_id=1:numel(groupNames)
    plot(linspace(-5,30,numel(mean_freeze_onset_final{group_id})), mean_freeze_onset_final{group_id}, 'LineWidth', 2, 'Color', plot_colors{group_id});
    errorplot3(mean_freeze_onset_final{group_id}-sem_freeze_onset_final{group_id}, mean_freeze_onset_final{group_id}+sem_freeze_onset_final{group_id}, ...
        [-5 30], plot_colors{group_id}, 0.3);
    xline(0,'LineStyle','--');
    freezing_onset_bCI = bootstrapping(mean_freeze_onset_signals_combined{group_id}, sig, consec_thresh, y-(group_id*0.1)); hold on;
    plot(linspace(-5,30,numel(mean_freeze_onset_final{group_id})),freezing_onset_bCI,'Color',plot_colors{group_id},'LineWidth',2); hold on;
end

if numel(groupNames)==2
    perm_freeze = permutation_test(mean_freeze_onset_signals_combined{1}, mean_freeze_onset_signals_combined{2}, sig, consec_thresh, y);
    plot(linspace(-5,30,numel(mean_freeze_onset_final{1})),perm_freeze,'Color',perm_test_color,'LineWidth', 2);
end

figure;
title('Moving onset'); hold on;
y = 0.5;
for group_id=1:numel(groupNames)
    plot(linspace(-5,30,numel(mean_move_onset_final{group_id})), mean_move_onset_final{group_id}, 'LineWidth', 2, 'Color', plot_colors{group_id});
    errorplot3(mean_move_onset_final{group_id}-sem_move_onset_final{group_id}, mean_move_onset_final{group_id}+sem_move_onset_final{group_id}, ...
        [-5 30], plot_colors{group_id}, 0.3);
    xline(0,'LineStyle','--');
    moving_onset_bCI = bootstrapping(mean_move_onset_signals_combined{group_id}, sig, consec_thresh, y-(group_id*0.1)); hold on;
    plot(linspace(-5,30,numel(mean_move_onset_final{group_id})),moving_onset_bCI,'Color',plot_colors{group_id},'LineWidth',2); hold on;
end

if numel(groupNames)==2
    perm_move = permutation_test(mean_move_onset_signals_combined{1}, mean_move_onset_signals_combined{2}, sig, consec_thresh, y);
    plot(linspace(-5,30,numel(mean_move_onset_final{1})),perm_move,'Color',perm_test_color,'LineWidth', 2);
end

% AUC
pre_CS_onset_AUC = cell(1,numel(groupNames));
post_CS_onset_AUC = cell(1,numel(groupNames));

pre_freeze_onset_AUC = cell(1,numel(groupNames));
post_freeze_onset_AUC = cell(1,numel(groupNames));

pre_move_onset_AUC = cell(1,numel(groupNames));
post_move_onset_AUC = cell(1,numel(groupNames));

for group=1:numel(groupNames)
    for i=1:size(mean_CS_onset_signals_combined{group},1)
        curr_time = linspace(-5,30,length(mean_CS_onset_signals_combined{group}(i,:)));

        pre_idx = curr_time < 0;
        post_idx = curr_time >= 0;

        pre_time = curr_time(pre_idx);
        post_time = curr_time(post_idx);
        
        pre_CS_onset_signal = mean_CS_onset_signals_combined{group}(i,pre_idx);
        post_CS_onset_signal = mean_CS_onset_signals_combined{group}(i,post_idx);

        pre_CS_onset_AUC{group} = [pre_CS_onset_AUC{group}; trapz(pre_time, pre_CS_onset_signal)];
        post_CS_onset_AUC{group} = [post_CS_onset_AUC{group}; trapz(post_time, post_CS_onset_signal) / 6];
    end
    for i=1:size(mean_freeze_onset_signals_combined{group},1)
        curr_time = linspace(-5,30,length(mean_freeze_onset_signals_combined{group}(i,:)));

        pre_idx = curr_time < 0;
        post_idx = curr_time >= 0;

        pre_time = curr_time(pre_idx);
        post_time = curr_time(post_idx);
        
        pre_freeze_onset_signal = mean_freeze_onset_signals_combined{group}(i,pre_idx);
        post_freeze_onset_signal = mean_freeze_onset_signals_combined{group}(i,post_idx);

        pre_freeze_onset_AUC{group} = [pre_freeze_onset_AUC{group}; trapz(pre_time, pre_freeze_onset_signal)];
        post_freeze_onset_AUC{group} = [post_freeze_onset_AUC{group}; trapz(post_time, post_freeze_onset_signal) / 6];
    end
    for i=1:size(mean_move_onset_signals_combined{group},1)
        curr_time = linspace(-5,30,length(mean_move_onset_signals_combined{group}(i,:)));

        pre_idx = curr_time < 0;
        post_idx = curr_time >= 0;

        pre_time = curr_time(pre_idx);
        post_time = curr_time(post_idx);
        
        pre_move_onset_signal = mean_move_onset_signals_combined{group}(i,pre_idx);
        post_move_onset_signal = mean_move_onset_signals_combined{group}(i,post_idx);

        pre_move_onset_AUC{group} = [pre_move_onset_AUC{group}; trapz(pre_time, pre_move_onset_signal)];
        post_move_onset_AUC{group} = [post_move_onset_AUC{group}; trapz(post_time, post_move_onset_signal) / 6];
    end

    curr_AUCs = [pre_CS_onset_AUC{group}, post_CS_onset_AUC{group}, pre_freeze_onset_AUC{group},...
        post_freeze_onset_AUC{group}, pre_move_onset_AUC{group}, post_move_onset_AUC{group}];
    curr_AUCs_table = array2table(curr_AUCs);
    curr_AUCs_table.Properties.VariableNames = ["CS onset (-5-0s)", "CS onset (0-30s)", "Freezing onset (-5-0s)"...
        "Freezing onset (0-30s)", "Moving onset (-5-0s)", "Moving onset (0-30s)"];
    writetable(curr_AUCs_table, AUC_output_file, 'Sheet', groupNames{group});
end

% Latency
CS_times_to_max = cell(1,numel(groupNames));

for group=1:numel(groupNames)
    CS_times_to_max{group} = [];
    for i=1:size(mean_CS_onset_signals_combined{group},1)
        curr_CS_onset_signal = mean_CS_onset_signals_combined{group}(i,:);
        curr_CS_onset_time = linspace(-5,30,length(curr_CS_onset_signal));
        CS_time_trimmed = curr_CS_onset_time(curr_CS_onset_time >= 0);
        CS_signal_trimmed = curr_CS_onset_signal(curr_CS_onset_time >= 0);
        [~, CS_max_idx] = max(CS_signal_trimmed);
        CS_time_to_max = CS_time_trimmed(CS_max_idx);
        CS_times_to_max{group} = [CS_times_to_max{group}; CS_time_to_max];
    end

    mean_CS_times_to_max{group} = mean(CS_times_to_max{group},1);
    sem_CS_times_to_max{group} = std(CS_times_to_max{group},[],1) / sqrt(size(CS_times_to_max{group},1));
end

freeze_times_to_max = cell(1,numel(groupNames));

for group=1:numel(groupNames)
    freeze_times_to_max{group} = [];
    for i=1:size(mean_freeze_onset_signals_combined{group},1)
        curr_freeze_onset_signal = mean_freeze_onset_signals_combined{group}(i,:);
        curr_freeze_onset_time = linspace(-5,30,length(curr_freeze_onset_signal));
        freeze_time_trimmed = curr_freeze_onset_time(curr_freeze_onset_time >= 0);
        freeze_signal_trimmed = curr_freeze_onset_signal(curr_freeze_onset_time >= 0);
        [~, freeze_max_idx] = max(freeze_signal_trimmed);
        freeze_time_to_max = freeze_time_trimmed(freeze_max_idx);
        freeze_times_to_max{group} = [freeze_times_to_max{group}; freeze_time_to_max];
    end

    mean_freeze_times_to_max{group} = mean(freeze_times_to_max{group},1);
    sem_freeze_times_to_max{group} = std(freeze_times_to_max{group},[],1) / sqrt(size(freeze_times_to_max{group},1));
end

move_times_to_max = cell(1,numel(groupNames));

for group=1:numel(groupNames)
    move_times_to_max{group} = [];
    for i=1:size(mean_move_onset_signals_combined{group},1)
        curr_move_onset_signal = mean_move_onset_signals_combined{group}(i,:);
        curr_move_onset_time = linspace(-5,30,length(curr_move_onset_signal));
        move_time_trimmed = curr_move_onset_time(curr_move_onset_time >= 0);
        move_signal_trimmed = curr_move_onset_signal(curr_move_onset_time >= 0);
        [~, move_max_idx] = max(move_signal_trimmed);
        move_time_to_max = move_time_trimmed(move_max_idx);
        move_times_to_max{group} = [move_times_to_max{group}; move_time_to_max];
    end

    mean_move_times_to_max{group} = mean(move_times_to_max{group},1);
    sem_move_times_to_max{group} = std(move_times_to_max{group},[],1) / sqrt(size(move_times_to_max{group},1));
end

header = {"CS onset", "Freezing onset", "Moving onset"};
for group=1:numel(groupNames)
    latency_combined = [CS_times_to_max{group}, freeze_times_to_max{group}, move_times_to_max{group}];
    writecell(header, latency_output_file, 'Sheet', groupNames{group}, 'Range', 'A1');
    writematrix(latency_combined, latency_output_file, 'Sheet', groupNames{group}, 'Range', 'A2');
end

X = categorical({'CS onset', 'Freezing onset', 'Moving onset'});
X = reordercats(X,{'CS onset', 'Freezing onset', 'Moving onset'});
Y = [cell2mat(mean_CS_times_to_max); cell2mat(mean_freeze_times_to_max); cell2mat(mean_move_times_to_max)];
figure;
h = bar(X, Y); hold on;
errorbar(h(1).XEndPoints,[mean_CS_times_to_max{1}, mean_freeze_times_to_max{1}, mean_move_times_to_max{1}],[sem_CS_times_to_max{1}, sem_freeze_times_to_max{1}, sem_move_times_to_max{1}],'LineStyle','none','Color','k','LineWidth',2);
errorbar(h(2).XEndPoints,[mean_CS_times_to_max{2}, mean_freeze_times_to_max{2}, mean_move_times_to_max{2}],[sem_CS_times_to_max{2}, sem_freeze_times_to_max{2}, sem_move_times_to_max{2}],'LineStyle','none','Color','k','LineWidth',2);
scatter(repmat(h(1).XEndPoints(1), size(CS_times_to_max{1},1), 1),CS_times_to_max{1},60,'MarkerFaceColor',[0 0.4470 0.7410],'MarkerEdgeColor','k','LineWidth',1);
scatter(repmat(h(1).XEndPoints(2), size(freeze_times_to_max{1},1), 1),freeze_times_to_max{1},60,'MarkerFaceColor',[0 0.4470 0.7410],'MarkerEdgeColor','k','LineWidth',1);
scatter(repmat(h(1).XEndPoints(3), size(move_times_to_max{1},1), 1),move_times_to_max{1},60,'MarkerFaceColor',[0 0.4470 0.7410],'MarkerEdgeColor','k','LineWidth',1);
scatter(repmat(h(2).XEndPoints(1), size(CS_times_to_max{2},1), 1),CS_times_to_max{2},60,'MarkerFaceColor',[0.8500 0.3250 0.0980],'MarkerEdgeColor','k','LineWidth',1);
scatter(repmat(h(2).XEndPoints(2), size(freeze_times_to_max{2},1), 1),freeze_times_to_max{2},60,'MarkerFaceColor',[0.8500 0.3250 0.0980],'MarkerEdgeColor','k','LineWidth',1);
scatter(repmat(h(2).XEndPoints(3), size(move_times_to_max{2},1), 1),move_times_to_max{2},60,'MarkerFaceColor',[0.8500 0.3250 0.0980],'MarkerEdgeColor','k','LineWidth',1);

legend(groupNames);
title('Time to max');