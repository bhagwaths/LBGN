activity = readtable('C:\Users\bhagwaths\Documents\F-Ret_activity_HB.xlsx');
[~, header] = xlsread('C:\Users\bhagwaths\Documents\F-Ret_activity_HB.xlsx');
cells = str2double(header(:,3:end));

group_info = readtable('Z:\Olena Bukalo\AS project\AS data\neurons\neurons 1p\final\F-Ret CS_responsivity.xlsx','Sheet','auc_diff_obs');

freezing_folder = 'E:\AS-Gq-hSyn-GRIN\VEH-CNO_fear_retrieval\FreezingOutput_processed';
freeze_threshold = 30;
move_threshold = 30;
FPS = 30;

num_CS = 5;
x_range = [-30,30];

animalNames = {
    'AS-Gq-hSyn-GRIN-5';
    'AS-Gq-hSyn-GRIN-6';
    'AS-Gq-hSyn-GRIN-7';
    'AS-Gq-hSyn-GRIN-8';
    % 'AS-Gq-hSyn-GRIN-9'; % not in F-Ret CS_responsivity.xlsx
    'AS-Gq-hSyn-GRIN-11';
    % 'AS-Gq-hSyn-GRIN-12'; % not in F-Ret CS_responsivity.xlsx
    'AS-Gq-hSyn-GRIN-13';
    'AS-Gq-hSyn-GRIN-14';
    'AS-Gq-hSyn-GRIN-15';
    'AS-Gq-hSyn-GRIN-17';
    'AS-Gq-hSyn-GRIN-18';
    'AS-Gq-hSyn-GRIN-20';
    'AS-Gq-hSyn-GRIN-21';
    'AS-Gq-hSyn-GRIN-22';
    'AS-Gq-hSyn-GRIN-23';
    'AS-Gq-hSyn-GRIN-24';
    'AS-Gq-hSyn-GRIN-25';
    'AS-Gq-hSyn-GRIN-26';
    'AS-Gq-hSyn-GRIN-27';
    'AS-Gq-hSyn-GRIN-28';
    'AS-Gq-hSyn-GRIN-29';
    'AS-Gq-hSyn-GRIN-30';
    'AS-Gq-hSyn-GRIN-31';
    'AS-Gq-hSyn-GRIN-32'};

groupNames = {'CNO-VEH'; 'VEH-CNO'; 'VEH-VEH'};

groups = {'VEH-CNO'; % 5
            'CNO-VEH'; % 6
            'CNO-VEH'; % 7
            'VEH-CNO'; % 8
            % 'VEH-CNO'; % 9 - not in F-Ret CS_responsivity.xlsx
            'VEH-VEH'; % 11
            % 'CNO-VEH'; % 12 - not in F-Ret CS_responsivity.xlsx
            'VEH-CNO'; % 13
            'VEH-VEH'; % 14
            'VEH-CNO'; % 15
            'VEH-VEH'; % 17
            'CNO-VEH'; % 18
            'VEH-VEH'; % 20
            'VEH-VEH'; % 21
            'VEH-CNO'; % 22
            'VEH-VEH'; % 23
            'CNO-VEH'; % 24
            'CNO-VEH'; % 25
            'VEH-VEH'; % 26
            'VEH-CNO'; % 27
            'CNO-VEH'; % 28
            'VEH-VEH'; % 29
            'VEH-CNO'; % 30
            'VEH-CNO'; % 31
            'CNO-VEH'}; % 32

activity_cut = activity(activity.aligned_time >= x_range(1) & activity.aligned_time <= x_range(2), :);

for group=1:numel(groupNames)
    numAnimals{group} = sum(strcmp(groups,groupNames{group}));
    cells_grouped{group} = group_info.cell_id(strcmp(group_info.group,groupNames{group}));
    select_cells_idx{group} = find(ismember(cells,cells_grouped{group}));
end

% Find average signal for each CS
mean_trial_traces = cell(1,numel(groupNames));
sem_trial_traces = cell(1,numel(groupNames));
for group=1:numel(groupNames)
    for i=0:num_CS-1
        curr_event = activity_cut(activity_cut.event_idx == i, :);
        curr_trace = table2array(curr_event(:, 3:end));
        curr_trace_grouped = curr_trace(:,select_cells_idx{group});
        mean_trial_trace = mean(curr_trace_grouped,2)';
        sem_trial_trace = (std(curr_trace_grouped,[],2) / sqrt(size(curr_trace_grouped,2)))';
    
        mean_trial_traces{group} = [mean_trial_traces{group}; mean_trial_trace];
        sem_trial_traces{group} = [sem_trial_traces{group}; sem_trial_trace];
    end
end

% Find freezing index for all mice and CS
CS_times = [0 60 120 180 240];
CS_ranges = cell(1,num_CS);
for i=1:numel(CS_times)
    CS_ranges{i} = [CS_times(i)+x_range(1) CS_times(i)+x_range(2)];
end

[idx, output_files] = read_output_files(animalNames, numel(animalNames), freezing_folder, '_FreezingOutput_processed.csv');

ts1 = cell(1,num_CS);

freeze_eps_combined = cell(1,numel(groupNames));
move_eps_combined = cell(1,numel(groupNames));

freeze_onset_list = cell(1,numel(groupNames));
freeze_offset_list = cell(1,numel(groupNames));
move_onset_list = cell(1,numel(groupNames));
move_offset_list = cell(1,numel(groupNames));

for group=1:numel(groupNames)
    freeze_eps_combined{group} = cell(1,num_CS);
    move_eps_combined{group} = cell(1,num_CS);

    freeze_onset_list{group} = cell(1,numel(animalNames));
    freeze_offset_list{group} = cell(1,numel(animalNames));
    move_onset_list{group} = cell(1,numel(animalNames));
    move_offset_list{group} = cell(1,numel(animalNames));
end

for mouse=1:numel(animalNames)

    group = find(strcmp(groups{mouse},groupNames));
    
    Frames = readmatrix(output_files{idx(mouse)}, 'Range', 'A:A', 'NumHeaderLines', 1);
    Freezing = readmatrix(output_files{idx(mouse)}, 'Range', 'B:B', 'NumHeaderLines', 1);
    
    freeze_onset_list{group}{mouse} = cell(1,num_CS);
    freeze_offset_list{group}{mouse} = cell(1,num_CS);
    move_onset_list{group}{mouse} = cell(1,num_CS);
    move_offset_list{group}{mouse} = cell(1,num_CS);

    for CS=1:numel(CS_ranges)
        ts1{CS} = linspace(CS_ranges{CS}(1),CS_ranges{CS}(2),size(mean_trial_traces{group},2));

        [freeze_onset_times, freeze_offset_times, move_onset_times, move_offset_times] = get_freeze_move_eps(Frames,...
                                 Freezing, freeze_threshold, move_threshold, FPS, CS_ranges{CS}(1), CS_ranges{CS}(2));

        freeze_onset_list{group}{mouse}{CS} = [freeze_onset_list{group}{mouse}{CS}, freeze_onset_times];
        freeze_offset_list{group}{mouse}{CS} = [freeze_offset_list{group}{mouse}{CS}, freeze_offset_times];
        move_onset_list{group}{mouse}{CS} = [move_onset_list{group}{mouse}{CS}, move_onset_times];
        move_offset_list{group}{mouse}{CS} = [move_offset_list{group}{mouse}{CS}, move_offset_times];

        if length(freeze_onset_times) ~= length(freeze_offset_times)
            if ~isempty(freeze_onset_times) && ~isempty(freeze_offset_times)
                if (freeze_offset_times(1) < freeze_onset_times(1))
                    freeze_onset_times = [CS_ranges{CS}(1) freeze_onset_times];
                end
                if (freeze_onset_times(end) > freeze_offset_times(end))
                    freeze_offset_times = [freeze_offset_times CS_ranges{CS}(2)];
                end
            end
            if (isempty(freeze_onset_times) && ~isempty(freeze_offset_times))
                freeze_onset_times = [CS_ranges{CS}(1) freeze_onset_times];
            end
            if (isempty(freeze_offset_times) && ~isempty(freeze_onset_times))
                freeze_offset_times = [freeze_offset_times CS_ranges{CS}(2)];
            end
        end
        
        if length(move_onset_times) ~= length(move_offset_times)
            if ~isempty(move_onset_times) && ~isempty(move_offset_times)
                if (move_offset_times(1) < move_onset_times(1))
                    move_onset_times = [CS_ranges{CS}(1) move_onset_times];
                end
                if (move_onset_times(end) > move_offset_times(end))
                    move_offset_times = [move_offset_times CS_ranges{CS}(2)];
                end
            end
            if (isempty(move_onset_times) && ~isempty(move_offset_times))
                move_onset_times = [CS_ranges{CS}(1) move_onset_times];
            end
            if (isempty(move_offset_times) && ~isempty(move_onset_times))
                move_offset_times = [move_offset_times CS_ranges{CS}(2)];
            end
        end
    
        freeze_eps = NaN(1, length(ts1{CS}));
        for i=1:length(freeze_onset_times)
            freeze_start = freeze_onset_times(i);
            freeze_end = freeze_offset_times(i);
            freeze_ep = find(ts1{CS} >= freeze_start & ts1{CS} <= freeze_end);
            freeze_eps(freeze_ep) = 0.1;
        end
        freeze_eps_combined{group}{CS} = [freeze_eps_combined{group}{CS}; freeze_eps];
    
        move_eps = NaN(1, length(ts1{CS}));
        for i=1:length(move_onset_times)
            move_start = move_onset_times(i);
            move_end = move_offset_times(i);
            move_ep = find(ts1{CS} >= move_start & ts1{CS} <= move_end);
            move_eps(move_ep) = 0.1;
        end
        move_eps_combined{group}{CS} = [move_eps_combined{group}{CS}; move_eps];
    end
end

for group=1:numel(groupNames)
    for CS=1:numel(CS_ranges)
        freeze_eps_sum{group}{CS} = sum(~isnan(freeze_eps_combined{group}{CS}));
        move_eps_sum{group}{CS} = sum(~isnan(move_eps_combined{group}{CS}));
        freeze_move_idx{group}{CS} = freeze_eps_sum{group}{CS} - move_eps_sum{group}{CS};
    end
end

% Individual CS
for group=1:numel(groupNames)
    for i=1:num_CS
        figure;
        plot(ts1{i}, mean_trial_traces{group}(i,:), 'Color', [0 0.4470 0.7410], 'LineWidth', 2); hold on;
        errorplot3(mean_trial_traces{group}(i,:)-sem_trial_traces{group}(i,:), mean_trial_traces{group}(i,:)+sem_trial_traces{group}(i,:), CS_ranges{i}, [0 0.4470 0.7410], 0.3); hold on;
        num_scores = 2*numAnimals{group} + 1;
        possible_scores = -numAnimals{group}:numAnimals{group};
        cmap = colormap(jet(num_scores));
        for score=1:num_scores
            color = NaN(1,length(ts1{i}));
            color_idx = freeze_move_idx{group}{i} == possible_scores(score);
            color(color_idx) = 0.1;
            plot(ts1{i}, color, 'LineWidth', 3, 'Color', cmap(possible_scores(score)+numAnimals{group}+1,:), 'Marker', '_'); hold on;
        end
        xline(CS_times(i),'-',{'CS'});
        colorbar;
        clim([-numAnimals{group}, numAnimals{group}]);
        title(sprintf('CS %d (%s)', i, groupNames{group}));
    end
end

% Combined CS
for group=1:numel(groupNames)
    freeze_move_idx_sum{group} = sum(cell2mat(freeze_move_idx{group}'));
    mean_mean_trial_traces = mean(mean_trial_traces{group},1);
    sem_sem_trial_traces = [];
    for i=1:size(sem_trial_traces{group},2)
        sem_sem_trial_traces(:,i) = propagate_error(sem_trial_traces{group}(:,i));
    end
    figure;
    plot(ts1{1}, mean_mean_trial_traces, 'Color', [0 0.4470 0.7410], 'LineWidth', 2); hold on;
    errorplot3(mean_mean_trial_traces-sem_sem_trial_traces, mean_mean_trial_traces+sem_sem_trial_traces, x_range, [0 0.4470 0.7410], 0.3); hold on;
    
    num_scores = (2*numAnimals{group})*num_CS + 1;
    possible_scores = (-numAnimals{group}*num_CS):(numAnimals{group}*num_CS);
    cmap = colormap(jet(num_scores));
    for score=1:num_scores
        color = NaN(1,length(ts1{1}));
        color_idx = freeze_move_idx_sum{group} == possible_scores(score);
        color(color_idx) = 0.1;
        plot(ts1{1}, color, 'LineWidth', 3, 'Color', cmap(possible_scores(score)+(numAnimals{group}*num_CS)+1,:), 'Marker', '_'); hold on;
    end
    xline(0,'-',{'CS'});
    colorbar;
    clim([-numAnimals{group}*num_CS, numAnimals{group}*num_CS]);
    title(sprintf('CS 1-%d (%s)', num_CS, groupNames{group}));
end

% Average freezing and moving onset activity

freeze_plot_range = [-5,5]; % must be within x_range
signal_range = [0,30]; % only freezing/moving events in this time range are considered

plot_labels = {{'Freeze', 'Onset'};
               {'Freeze', 'Offset'};
               {'Move', 'Onset'};
               {'Move', 'Offset'}};

[freeze_onset_mean, freeze_onset_sem, freeze_onset_comb_mean, freeze_onset_comb_sem] = freeze_move_plot(freeze_onset_list,...
    animalNames,CS_times,signal_range,freeze_plot_range,ts1,mean_trial_traces,sem_trial_traces,plot_labels{1},num_CS,groupNames,groups);
[freeze_offset_mean, freeze_offset_sem, freeze_offset_comb_mean, freeze_offset_comb_sem] = freeze_move_plot(freeze_offset_list,...
    animalNames,CS_times,signal_range,freeze_plot_range,ts1,mean_trial_traces,sem_trial_traces,plot_labels{2},num_CS,groupNames,groups);
[move_onset_mean, move_onset_sem, move_onset_comb_mean, move_onset_comb_sem] = freeze_move_plot(move_onset_list,...
    animalNames,CS_times,signal_range,freeze_plot_range,ts1,mean_trial_traces,sem_trial_traces,plot_labels{3},num_CS,groupNames,groups);
[move_offset_mean, move_offset_sem,  move_offset_comb_mean, move_offset_comb_sem] = freeze_move_plot(move_offset_list,...
    animalNames,CS_times,signal_range,freeze_plot_range,ts1,mean_trial_traces,sem_trial_traces,plot_labels{4},num_CS,groupNames,groups);

function [signal_mean, signal_sem, signal_combined_mean, signal_sem_combined_sem] = freeze_move_plot(freeze_move_list,animalNames,...
    CS_times,signal_range,freeze_plot_range,ts1,mean_trial_traces,sem_trial_traces,plot_label,num_CS,groupNames,groups)
    CS_curr_signal = cell(1,numel(groupNames));
    CS_curr_sem = cell(1,numel(groupNames));
    for group=1:numel(groupNames)
        for CS=1:num_CS
            CS_curr_signal{group}{CS} = [];
            CS_curr_sem{group}{CS} = [];
        end
    end
    for mouse=1:numel(animalNames)
        group = find(strcmp(groups{mouse},groupNames));
        for CS=1:num_CS
            for i=1:size(freeze_move_list{group}{mouse}{CS},2)
                curr_time = freeze_move_list{group}{mouse}{CS}(i);
                if curr_time >= CS_times(CS)+signal_range(1)-freeze_plot_range(1) && curr_time <= CS_times(CS)+signal_range(2)-freeze_plot_range(2)
                    ep_start = curr_time+freeze_plot_range(1);
                    ep_end = curr_time+freeze_plot_range(2);
                    [~, start_idx] = min(abs(ts1{CS}-ep_start));
                    [~, end_idx] = min(abs(ts1{CS}-ep_end));
                    trial_trace = mean_trial_traces{group}(CS,:);
                    trial_sem = sem_trial_traces{group}(CS,:);
                    curr_signal = trial_trace(start_idx:end_idx);
                    curr_sem = trial_sem(start_idx:end_idx);
                    CS_curr_signal{group}{CS} = add_adj_vector(CS_curr_signal{group}{CS}, curr_signal);
                    CS_curr_sem{group}{CS} = add_adj_vector(CS_curr_sem{group}{CS}, curr_sem);
                end
            end
        end
    end
  
    signal_combined = cell(1,numel(groupNames));
    signal_sem_combined = cell(1,numel(groupNames));
    for group=1:numel(groupNames)
        for CS=1:num_CS
            signal_sem{group}{CS} = [];
            signal_mean{group}{CS} = mean(CS_curr_signal{group}{CS},1);
            signal_combined{group} = [signal_combined{group}; CS_curr_signal{group}{CS}];
            signal_sem_combined{group} = [signal_sem_combined{group}; CS_curr_sem{group}{CS}];
            for i=1:size(CS_curr_sem{group}{CS},2)
                signal_sem{group}{CS} = [signal_sem{group}{CS}, propagate_error(CS_curr_sem{group}{CS}(:,i))];
            end
            figure;
            plot(linspace(-5,5,size(signal_mean{group}{CS},2)), signal_mean{group}{CS}, 'Color', [0 0.4470 0.7410], 'LineWidth', 2); hold on;
            errorplot3(signal_mean{group}{CS}-signal_sem{group}{CS}, signal_mean{group}{CS}+signal_sem{group}{CS}, [-5,5], [0 0.4470 0.7410], 0.3); hold on;
            xline(0,'-',plot_label);
            title(sprintf('CS %d (%s)', CS, groupNames{group}));
        end
    end

    for group=1:numel(groupNames)
        signal_combined_mean{group} = mean(signal_combined{group},1);
        signal_sem_combined_sem{group} = [];
        for i=1:size(signal_sem_combined{group},2)
            signal_sem_combined_sem{group} = [signal_sem_combined_sem{group} propagate_error(signal_sem_combined{group}(:,i))]; 
        end
        figure;
        plot(linspace(-5,5,size(signal_combined_mean{group},2)), signal_combined_mean{group}, 'Color', [0 0.4470 0.7410], 'LineWidth', 2); hold on;
        errorplot3(signal_combined_mean{group}-signal_sem_combined_sem{group}, signal_combined_mean{group}+signal_sem_combined_sem{group}, [-5,5], [0 0.4470 0.7410], 0.3); hold on;
        xline(0,'-',plot_label); hold on;
        title(sprintf('CS 1-%d (%s)', num_CS, groupNames{group}));
    end
end