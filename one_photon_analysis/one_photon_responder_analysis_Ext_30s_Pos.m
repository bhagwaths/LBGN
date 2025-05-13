early_filename_5s = 'Y:\Olena Bukalo\AS project\AS data\neurons\neurons 1p\HB data\E-Ext_CS_traces_and_responses.xlsx';
late_filename_5s = 'Y:\Olena Bukalo\AS project\AS data\neurons\neurons 1p\HB data\L-Ext_CS_traces_and_responses.xlsx';

early_filename_30s = 'Y:\Olena Bukalo\AS project\AS data\neurons\neurons 1p\final\E-Ext_activity_HB.xlsx';
late_filename_30s = 'Y:\Olena Bukalo\AS project\AS data\neurons\neurons 1p\final\L-Ext_activity_HB.xlsx';

groups = {'VEH-VEH', 'VEH-CNO'};
plot_colors = {[0 0.4470 0.7410]; [0.8500 0.3250 0.0980]};
perm_test_color = [0.4660 0.6740 0.1880];

sig = .05;
consec_thresh = 3.3;

early_auc = readtable(early_filename_5s, 'Sheet', 'auc_diff_obs');
early_auc.cell_id = str2double(early_auc.cell_id);
early_trace_30s = readtable(early_filename_30s, 'Sheet', 'aligned_traces');
early_trace_30s_mean = [];
for i=1:5:height(early_trace_30s)
    curr_mean = mean(early_trace_30s(i:i+4, :), 1);
    early_trace_30s_mean = [early_trace_30s_mean; curr_mean];
end
early_time_30s = early_trace_30s_mean.aligned_time;
early_trace_30s_mean.event_idx = [];
early_trace_30s_mean.aligned_time = [];
early_cells_30s = str2double(erase(early_trace_30s_mean.Properties.VariableNames,'x'));

late_auc = readtable(late_filename_5s, 'Sheet', 'auc_diff_obs');
late_auc.cell_id = str2double(late_auc.cell_id);
late_trace_30s = readtable(late_filename_30s, 'Sheet', 'aligned_traces');
late_trace_30s_mean = [];
for i=1:5:height(late_trace_30s)
    curr_mean = mean(late_trace_30s(i:i+4, :), 1);
    late_trace_30s_mean = [late_trace_30s_mean; curr_mean];
end
late_time_30s = late_trace_30s_mean.aligned_time;
late_trace_30s_mean.event_idx = [];
late_trace_30s_mean.aligned_time = [];
late_cells_30s = str2double(erase(late_trace_30s_mean.Properties.VariableNames,'x'));

% remove negatively modulated neurons
early_auc = early_auc(~(early_auc.post_sub_pre < 0 & early_auc.p_val <= 0.05), :);
late_auc = late_auc(~(late_auc.post_sub_pre < 0 & late_auc.p_val <= 0.05), :);

shared_cells_5s_temp = early_auc.cell_id(ismember(early_auc.cell_id, late_auc.cell_id))'; % shared btwn early and late 5s files
shared_cells_30s_temp = early_cells_30s(ismember(early_cells_30s, late_cells_30s)); % shared btwn early and late 30s files
shared_cells = shared_cells_30s_temp(ismember(shared_cells_30s_temp, shared_cells_5s_temp)); % shared btwn 5s and 30s files

for i=1:numel(groups)
    early_auc_grouped{i} = early_auc(strcmp(early_auc.group,groups{i}),:);
    early_auc_grouped{i} = early_auc_grouped{i}(ismember(early_auc_grouped{i}.cell_id, shared_cells),:);

    late_auc_grouped{i} = late_auc(strcmp(late_auc.group,groups{i}),:);
    late_auc_grouped{i} = late_auc_grouped{i}(ismember(late_auc_grouped{i}.cell_id, shared_cells),:);

    early_auc_fear{i} = early_auc_grouped{i}(early_auc_grouped{i}.p_val <= 0.05 & late_auc_grouped{i}.p_val > 0.05, :);
    late_auc_fear{i} = late_auc_grouped{i}(early_auc_grouped{i}.p_val <= 0.05 & late_auc_grouped{i}.p_val > 0.05, :);

    early_auc_ext{i} = early_auc_grouped{i}(early_auc_grouped{i}.p_val > 0.05 & late_auc_grouped{i}.p_val <= 0.05, :);
    late_auc_ext{i} = late_auc_grouped{i}(early_auc_grouped{i}.p_val > 0.05 & late_auc_grouped{i}.p_val <= 0.05, :);

    early_auc_ext_rst{i} = early_auc_grouped{i}(early_auc_grouped{i}.p_val <= 0.05 & late_auc_grouped{i}.p_val <= 0.05, :);
    late_auc_ext_rst{i} = late_auc_grouped{i}(early_auc_grouped{i}.p_val <= 0.05 & late_auc_grouped{i}.p_val <= 0.05, :);

    early_auc_nr{i} = early_auc_grouped{i}(early_auc_grouped{i}.p_val > 0.05 & late_auc_grouped{i}.p_val > 0.05, :);
    late_auc_nr{i} = late_auc_grouped{i}(early_auc_grouped{i}.p_val > 0.05 & late_auc_grouped{i}.p_val > 0.05, :);
end

% PLOT AVERAGE TRACES FOR EACH GROUP (EARLY AND LATE)

% Fear
figure; hold on;
title('Fear neurons, first 5 CS'); hold on;
y = 1.9;
for i=1:numel(groups)
    early_fear_trace{i} = table2array(early_trace_30s_mean(:,ismember(early_cells_30s,early_auc_fear{i}.cell_id)));
    mean_early_fear_trace{i} = mean(early_fear_trace{i}',1);
    sem_early_fear_trace{i} = std(early_fear_trace{i}',[],1) / sqrt(size(early_fear_trace{i}',1));
    bCI_early_fear{i} = bootstrapping(early_fear_trace{i}', sig, consec_thresh, y-(i*0.1));

    plot(early_time_30s, mean_early_fear_trace{i}, 'LineWidth', 2, 'Color', plot_colors{i}); hold on;
    errorplot3(mean_early_fear_trace{i}-sem_early_fear_trace{i}, mean_early_fear_trace{i}+sem_early_fear_trace{i}, [early_time_30s(1) early_time_30s(end)], plot_colors{i}, .15); hold on;
    plot(early_time_30s,bCI_early_fear{i},'Color',plot_colors{i},'LineWidth',2); hold on;
    ylim([-0.5, 2]); hold on;
end

if numel(groups)==2
    perm_early_fear = permutation_test(early_fear_trace{1}', early_fear_trace{2}', sig, consec_thresh, y);
    plot(early_time_30s,perm_early_fear,'Color',perm_test_color,'LineWidth', 2);
end

figure; hold on;
title('Fear neurons, last 5 CS'); hold on;
y = 1.9;
for i=1:numel(groups)
    late_fear_trace{i} = table2array(late_trace_30s_mean(:,ismember(late_cells_30s,late_auc_fear{i}.cell_id)));
    mean_late_fear_trace{i} = mean(late_fear_trace{i}',1);
    sem_late_fear_trace{i} = std(late_fear_trace{i}',[],1) / sqrt(size(late_fear_trace{i}',1));
    bCI_late_fear{i} = bootstrapping(late_fear_trace{i}', sig, consec_thresh, y-(i*0.1));

    plot(late_time_30s, mean_late_fear_trace{i}, 'LineWidth', 2, 'Color', plot_colors{i}); hold on;
    errorplot3(mean_late_fear_trace{i}-sem_late_fear_trace{i}, mean_late_fear_trace{i}+sem_late_fear_trace{i}, [late_time_30s(1) late_time_30s(end)], plot_colors{i}, .15); hold on;
    plot(late_time_30s,bCI_late_fear{i},'Color',plot_colors{i},'LineWidth',2); hold on;
    ylim([-0.5, 2]); hold on;
end

if numel(groups)==2
    perm_late_fear = permutation_test(late_fear_trace{1}', late_fear_trace{2}', sig, consec_thresh, y);
    plot(late_time_30s,perm_late_fear,'Color',perm_test_color,'LineWidth', 2);
end

% Ext
figure; hold on;
title('Extinction neurons, first 5 CS'); hold on;
y = 1.9;
for i=1:numel(groups)
    early_ext_trace{i} = table2array(early_trace_30s_mean(:,ismember(early_cells_30s,early_auc_ext{i}.cell_id)));
    mean_early_ext_trace{i} = mean(early_ext_trace{i}',1);
    sem_early_ext_trace{i} = std(early_ext_trace{i}',[],1) / sqrt(size(early_ext_trace{i}',1));
    bCI_early_ext{i} = bootstrapping(early_ext_trace{i}', sig, consec_thresh, y-(i*0.1));

    plot(early_time_30s, mean_early_ext_trace{i}, 'LineWidth', 2, 'Color', plot_colors{i}); hold on;
    errorplot3(mean_early_ext_trace{i}-sem_early_ext_trace{i}, mean_early_ext_trace{i}+sem_early_ext_trace{i}, [early_time_30s(1) early_time_30s(end)], plot_colors{i}, .15); hold on;
    plot(early_time_30s,bCI_early_ext{i},'Color',plot_colors{i},'LineWidth',2); hold on;
    ylim([-0.5, 2]); hold on;
end

if numel(groups)==2
    perm_early_ext = permutation_test(early_ext_trace{1}', early_ext_trace{2}', sig, consec_thresh, y);
    plot(early_time_30s,perm_early_ext,'Color',perm_test_color,'LineWidth', 2);
end

figure; hold on;
title('Extinction neurons, last 5 CS'); hold on;
y = 1.9;
for i=1:numel(groups)
    late_ext_trace{i} = table2array(late_trace_30s_mean(:,ismember(late_cells_30s,late_auc_ext{i}.cell_id)));
    mean_late_ext_trace{i} = mean(late_ext_trace{i}',1);
    sem_late_ext_trace{i} = std(late_ext_trace{i}',[],1) / sqrt(size(late_ext_trace{i}',1));
    bCI_late_ext{i} = bootstrapping(late_ext_trace{i}', sig, consec_thresh, y-(i*0.1));

    plot(late_time_30s, mean_late_ext_trace{i}, 'LineWidth', 2, 'Color', plot_colors{i}); hold on;
    errorplot3(mean_late_ext_trace{i}-sem_late_ext_trace{i}, mean_late_ext_trace{i}+sem_late_ext_trace{i}, [late_time_30s(1) late_time_30s(end)], plot_colors{i}, .15); hold on;
    plot(late_time_30s,bCI_late_ext{i},'Color',plot_colors{i},'LineWidth',2); hold on;
    ylim([-0.5, 2]); hold on;
end

if numel(groups)==2
    perm_late_ext = permutation_test(late_ext_trace{1}', late_ext_trace{2}', sig, consec_thresh, y);
    plot(late_time_30s,perm_late_ext,'Color',perm_test_color,'LineWidth', 2);
end

% Ext-Rst
figure; hold on;
title('Ext-resistant neurons, first 5 CS'); hold on;
y = 3.4;
for i=1:numel(groups)
    early_ext_rst_trace{i} = table2array(early_trace_30s_mean(:,ismember(early_cells_30s,early_auc_ext_rst{i}.cell_id)));
    mean_early_ext_rst_trace{i} = mean(early_ext_rst_trace{i}',1);
    sem_early_ext_rst_trace{i} = std(early_ext_rst_trace{i}',[],1) / sqrt(size(early_ext_rst_trace{i}',1));
    if size(early_ext_rst_trace{i},2) >= 3
        bCI_early_ext_rst{i} = bootstrapping(early_ext_rst_trace{i}', sig, consec_thresh, y-(i*0.1));
    end

    plot(early_time_30s, mean_early_ext_rst_trace{i}, 'LineWidth', 2, 'Color', plot_colors{i}); hold on;
    errorplot3(mean_early_ext_rst_trace{i}-sem_early_ext_rst_trace{i}, mean_early_ext_rst_trace{i}+sem_early_ext_rst_trace{i}, [early_time_30s(1) early_time_30s(end)], plot_colors{i}, .15); hold on;
    if size(early_ext_rst_trace{i},2) >= 3
        plot(early_time_30s,bCI_early_ext_rst{i},'Color',plot_colors{i},'LineWidth',2); hold on;
    end
    ylim([-0.5, 3.5]); hold on;
end

if numel(groups)==2
    perm_early_ext_rst = permutation_test(early_ext_rst_trace{1}', early_ext_rst_trace{2}', sig, consec_thresh, y);
    plot(early_time_30s,perm_early_ext_rst,'Color',perm_test_color,'LineWidth', 2);
end

figure; hold on;
title('Ext-resistant neurons, last 5 CS'); hold on;
y = 3.4;
for i=1:numel(groups)
    late_ext_rst_trace{i} = table2array(late_trace_30s_mean(:,ismember(late_cells_30s,late_auc_ext_rst{i}.cell_id)));
    mean_late_ext_rst_trace{i} = mean(late_ext_rst_trace{i}',1);
    sem_late_ext_rst_trace{i} = std(late_ext_rst_trace{i}',[],1) / sqrt(size(late_ext_rst_trace{i}',1));
    if size(late_ext_rst_trace{i},2) >= 3
        bCI_late_ext_rst{i} = bootstrapping(late_ext_rst_trace{i}', sig, consec_thresh, y-(i*0.1));
    end

    plot(late_time_30s, mean_late_ext_rst_trace{i}, 'LineWidth', 2, 'Color', plot_colors{i}); hold on;
    errorplot3(mean_late_ext_rst_trace{i}-sem_late_ext_rst_trace{i}, mean_late_ext_rst_trace{i}+sem_late_ext_rst_trace{i}, [late_time_30s(1) late_time_30s(end)], plot_colors{i}, .15); hold on;
    if size(late_ext_rst_trace{i},2) >= 3
        plot(late_time_30s,bCI_late_ext_rst{i},'Color',plot_colors{i},'LineWidth',2); hold on;
    end
    ylim([-0.5, 3.5]); hold on;
end

if numel(groups)==2
    perm_late_ext_rst = permutation_test(late_ext_rst_trace{1}', late_ext_rst_trace{2}', sig, consec_thresh, y);
    plot(late_time_30s,perm_late_ext_rst,'Color',perm_test_color,'LineWidth', 2);
end

% NR
figure; hold on;
title('Non-responsive neurons, first 5 CS'); hold on;
y = 1.9;
for i=1:numel(groups)
    early_nr_trace{i} = table2array(early_trace_30s_mean(:,ismember(early_cells_30s,early_auc_nr{i}.cell_id)));
    mean_early_nr_trace{i} = mean(early_nr_trace{i}',1);
    sem_early_nr_trace{i} = std(early_nr_trace{i}',[],1) / sqrt(size(early_nr_trace{i}',1));
    bCI_early_nr{i} = bootstrapping(early_nr_trace{i}', sig, consec_thresh, y-(i*0.1));

    plot(early_time_30s, mean_early_nr_trace{i}, 'LineWidth', 2, 'Color', plot_colors{i}); hold on;
    errorplot3(mean_early_nr_trace{i}-sem_early_nr_trace{i}, mean_early_nr_trace{i}+sem_early_nr_trace{i}, [early_time_30s(1) early_time_30s(end)], plot_colors{i}, .15); hold on;
    plot(early_time_30s,bCI_early_nr{i},'Color',plot_colors{i},'LineWidth',2); hold on;
    ylim([-0.5, 2]); hold on;
end

if numel(groups)==2
    perm_early_nr = permutation_test(early_nr_trace{1}', early_nr_trace{2}', sig, consec_thresh, y);
    plot(early_time_30s,perm_early_nr,'Color',perm_test_color,'LineWidth', 2);
end

figure; hold on;
title('Non-responsive neurons, last 5 CS'); hold on;
y = 1.9;
for i=1:numel(groups)
    late_nr_trace{i} = table2array(late_trace_30s_mean(:,ismember(late_cells_30s,late_auc_nr{i}.cell_id)));
    mean_late_nr_trace{i} = mean(late_nr_trace{i}',1);
    sem_late_nr_trace{i} = std(late_nr_trace{i}',[],1) / sqrt(size(late_nr_trace{i}',1));
    bCI_late_nr{i} = bootstrapping(late_nr_trace{i}', sig, consec_thresh, y-(i*0.1));

    plot(late_time_30s, mean_late_nr_trace{i}, 'LineWidth', 2, 'Color', plot_colors{i}); hold on;
    errorplot3(mean_late_nr_trace{i}-sem_late_nr_trace{i}, mean_late_nr_trace{i}+sem_late_nr_trace{i}, [late_time_30s(1) late_time_30s(end)], plot_colors{i}, .15); hold on;
    plot(late_time_30s,bCI_late_nr{i},'Color',plot_colors{i},'LineWidth',2); hold on;
    ylim([-0.5, 2]); hold on;
end

if numel(groups)==2
    perm_late_nr = permutation_test(late_nr_trace{1}', late_nr_trace{2}', sig, consec_thresh, y);
    plot(late_time_30s,perm_late_nr,'Color',perm_test_color,'LineWidth', 2);
end

% HEATMAP (EARLY AND LATE)
% 1. Fear
% 2. Ext
% 3. Ext-Rst
% 4. Non-resp

for i=1:numel(groups)
    early_trace_combined{i} = [early_fear_trace{i}'; early_ext_trace{i}'; early_ext_rst_trace{i}'; early_nr_trace{i}'];
    late_trace_combined{i} = [late_fear_trace{i}'; late_ext_trace{i}'; late_ext_rst_trace{i}'; late_nr_trace{i}'];

    figure;
    imagesc(early_time_30s', 1, early_trace_combined{i});
    colormap('jet');
    title(sprintf('%s, first 5 CS', groups{i}));
    colorbar;
    clim([-0.5, 3.5]);

    figure;
    imagesc(late_time_30s', 1, late_trace_combined{i});
    colormap('jet');
    title(sprintf('%s, last 5 CS', groups{i}));
    colorbar;
    clim([-0.5, 3.5]);
end

% PIE CHART: Non-resp, Ext, Ext-Rst, Fear

figure;
tiledlayout(1,numel(groups));
for i=1:numel(groups)
    num_cells_fear{i} = size(early_fear_trace{i},2);
    num_cells_ext{i} = size(early_ext_trace{i},2);
    num_cells_ext_rst{i} = size(early_ext_rst_trace{i},2);
    num_cells_nr{i} = size(early_nr_trace{i},2);

    clusters = ["Non-resp", "Fear", "Ext", "ExtResist"];
    counts = [num_cells_nr{i}, num_cells_fear{i}, num_cells_ext{i}, num_cells_ext_rst{i}];
    tbl = table(clusters, counts);

    nexttile
    piechart(tbl, "counts", "clusters");
    title(groups{i});
end