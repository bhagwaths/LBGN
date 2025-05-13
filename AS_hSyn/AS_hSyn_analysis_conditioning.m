stage = "conditioning";

animalNames = {'2AS_hSyn_1';
           '2AS_hSyn_2';
           '2AS_hSyn_3';
           '2AS_hSyn_4';
           '2AS_hSyn_5';
           '2AS_hSyn_6';
           '2AS_hSyn_7';
           '2AS_hSyn_8';
           '2AS_hSyn_1';
           '2AS_hSyn_2';
           '2AS_hSyn_3';
           '2AS_hSyn_4';
           '2AS_hSyn_5';
           '2AS_hSyn_6';
           '2AS_hSyn_7';
           '2AS_hSyn_8'};

plot_colors = {[.6 .0 .2]; [0. 0.4 0.0]};
perm_test_color = [1 .4 0];

groupNames = {'hSyn'; 'AS'};
groups = {'hSyn'; 'hSyn'; 'hSyn'; 'hSyn'; 'hSyn'; 'hSyn'; 'hSyn'; 'hSyn'; 'AS'; 'AS'; 'AS';'AS'; 'AS'; 'AS'; 'AS'; 'AS'};

photometry_files = {'C:\Users\bhagwaths\Documents\AS-hSyn\2conditioning\2AS_hSyn_1-240326-091206';
'C:\Users\bhagwaths\Documents\AS-hSyn\2conditioning\2AS_hSyn_2-240708-143348';
'C:\Users\bhagwaths\Documents\AS-hSyn\2conditioning\2AS_hSyn_3-240326-094821';
'C:\Users\bhagwaths\Documents\AS-hSyn\2conditioning\2AS_hSyn_4-240708-125108';
'C:\Users\bhagwaths\Documents\AS-hSyn\2conditioning\2AS_hSyn_5-240326-101711';
'C:\Users\bhagwaths\Documents\AS-hSyn\2conditioning\2AS_hSyn_6-240708-131948';
'C:\Users\bhagwaths\Documents\AS-hSyn\2conditioning\2AS_hSyn_7-240326-110530';
'C:\Users\bhagwaths\Documents\AS-hSyn\2conditioning\2AS_hSyn_8-240708-140820';
'C:\Users\bhagwaths\Documents\AS-hSyn\2conditioning\2AS_hSyn_1-240326-091206';
'C:\Users\bhagwaths\Documents\AS-hSyn\2conditioning\2AS_hSyn_2-240708-143348';
'C:\Users\bhagwaths\Documents\AS-hSyn\2conditioning\2AS_hSyn_3-240326-094821';
'C:\Users\bhagwaths\Documents\AS-hSyn\2conditioning\2AS_hSyn_4-240708-125108';
'C:\Users\bhagwaths\Documents\AS-hSyn\2conditioning\2AS_hSyn_5-240326-101711';
'C:\Users\bhagwaths\Documents\AS-hSyn\2conditioning\2AS_hSyn_6-240708-131948';
'C:\Users\bhagwaths\Documents\AS-hSyn\2conditioning\2AS_hSyn_7-240326-110530';
'C:\Users\bhagwaths\Documents\AS-hSyn\2conditioning\2AS_hSyn_8-240708-140820'};

freezing_files = {'C:\Users\bhagwaths\Documents\AS-hSyn\2conditioning\FreezingOutput_processed\2.AS-hSyn-1_FreezingOutput_processed.csv';
'C:\Users\bhagwaths\Documents\AS-hSyn\2conditioning\FreezingOutput_processed\2.AS-hSyn-2_FreezingOutput_processed.csv';
'C:\Users\bhagwaths\Documents\AS-hSyn\2conditioning\FreezingOutput_processed\2.AS-hSyn-3_FreezingOutput_processed.csv';
'C:\Users\bhagwaths\Documents\AS-hSyn\2conditioning\FreezingOutput_processed\2.AS-hSyn-4_FreezingOutput_processed.csv';
'C:\Users\bhagwaths\Documents\AS-hSyn\2conditioning\FreezingOutput_processed\2.AS-hSyn-5_FreezingOutput_processed.csv';
'C:\Users\bhagwaths\Documents\AS-hSyn\2conditioning\FreezingOutput_processed\2.AS-hSyn-6_FreezingOutput_processed.csv';
'C:\Users\bhagwaths\Documents\AS-hSyn\2conditioning\FreezingOutput_processed\2.AS-hSyn-7_FreezingOutput_processed.csv';
'C:\Users\bhagwaths\Documents\AS-hSyn\2conditioning\FreezingOutput_processed\2.AS-hSyn-8_FreezingOutput_processed.csv';
'C:\Users\bhagwaths\Documents\AS-hSyn\2conditioning\FreezingOutput_processed\2.AS-hSyn-1_FreezingOutput_processed.csv';
'C:\Users\bhagwaths\Documents\AS-hSyn\2conditioning\FreezingOutput_processed\2.AS-hSyn-2_FreezingOutput_processed.csv';
'C:\Users\bhagwaths\Documents\AS-hSyn\2conditioning\FreezingOutput_processed\2.AS-hSyn-3_FreezingOutput_processed.csv';
'C:\Users\bhagwaths\Documents\AS-hSyn\2conditioning\FreezingOutput_processed\2.AS-hSyn-4_FreezingOutput_processed.csv';
'C:\Users\bhagwaths\Documents\AS-hSyn\2conditioning\FreezingOutput_processed\2.AS-hSyn-5_FreezingOutput_processed.csv';
'C:\Users\bhagwaths\Documents\AS-hSyn\2conditioning\FreezingOutput_processed\2.AS-hSyn-6_FreezingOutput_processed.csv';
'C:\Users\bhagwaths\Documents\AS-hSyn\2conditioning\FreezingOutput_processed\2.AS-hSyn-7_FreezingOutput_processed.csv';
'C:\Users\bhagwaths\Documents\AS-hSyn\2conditioning\FreezingOutput_processed\2.AS-hSyn-8_FreezingOutput_processed.csv'};

TRANGE = [-180 450];
BASELINE_PER = [-180 -1];

CS_onset_times = [0, 90, 210];
US_onset_times = [28, 118, 238];
TTLonOff = [1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1];

firstTTL=[232; 199.1; 203; 197; 213.1; 217.6; 216.1; 207.8;
           232; 199.1; 203; 197; 213.1; 217.6; 216.1; 207.8];

whichStreams= [910; 112; 910; 112; 910; 112; 910; 112;
               12; 34; 12; 56; 12; 56; 78; 34];

EPOC = 'Session';
N = 100;
ARTIFACT = inf;
%%
FPS = 30;
freeze_threshold = 30;
move_threshold = 30;

sig = .05;
consec_thresh = 14;

AUC_range_pre_CS = [-5 0]; % time range for AUC calculation (pre-CS)
AUC_range_post_CS = [0 30]; % time range for AUC calculation (post-CS)

AUC_range_pre_US = [-5 0]; % time range for AUC calculation (pre-US)
AUC_range_post_US = [0 30]; % time range for AUC calculation (post-US)

AUC_range_pre_freezing = [-5 0]; % time range for AUC calculation (pre-freezing)
AUC_range_post_freezing = [0 30]; % time range for AUC calculation (post-freezing)

AUC_range_pre_moving = [-5 0]; % time range for AUC calculation (pre-moving)
AUC_range_post_moving = [0 30]; % time range for AUC calculation (post-moving)

latency_range_CS = [0 50];
latency_range_US = [0 30];
latency_range_freezing = [0 30];
latency_range_moving = [0 30];

AUC_output_file = 'AS-hSyn_conditioning_AUC.xlsx';
latency_output_file = 'AS-hSyn_conditioning_latency.xlsx';

mean_CS_onset_signals_combined = cell(1,numel(groupNames));
sem_CS_onset_signals_combined = cell(1,numel(groupNames));

mean_US_onset_signals_combined = cell(1,numel(groupNames));
sem_US_onset_signals_combined = cell(1,numel(groupNames));

mean_freeze_onset_signals_combined = cell(1,numel(groupNames));
sem_freeze_onset_signals_combined = cell(1,numel(groupNames));

mean_move_onset_signals_combined = cell(1,numel(groupNames));
sem_move_onset_signals_combined = cell(1,numel(groupNames));

for mouse=1:numel(animalNames)
    group_id = find(strcmp(groups{mouse},groupNames));
    if whichStreams(mouse)==12
        STREAM_STORE1 = 'ax05A'; %put here what your 405 channel is
        STREAM_STORE2 = 'ax73A'; %put here what your 465 channel is
    elseif whichStreams(mouse)==34
        STREAM_STORE1 ='ax05B' ; %put here what your 405 channel is
        STREAM_STORE2 = 'ax70B'; %put here what your 465 channel is
    elseif whichStreams(mouse)==56
        STREAM_STORE1 ='ax05A' ; %put here what your 405 channel is
        STREAM_STORE2 = 'ax70A'; %put here what your 465 channel is  
    elseif whichStreams(mouse)==78
        STREAM_STORE1 ='ax05C' ; %put here what your 405 channel is
        STREAM_STORE2 = 'ax73C'; %put here what your 465 channel is 
     elseif whichStreams(mouse)==910
        STREAM_STORE1 ='ax05A' ; %put here what your 405 channel is
        STREAM_STORE2 = 'ax65A'; %put here what your 465 channel is    
    elseif whichStreams(mouse)==112
        STREAM_STORE1 ='ax05A' ; %put here what your 405 channel is
        STREAM_STORE2 = 'ax60A'; %put here what your 465 channel is  
    end
    STREAM_STORE3 = 'aFi1r';
    STREAM_STORES = {STREAM_STORE1, STREAM_STORE2, STREAM_STORE3};

    photometry_data = read_photometry_data_3(photometry_files{mouse},firstTTL(mouse));
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
        curr_CS_signal = signal.zall(signal.ts1 >= curr_CS - 5 & signal.ts1 < curr_CS + 50);
        CS_onset_signals = add_adj_vector(CS_onset_signals, curr_CS_signal);
    end

    mean_CS_onset_signal = mean(CS_onset_signals,1);
    sem_CS_onset_signal = std(CS_onset_signals,[],1) / sqrt(size(CS_onset_signals,1));

    mean_CS_onset_signals_combined{group_id} = add_adj_vector(mean_CS_onset_signals_combined{group_id}, mean_CS_onset_signal);
    sem_CS_onset_signals_combined{group_id} = add_adj_vector(sem_CS_onset_signals_combined{group_id}, sem_CS_onset_signal);
    
    %  US onset
    US_onset_signals = [];

    for i=1:numel(US_onset_times)
        curr_US = US_onset_times(i);
        curr_US_signal = signal.zall(signal.ts1 >= curr_US - 5 & signal.ts1 < curr_US + 30);
        US_onset_signals = add_adj_vector(US_onset_signals, curr_US_signal);
    end

    mean_US_onset_signal = mean(US_onset_signals,1);
    sem_US_onset_signal = std(US_onset_signals,[],1) / sqrt(size(US_onset_signals,1));

    mean_US_onset_signals_combined{group_id} = add_adj_vector(mean_US_onset_signals_combined{group_id}, mean_US_onset_signal);
    sem_US_onset_signals_combined{group_id} = add_adj_vector(sem_US_onset_signals_combined{group_id}, sem_US_onset_signal);

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

    mean_US_onset_final{group_id} = mean(mean_US_onset_signals_combined{group_id},1);
    for col=1:size(sem_US_onset_signals_combined{group_id},2)
        sem_US_onset_final{group_id}(1,col) = propagate_error(sem_US_onset_signals_combined{group_id}(:,col));
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

%% Plot traces
figure;
title('CS onset'); hold on;
y = 15.9;
for group_id=1:numel(groupNames)
    plot(linspace(-5,50,numel(mean_CS_onset_final{group_id})), mean_CS_onset_final{group_id}, 'LineWidth', 2, 'Color', plot_colors{group_id});
    errorplot3(mean_CS_onset_final{group_id}-sem_CS_onset_final{group_id}, mean_CS_onset_final{group_id}+sem_CS_onset_final{group_id}, ...
        [-5 50], plot_colors{group_id}, 0.3);
    xline(0,'LineStyle','--');
    yline(0,'LineStyle','--');
    xline(28,'LineStyle','--');
    CS_onset_bCI = bootstrapping(mean_CS_onset_signals_combined{group_id}, sig, consec_thresh, y-(group_id*0.1)); hold on;
    plot(linspace(-5,50,numel(mean_CS_onset_final{group_id})),CS_onset_bCI,'Color',plot_colors{group_id},'LineWidth',2); hold on;
end

if numel(groupNames)==2
    perm_CS = permutation_test(mean_CS_onset_signals_combined{1}, mean_CS_onset_signals_combined{2}, sig, consec_thresh, y);
    plot(linspace(-5,50,numel(mean_CS_onset_final{1})),perm_CS,'Color',perm_test_color,'LineWidth', 2);
end

%%

figure;
title('US onset'); hold on;
y = 15.9;
for group_id=1:numel(groupNames)
    plot(linspace(-5,30,numel(mean_US_onset_final{group_id})), mean_US_onset_final{group_id}, 'LineWidth', 2, 'Color', plot_colors{group_id});
    errorplot3(mean_US_onset_final{group_id}-sem_US_onset_final{group_id}, mean_US_onset_final{group_id}+sem_US_onset_final{group_id}, ...
        [-5 30], plot_colors{group_id}, 0.3);
    xline(0,'LineStyle','--');
    yline(0,'LineStyle','--');
    US_onset_bCI = bootstrapping(mean_US_onset_signals_combined{group_id}, sig, consec_thresh, y-(group_id*0.1)); hold on;
    plot(linspace(-5,30,numel(mean_US_onset_final{group_id})),US_onset_bCI,'Color',plot_colors{group_id},'LineWidth',2); hold on;
end

if numel(groupNames)==2
    perm_US = permutation_test(mean_US_onset_signals_combined{1}, mean_US_onset_signals_combined{2}, sig, consec_thresh, y);
    plot(linspace(-5,30,numel(mean_US_onset_final{1})),perm_US,'Color',perm_test_color,'LineWidth', 2);
end

%%
figure;
title('Freezing onset'); hold on;
y = 0.9;
for group_id=1:numel(groupNames)
    plot(linspace(-5,30,numel(mean_freeze_onset_final{group_id})), mean_freeze_onset_final{group_id}, 'LineWidth', 2, 'Color', plot_colors{group_id});
    errorplot3(mean_freeze_onset_final{group_id}-sem_freeze_onset_final{group_id}, mean_freeze_onset_final{group_id}+sem_freeze_onset_final{group_id}, ...
        [-5 30], plot_colors{group_id}, 0.3);
    xline(0,'LineStyle','--');
    yline(0,'LineStyle','--');
    freezing_onset_bCI = bootstrapping(mean_freeze_onset_signals_combined{group_id}, sig, consec_thresh, y-(group_id*0.1)); hold on;
    plot(linspace(-5,30,numel(mean_freeze_onset_final{group_id})),freezing_onset_bCI,'Color',plot_colors{group_id},'LineWidth',2); hold on;
end

if numel(groupNames)==2
    perm_freeze = permutation_test(mean_freeze_onset_signals_combined{1}, mean_freeze_onset_signals_combined{2}, sig, consec_thresh, y);
    plot(linspace(-5,30,numel(mean_freeze_onset_final{1})),perm_freeze,'Color',perm_test_color,'LineWidth', 2);
end

xlim([-5 30]); ylim([-1 1]); hold on;
    plot([0 0],ylim,'k--'); hold on;
    plot(xlim,[0 0],'k--');

%%
figure;
title('Moving onset'); hold on;
y = 1.1;
for group_id=1:numel(groupNames)
    plot(linspace(-5,30,numel(mean_move_onset_final{group_id})), mean_move_onset_final{group_id}, 'LineWidth', 2, 'Color', plot_colors{group_id});
    errorplot3(mean_move_onset_final{group_id}-sem_move_onset_final{group_id}, mean_move_onset_final{group_id}+sem_move_onset_final{group_id}, ...
        [-5 30], plot_colors{group_id}, 0.3);
    xline(0,'LineStyle','--');
    yline(0,'LineStyle','--');
    moving_onset_bCI = bootstrapping(mean_move_onset_signals_combined{group_id}, sig, consec_thresh, y-(group_id*0.1)); hold on;
    plot(linspace(-5,30,numel(mean_move_onset_final{group_id})),moving_onset_bCI,'Color',plot_colors{group_id},'LineWidth',2); hold on;
end

if numel(groupNames)==2
    perm_move = permutation_test(mean_move_onset_signals_combined{1}, mean_move_onset_signals_combined{2}, sig, consec_thresh, y);
    plot(linspace(-5,30,numel(mean_move_onset_final{1})),perm_move,'Color',perm_test_color,'LineWidth', 2);
end

xlim([-5 30]); ylim([-1 1.2]); hold on;
    plot([0 0],ylim,'k--'); hold on;
    plot(xlim,[0 0],'k--');

%% AUC
pre_CS_onset_AUC = cell(1,numel(groupNames));
post_CS_onset_AUC = cell(1,numel(groupNames));

pre_US_onset_AUC = cell(1,numel(groupNames));
post_US_onset_AUC = cell(1,numel(groupNames));

pre_freeze_onset_AUC = cell(1,numel(groupNames));
post_freeze_onset_AUC = cell(1,numel(groupNames));

pre_move_onset_AUC = cell(1,numel(groupNames));
post_move_onset_AUC = cell(1,numel(groupNames));

AUC_pre_CS_duration = AUC_range_pre_CS(2) - AUC_range_pre_CS(1);
AUC_post_CS_duration = AUC_range_post_CS(2) - AUC_range_post_CS(1);
AUC_pre_post_CS_ratio = AUC_post_CS_duration / AUC_pre_CS_duration;

AUC_pre_US_duration = AUC_range_pre_US(2) - AUC_range_pre_US(1);
AUC_post_US_duration = AUC_range_post_US(2) - AUC_range_post_US(1);
AUC_pre_post_US_ratio = AUC_post_US_duration / AUC_pre_US_duration;

AUC_pre_freezing_duration = AUC_range_pre_freezing(2) - AUC_range_pre_freezing(1);
AUC_post_freezing_duration = AUC_range_post_freezing(2) - AUC_range_post_freezing(1);
AUC_pre_post_freezing_ratio = AUC_post_freezing_duration / AUC_pre_freezing_duration;

AUC_pre_moving_duration = AUC_range_pre_moving(2) - AUC_range_pre_moving(1);
AUC_post_moving_duration = AUC_range_post_moving(2) - AUC_range_post_moving(1);
AUC_pre_post_moving_ratio = AUC_post_moving_duration / AUC_pre_moving_duration;

for group=1:numel(groupNames)
    for i=1:size(mean_CS_onset_signals_combined{group},1)
        curr_time = linspace(-5,50,length(mean_CS_onset_signals_combined{group}(i,:)));

        pre_idx = curr_time < 0;
        post_idx = curr_time >= 0;

        pre_time = curr_time(pre_idx);
        post_time = curr_time(post_idx);
        
        pre_CS_onset_signal = mean_CS_onset_signals_combined{group}(i,pre_idx);
        post_CS_onset_signal = mean_CS_onset_signals_combined{group}(i,post_idx);

        pre_CS_onset_AUC{group} = [pre_CS_onset_AUC{group}; trapz(pre_time, pre_CS_onset_signal)];
        post_CS_onset_AUC{group} = [post_CS_onset_AUC{group}; trapz(post_time, post_CS_onset_signal) / AUC_pre_post_CS_ratio];
    end
    for i=1:size(mean_US_onset_signals_combined{group},1)
        curr_time = linspace(-5,30,length(mean_US_onset_signals_combined{group}(i,:)));

        pre_idx = curr_time < 0;
        post_idx = curr_time >= 0;

        pre_time = curr_time(pre_idx);
        post_time = curr_time(post_idx);
        
        pre_US_onset_signal = mean_US_onset_signals_combined{group}(i,pre_idx);
        post_US_onset_signal = mean_US_onset_signals_combined{group}(i,post_idx);

        pre_US_onset_AUC{group} = [pre_US_onset_AUC{group}; trapz(pre_time, pre_US_onset_signal)];
        post_US_onset_AUC{group} = [post_US_onset_AUC{group}; trapz(post_time, post_US_onset_signal) / AUC_pre_post_US_ratio];
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
        post_freeze_onset_AUC{group} = [post_freeze_onset_AUC{group}; trapz(post_time, post_freeze_onset_signal) / AUC_pre_post_freezing_ratio];
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
        post_move_onset_AUC{group} = [post_move_onset_AUC{group}; trapz(post_time, post_move_onset_signal) / AUC_pre_post_moving_ratio];
    end

    curr_AUCs = [pre_CS_onset_AUC{group}, post_CS_onset_AUC{group}, pre_US_onset_AUC{group}, post_US_onset_AUC{group},...
        pre_freeze_onset_AUC{group}, post_freeze_onset_AUC{group}, pre_move_onset_AUC{group}, post_move_onset_AUC{group}];
    curr_AUCs_table = array2table(curr_AUCs);

    curr_AUCs_table.Properties.VariableNames = ...
    {sprintf('CS onset (%d-%ds)', AUC_range_pre_CS(1), AUC_range_pre_CS(2)), sprintf('CS onset (%d-%ds)', AUC_range_post_CS(1), AUC_range_post_CS(2)),... 
    sprintf('US onset (%d-%ds)', AUC_range_pre_US(1), AUC_range_pre_US(2)), sprintf('US onset (%d-%ds)', AUC_range_post_US(1), AUC_range_post_US(2)),...
    sprintf('Freezing onset (%d-%ds)', AUC_range_pre_freezing(1), AUC_range_pre_freezing(2)), sprintf('Freezing onset (%d-%ds)', AUC_range_post_freezing(1), AUC_range_post_freezing(2)),...
    sprintf('Moving onset (%d-%ds)', AUC_range_pre_moving(1), AUC_range_pre_moving(2)), sprintf('Moving onset (%d-%ds)', AUC_range_post_moving(1), AUC_range_post_moving(2))};
    writetable(curr_AUCs_table, AUC_output_file, 'Sheet', groupNames{group});
end

%% Latency
CS_times_to_max = cell(1,numel(groupNames));

for group=1:numel(groupNames)
    CS_times_to_max{group} = [];
    for i=1:size(mean_CS_onset_signals_combined{group},1)
        curr_CS_onset_signal = mean_CS_onset_signals_combined{group}(i,:);
        curr_CS_onset_time = linspace(-5,50,length(curr_CS_onset_signal));
        CS_time_trimmed = curr_CS_onset_time(curr_CS_onset_time >= latency_range_CS(1) & curr_CS_onset_time <= latency_range_CS(2));
        CS_signal_trimmed = curr_CS_onset_signal(curr_CS_onset_time >= latency_range_CS(1) & curr_CS_onset_time <= latency_range_CS(2));
        [~, CS_max_idx] = max(CS_signal_trimmed);
        CS_time_to_max = CS_time_trimmed(CS_max_idx);
        CS_times_to_max{group} = [CS_times_to_max{group}; CS_time_to_max];
    end

    mean_CS_times_to_max{group} = mean(CS_times_to_max{group},1);
    sem_CS_times_to_max{group} = std(CS_times_to_max{group},[],1) / sqrt(size(CS_times_to_max{group},1));
end

US_times_to_max = cell(1,numel(groupNames));

for group=1:numel(groupNames)
    US_times_to_max{group} = [];
    for i=1:size(mean_US_onset_signals_combined{group},1)
        curr_US_onset_signal = mean_US_onset_signals_combined{group}(i,:);
        curr_US_onset_time = linspace(-5,30,length(curr_US_onset_signal));
        US_time_trimmed = curr_US_onset_time(curr_US_onset_time >= latency_range_US(1) & curr_US_onset_time <= latency_range_US(2));
        US_signal_trimmed = curr_US_onset_signal(curr_US_onset_time >= latency_range_US(1) & curr_US_onset_time <= latency_range_US(2));
        [~, US_max_idx] = max(US_signal_trimmed);
        US_time_to_max = US_time_trimmed(US_max_idx);
        US_times_to_max{group} = [US_times_to_max{group}; US_time_to_max];
    end

    mean_US_times_to_max{group} = mean(US_times_to_max{group},1);
    sem_US_times_to_max{group} = std(US_times_to_max{group},[],1) / sqrt(size(US_times_to_max{group},1));
end

freeze_times_to_max = cell(1,numel(groupNames));

for group=1:numel(groupNames)
    freeze_times_to_max{group} = [];
    for i=1:size(mean_freeze_onset_signals_combined{group},1)
        curr_freeze_onset_signal = mean_freeze_onset_signals_combined{group}(i,:);
        curr_freeze_onset_time = linspace(-5,30,length(curr_freeze_onset_signal));
        freeze_time_trimmed = curr_freeze_onset_time(curr_freeze_onset_time >= latency_range_freezing(1) & curr_freeze_onset_time <= latency_range_freezing(2));
        freeze_signal_trimmed = curr_freeze_onset_signal(curr_freeze_onset_time >= latency_range_freezing(1) & curr_freeze_onset_time <= latency_range_freezing(2));
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
        move_time_trimmed = curr_move_onset_time(curr_move_onset_time >= latency_range_moving(1) & curr_move_onset_time <= latency_range_moving(2));
        move_signal_trimmed = curr_move_onset_signal(curr_move_onset_time >= latency_range_moving(1) & curr_move_onset_time <= latency_range_moving(2));
        [~, move_max_idx] = max(move_signal_trimmed);
        move_time_to_max = move_time_trimmed(move_max_idx);
        move_times_to_max{group} = [move_times_to_max{group}; move_time_to_max];
    end

    mean_move_times_to_max{group} = mean(move_times_to_max{group},1);
    sem_move_times_to_max{group} = std(move_times_to_max{group},[],1) / sqrt(size(move_times_to_max{group},1));
end

header = {sprintf("CS onset (%d-%d)",latency_range_CS(1),latency_range_CS(2)),...
    sprintf("US onset (%d-%d)",latency_range_US(1),latency_range_US(2)),...
    sprintf("Freezing onset (%d-%d)",latency_range_freezing(1),latency_range_freezing(2)),...
    sprintf("Moving onset (%d-%d)",latency_range_moving(1),latency_range_moving(2))};

for group=1:numel(groupNames)
    latency_combined = [CS_times_to_max{group}, US_times_to_max{group}, freeze_times_to_max{group}, move_times_to_max{group}];
    writecell(header, latency_output_file, 'Sheet', groupNames{group}, 'Range', 'A1');
    writematrix(latency_combined, latency_output_file, 'Sheet', groupNames{group}, 'Range', 'A2');
end

X = categorical({'CS onset', 'US onset', 'Freezing onset', 'Moving onset'});
X = reordercats(X,{'CS onset', 'US onset', 'Freezing onset', 'Moving onset'});
Y = [cell2mat(mean_CS_times_to_max); cell2mat(mean_US_times_to_max); cell2mat(mean_freeze_times_to_max); cell2mat(mean_move_times_to_max)];
figure;
h = bar(X, Y); hold on;
errorbar(h(1).XEndPoints,[mean_CS_times_to_max{1}, mean_US_times_to_max{1}, mean_freeze_times_to_max{1}, mean_move_times_to_max{1}],[sem_CS_times_to_max{1}, sem_US_times_to_max{1}, sem_freeze_times_to_max{1}, sem_move_times_to_max{1}],'LineStyle','none','Color','k','LineWidth',2);
errorbar(h(2).XEndPoints,[mean_CS_times_to_max{2}, mean_US_times_to_max{2}, mean_freeze_times_to_max{2}, mean_move_times_to_max{2}],[sem_CS_times_to_max{2}, sem_US_times_to_max{2}, sem_freeze_times_to_max{2}, sem_move_times_to_max{2}],'LineStyle','none','Color','k','LineWidth',2);
scatter(repmat(h(1).XEndPoints(1), size(CS_times_to_max{1},1), 1),CS_times_to_max{1},60,'MarkerFaceColor',[0 0.4470 0.7410],'MarkerEdgeColor','k','LineWidth',1);
scatter(repmat(h(1).XEndPoints(2), size(US_times_to_max{1},1), 1),US_times_to_max{1},60,'MarkerFaceColor',[0 0.4470 0.7410],'MarkerEdgeColor','k','LineWidth',1);
scatter(repmat(h(1).XEndPoints(3), size(freeze_times_to_max{1},1), 1),freeze_times_to_max{1},60,'MarkerFaceColor',[0 0.4470 0.7410],'MarkerEdgeColor','k','LineWidth',1);
scatter(repmat(h(1).XEndPoints(4), size(move_times_to_max{1},1), 1),move_times_to_max{1},60,'MarkerFaceColor',[0 0.4470 0.7410],'MarkerEdgeColor','k','LineWidth',1);
scatter(repmat(h(2).XEndPoints(1), size(CS_times_to_max{2},1), 1),CS_times_to_max{2},60,'MarkerFaceColor',[0.8500 0.3250 0.0980],'MarkerEdgeColor','k','LineWidth',1);
scatter(repmat(h(2).XEndPoints(2), size(US_times_to_max{2},1), 1),US_times_to_max{2},60,'MarkerFaceColor',[0.8500 0.3250 0.0980],'MarkerEdgeColor','k','LineWidth',1);
scatter(repmat(h(2).XEndPoints(3), size(freeze_times_to_max{2},1), 1),freeze_times_to_max{2},60,'MarkerFaceColor',[0.8500 0.3250 0.0980],'MarkerEdgeColor','k','LineWidth',1);
scatter(repmat(h(2).XEndPoints(4), size(move_times_to_max{2},1), 1),move_times_to_max{2},60,'MarkerFaceColor',[0.8500 0.3250 0.0980],'MarkerEdgeColor','k','LineWidth',1);

legend(groupNames);
title('Time to max');