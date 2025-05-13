trace_input = 'E:\F-Ret_activity_mean.xlsx';

groups = {'VEH-CNO', 'CNO-VEH'};

threshold = 1; % -threshold < AUC_diff in non-responsive cells < threshold

output_filename = 'one_photon_responder_analysis.xlsx'; % trace for each cell by cluster

% Read Ca2+ data
for i=1:numel(groups)
    trace_data{i} = xlsread(trace_input,sprintf('%s_average_traces', groups{i})); %#ok<*SAGROW>
    cell_id{i} = trace_data{i}(2:end,1);
    trace{i} = trace_data{i}(2:end,2:end);
    time{i} = trace_data{i}(1,2:end);
end

% Find AUC_base and AUC_30s and their difference (AUC_diff = AUC_30s - AUC_base)
for i=1:numel(groups)
    AUC_base{i} = [];
    AUC_30s{i} = [];
    AUC_diff{i} = [];
    for j=1:size(trace{i},1)
        curr_AUC_base = trapz((time{i}(time{i} >= -5 & time{i} < 0)), trace{i}(j,time{i} >= -5 & time{i} < 0));
        AUC_base{i} = [AUC_base{i}; curr_AUC_base];
        curr_AUC_30s = trapz((time{i}(time{i} >= 0 & time{i} < 30)), trace{i}(j,time{i} >= 0 & time{i} < 30)) / 6;
        AUC_30s{i} = [AUC_30s{i}; curr_AUC_30s];
        AUC_diff{i} = [AUC_diff{i}; curr_AUC_30s - curr_AUC_base];
    end
end

% Sort cells into groups: non-responsive, negative, and positive
for i=1:numel(groups)
    nr_idx = find(AUC_diff{i} > -threshold & AUC_diff{i} < threshold);
    neg_idx = find(AUC_diff{i} <= -threshold);
    pos_idx = find(AUC_diff{i} >= threshold);
    cells_nr{i} = cell_id{i}(nr_idx);
    cells_neg{i} = cell_id{i}(neg_idx);
    cells_pos{i} = cell_id{i}(pos_idx);
    trace_nr{i} = trace{i}(nr_idx,:);
    trace_neg{i} = trace{i}(neg_idx,:);
    trace_pos{i} = trace{i}(pos_idx,:);
end

% Permutation test
sig = .05;
consec_thresh = 3.3;

perm_nr = permutation_test(trace_nr{1},trace_nr{2},sig,consec_thresh,0.2);
perm_neg = permutation_test(trace_neg{1},trace_neg{2},sig,consec_thresh,0.6);
perm_pos = permutation_test(trace_pos{1},trace_pos{2},sig,consec_thresh,0.65);

% Bootstrapping
sig = .05;
consec_thresh = 3.3;

bCI_nr{1} = bootstrapping(trace_nr{1},sig,consec_thresh,0.25);
bCI_neg{1} = bootstrapping(trace_neg{1},sig,consec_thresh,0.65);
bCI_pos{1} = bootstrapping(trace_pos{1},sig,consec_thresh,0.7);

bCI_nr{2} = bootstrapping(trace_nr{2},sig,consec_thresh,0.3);
bCI_neg{2} = bootstrapping(trace_neg{2},sig,consec_thresh,0.7);
bCI_pos{2} = bootstrapping(trace_pos{2},sig,consec_thresh,0.75);

% Plot mean traces for each group
plot_colors = {[0 0.4470 0.7410]; [0.8500 0.3250 0.0980]};
for i=1:numel(groups)
    figure(1);
    mean_trace_nr{i} = mean(trace_nr{i},1);
    sem_trace_nr{i} = std(trace_nr{i},[],1) / sqrt(size(trace_nr{i},1));
    plot(time{i},mean_trace_nr{i},'LineWidth',1.5,'Color',plot_colors{i}); hold on;
    errorplot3(mean_trace_nr{i}-sem_trace_nr{i}, mean_trace_nr{i}+sem_trace_nr{i}, [time{i}(1) time{i}(end)], plot_colors{i},0.3); hold on;
    title('Non-responsive'); hold on;
    plot(time{i},bCI_nr{i},'Color',plot_colors{i},'LineWidth',2);
    if i==2
        plot(time{i},perm_nr,'Color',[0.4660 0.6740 0.1880],'LineWidth', 2);
    end

    figure(2);
    mean_trace_neg{i} = mean(trace_neg{i},1);
    sem_trace_neg{i} = std(trace_neg{i},[],1) / sqrt(size(trace_neg{i},1));
    plot(time{i},mean_trace_neg{i},'LineWidth',1.5,'Color',plot_colors{i}); hold on;
    errorplot3(mean_trace_neg{i}-sem_trace_neg{i}, mean_trace_neg{i}+sem_trace_neg{i}, [time{i}(1) time{i}(end)], plot_colors{i},0.3); hold on;
    title('Negative');
    plot(time{i},bCI_neg{i},'Color',plot_colors{i},'LineWidth',2);
    if i==2
        hold on;
        plot(time{i},perm_neg,'Color',[0.4660 0.6740 0.1880],'LineWidth', 2);
    end

    figure(3);
    mean_trace_pos{i} = mean(trace_pos{i},1);
    sem_trace_pos{i} = std(trace_pos{i},[],1) / sqrt(size(trace_pos{i},1));
    plot(time{i},mean_trace_pos{i},'LineWidth',1.5,'Color',plot_colors{i}); hold on;
    errorplot3(mean_trace_pos{i}-sem_trace_pos{i}, mean_trace_pos{i}+sem_trace_pos{i}, [time{i}(1) time{i}(end)], plot_colors{i},0.3); hold on;
    title('Positive');
    plot(time{i},bCI_pos{i},'Color',plot_colors{i},'LineWidth',2);
    if i==2
        hold on;
        plot(time{i},perm_pos,'Color',[0.4660 0.6740 0.1880],'LineWidth', 2);
    end
end

% Write grouped cells and traces to Excel
for i=1:numel(groups)
    writematrix(time{i},output_filename,'Sheet',sprintf('%s_nr',groups{i}),'Range','B1');
    writematrix(cells_nr{i},output_filename,'Sheet',sprintf('%s_nr',groups{i}),'Range','A2');
    writematrix(trace_nr{i},output_filename,'Sheet',sprintf('%s_nr',groups{i}),'Range','B2');

    writematrix(time{i},output_filename,'Sheet',sprintf('%s_neg',groups{i}),'Range','B1');
    writematrix(cells_neg{i},output_filename,'Sheet',sprintf('%s_neg',groups{i}),'Range','A2');
    writematrix(trace_neg{i},output_filename,'Sheet',sprintf('%s_neg',groups{i}),'Range','B2');

    writematrix(time{i},output_filename,'Sheet',sprintf('%s_pos',groups{i}),'Range','B1');
    writematrix(cells_pos{i},output_filename,'Sheet',sprintf('%s_pos',groups{i}),'Range','A2');
    writematrix(trace_pos{i},output_filename,'Sheet',sprintf('%s_pos',groups{i}),'Range','B2');

    writecell({'-5-0s','0-30s','diff'},output_filename,'Sheet',sprintf('%s_AUC',groups{i}),'Range','B1');
    writematrix(cell_id{i},output_filename,'Sheet',sprintf('%s_AUC',groups{i}),'Range','A2');
    writematrix([AUC_base{i} AUC_30s{i} AUC_diff{i}],output_filename,'Sheet',sprintf('%s_AUC',groups{i}),'Range','B2');
end

% Store mean and AUC signal for nr, neg and pos (each cell) in table for pre, t1, t2, and t3.

for i=1:numel(groups)
    pre = find(time{i} >= -5 & time{i} < 0);
    t1 = find(time{i} >= 0 & time{i} < 10);
    t2 = find(time{i} >= 10 & time{i} < 20);
    t3 = find(time{i} >= 20 & time{i} < 30);

    Header = {'cell_id', '-5-0s', '0-10s', '10-20s', '20-30s'};

    % POS
    trace_pos_pre{i} = trace_pos{i}(:,pre);
    trace_pos_t1{i} = trace_pos{i}(:,t1);
    trace_pos_t2{i} = trace_pos{i}(:,t2);
    trace_pos_t3{i} = trace_pos{i}(:,t3);

    % pre
    mean_trace_pos_pre_by_cell{i} = mean(trace_pos_pre{i},2);
    sd_trace_pos_pre_by_cell{i} = std(trace_pos_pre{i},[],2);
    sem_trace_pos_pre_by_cell{i} = std(trace_pos_pre{i},[],2) / sqrt(size(trace_pos_pre{i},2));

    for j=1:size(trace_pos_pre{i},1)
        AUC_trace_pos_pre_by_cell{i}(j,:) = trapz(time{i}(pre),trace_pos_pre{i}(j,:));
    end

    % t1
    mean_trace_pos_t1_by_cell{i} = mean(trace_pos_t1{i},2);
    sd_trace_pos_t1_by_cell{i} = std(trace_pos_t1{i},[],2);
    sem_trace_pos_t1_by_cell{i} = std(trace_pos_t1{i},[],2) / sqrt(size(trace_pos_t1{i},2));

    for j=1:size(trace_pos_t1{i},1)
        AUC_trace_pos_t1_by_cell{i}(j,:) = trapz(time{i}(t1),trace_pos_t1{i}(j,:));
    end

    % t2
    mean_trace_pos_t2_by_cell{i} = mean(trace_pos_t2{i},2);
    sd_trace_pos_t2_by_cell{i} = std(trace_pos_t2{i},[],2);
    sem_trace_pos_t2_by_cell{i} = std(trace_pos_t2{i},[],2) / sqrt(size(trace_pos_t2{i},2));

    for j=1:size(trace_pos_t2{i},1)
        AUC_trace_pos_t2_by_cell{i}(j,:) = trapz(time{i}(t2),trace_pos_t2{i}(j,:));
    end

    % t3
    mean_trace_pos_t3_by_cell{i} = mean(trace_pos_t3{i},2);
    sd_trace_pos_t3_by_cell{i} = std(trace_pos_t3{i},[],2);
    sem_trace_pos_t3_by_cell{i} = std(trace_pos_t3{i},[],2) / sqrt(size(trace_pos_t3{i},2));

    for j=1:size(trace_pos_t3{i},1)
        AUC_trace_pos_t3_by_cell{i}(j,:) = trapz(time{i}(t3),trace_pos_t3{i}(j,:));
    end

    % NEG
    trace_neg_pre{i} = trace_neg{i}(:,pre);
    trace_neg_t1{i} = trace_neg{i}(:,t1);
    trace_neg_t2{i} = trace_neg{i}(:,t2);
    trace_neg_t3{i} = trace_neg{i}(:,t3);

    % pre
    mean_trace_neg_pre_by_cell{i} = mean(trace_neg_pre{i},2);
    sd_trace_neg_pre_by_cell{i} = std(trace_neg_pre{i},[],2);
    sem_trace_neg_pre_by_cell{i} = std(trace_neg_pre{i},[],2) / sqrt(size(trace_neg_pre{i},2));

    for j=1:size(trace_neg_pre{i},1)
        AUC_trace_neg_pre_by_cell{i}(j,:) = trapz(time{i}(pre),trace_neg_pre{i}(j,:));
    end

    % t1
    mean_trace_neg_t1_by_cell{i} = mean(trace_neg_t1{i},2);
    sd_trace_neg_t1_by_cell{i} = std(trace_neg_t1{i},[],2);
    sem_trace_neg_t1_by_cell{i} = std(trace_neg_t1{i},[],2) / sqrt(size(trace_neg_t1{i},2));

    for j=1:size(trace_neg_t1{i},1)
        AUC_trace_neg_t1_by_cell{i}(j,:) = trapz(time{i}(t1),trace_neg_t1{i}(j,:));
    end

    % t2
    mean_trace_neg_t2_by_cell{i} = mean(trace_neg_t2{i},2);
    sd_trace_neg_t2_by_cell{i} = std(trace_neg_t2{i},[],2);
    sem_trace_neg_t2_by_cell{i} = std(trace_neg_t2{i},[],2) / sqrt(size(trace_neg_t2{i},2));

    for j=1:size(trace_neg_t2{i},1)
        AUC_trace_neg_t2_by_cell{i}(j,:) = trapz(time{i}(t2),trace_neg_t2{i}(j,:));
    end

    % t3
    mean_trace_neg_t3_by_cell{i} = mean(trace_neg_t3{i},2);
    sd_trace_neg_t3_by_cell{i} = std(trace_neg_t3{i},[],2);
    sem_trace_neg_t3_by_cell{i} = std(trace_neg_t3{i},[],2) / sqrt(size(trace_neg_t3{i},2));

    for j=1:size(trace_neg_t3{i},1)
        AUC_trace_neg_t3_by_cell{i}(j,:) = trapz(time{i}(t3),trace_neg_t3{i}(j,:));
    end

    % NR
    trace_nr_pre{i} = trace_nr{i}(:,pre);
    trace_nr_t1{i} = trace_nr{i}(:,t1);
    trace_nr_t2{i} = trace_nr{i}(:,t2);
    trace_nr_t3{i} = trace_nr{i}(:,t3);

    % pre
    mean_trace_nr_pre_by_cell{i} = mean(trace_nr_pre{i},2);
    sd_trace_nr_pre_by_cell{i} = std(trace_nr_pre{i},[],2);
    sem_trace_nr_pre_by_cell{i} = std(trace_nr_pre{i},[],2) / sqrt(size(trace_nr_pre{i},2));

    for j=1:size(trace_nr_pre{i},1)
        AUC_trace_nr_pre_by_cell{i}(j,:) = trapz(time{i}(pre),trace_nr_pre{i}(j,:));
    end

    % t1
    mean_trace_nr_t1_by_cell{i} = mean(trace_nr_t1{i},2);
    sd_trace_nr_t1_by_cell{i} = std(trace_nr_t1{i},[],2);
    sem_trace_nr_t1_by_cell{i} = std(trace_nr_t1{i},[],2) / sqrt(size(trace_nr_t1{i},2));

    for j=1:size(trace_nr_t1{i},1)
        AUC_trace_nr_t1_by_cell{i}(j,:) = trapz(time{i}(t1),trace_nr_t1{i}(j,:));
    end

    % t2
    mean_trace_nr_t2_by_cell{i} = mean(trace_nr_t2{i},2);
    sd_trace_nr_t2_by_cell{i} = std(trace_nr_t2{i},[],2);
    sem_trace_nr_t2_by_cell{i} = std(trace_nr_t2{i},[],2) / sqrt(size(trace_nr_t2{i},2));

    for j=1:size(trace_nr_t2{i},1)
        AUC_trace_nr_t2_by_cell{i}(j,:) = trapz(time{i}(t2),trace_nr_t2{i}(j,:));
    end

    % t3
    mean_trace_nr_t3_by_cell{i} = mean(trace_nr_t3{i},2);
    sd_trace_nr_t3_by_cell{i} = std(trace_nr_t3{i},[],2);
    sem_trace_nr_t3_by_cell{i} = std(trace_nr_t3{i},[],2) / sqrt(size(trace_nr_t3{i},2));

    for j=1:size(trace_nr_t3{i},1)
        AUC_trace_nr_t3_by_cell{i}(j,:) = trapz(time{i}(t3),trace_nr_t3{i}(j,:));
    end

    output_filename = 'one_photon_clustering_activity.xlsx'; % mean, SEM, and AUC for each time range by cluster

    % Write means by cell for each cluster
    writecell(Header,output_filename,'Sheet',sprintf('mean, pos, %s', groups{i}),'Range','A1');
    writematrix(cells_pos{i},output_filename,'Sheet',sprintf('mean, pos, %s', groups{i}),'Range','A2');
    mean_trace_pos_by_cell = [mean_trace_pos_pre_by_cell{i}, mean_trace_pos_t1_by_cell{i}, mean_trace_pos_t2_by_cell{i}, ...
        mean_trace_pos_t3_by_cell{i}];
    writematrix(mean_trace_pos_by_cell,output_filename,'Sheet',sprintf('mean, pos, %s', groups{i}),'Range','B2');

    writecell(Header,output_filename,'Sheet',sprintf('mean, neg, %s', groups{i}),'Range','A1');
    writematrix(cells_neg{i},output_filename,'Sheet',sprintf('mean, neg, %s', groups{i}),'Range','A2');
    mean_trace_neg_by_cell = [mean_trace_neg_pre_by_cell{i}, mean_trace_neg_t1_by_cell{i}, mean_trace_neg_t2_by_cell{i}, ...
        mean_trace_neg_t3_by_cell{i}];
    writematrix(mean_trace_neg_by_cell,output_filename,'Sheet',sprintf('mean, neg, %s', groups{i}),'Range','B2');

    writecell(Header,output_filename,'Sheet',sprintf('mean, nr, %s', groups{i}),'Range','A1');
    writematrix(cells_nr{i},output_filename,'Sheet',sprintf('mean, nr, %s', groups{i}),'Range','A2');
    mean_trace_nr_by_cell = [mean_trace_nr_pre_by_cell{i}, mean_trace_nr_t1_by_cell{i}, mean_trace_nr_t2_by_cell{i}, ...
        mean_trace_nr_t3_by_cell{i}];
    writematrix(mean_trace_nr_by_cell,output_filename,'Sheet',sprintf('mean, nr, %s', groups{i}),'Range','B2');

    % Write SDs by cell for each cluster
    writecell(Header,output_filename,'Sheet',sprintf('sd, pos, %s', groups{i}),'Range','A1');
    writematrix(cells_pos{i},output_filename,'Sheet',sprintf('sd, pos, %s', groups{i}),'Range','A2');
    sd_trace_pos_by_cell = [sd_trace_pos_pre_by_cell{i}, sd_trace_pos_t1_by_cell{i}, sd_trace_pos_t2_by_cell{i}, ...
        sd_trace_pos_t3_by_cell{i}];
    writematrix(sd_trace_pos_by_cell,output_filename,'Sheet',sprintf('SD, pos, %s', groups{i}),'Range','B2');

    writecell(Header,output_filename,'Sheet',sprintf('sd, neg, %s', groups{i}),'Range','A1');
    writematrix(cells_neg{i},output_filename,'Sheet',sprintf('sd, neg, %s', groups{i}),'Range','A2');
    sd_trace_neg_by_cell = [sd_trace_neg_pre_by_cell{i}, sd_trace_neg_t1_by_cell{i}, sd_trace_neg_t2_by_cell{i}, ...
        sd_trace_neg_t3_by_cell{i}];
    writematrix(sd_trace_neg_by_cell,output_filename,'Sheet',sprintf('SD, neg, %s', groups{i}),'Range','B2');

    writecell(Header,output_filename,'Sheet',sprintf('sd, nr, %s', groups{i}),'Range','A1');
    writematrix(cells_nr{i},output_filename,'Sheet',sprintf('sd, nr, %s', groups{i}),'Range','A2');
    sd_trace_nr_by_cell = [sd_trace_nr_pre_by_cell{i}, sd_trace_nr_t1_by_cell{i}, sd_trace_nr_t2_by_cell{i}, ...
        sd_trace_nr_t3_by_cell{i}];
    writematrix(sd_trace_nr_by_cell,output_filename,'Sheet',sprintf('SD, nr, %s', groups{i}),'Range','B2');

    % Write SEMs by cell for each cluster
    writecell(Header,output_filename,'Sheet',sprintf('sem, pos, %s', groups{i}),'Range','A1');
    writematrix(cells_pos{i},output_filename,'Sheet',sprintf('sem, pos, %s', groups{i}),'Range','A2');
    sem_trace_pos_by_cell = [sem_trace_pos_pre_by_cell{i}, sem_trace_pos_t1_by_cell{i}, sem_trace_pos_t2_by_cell{i}, ...
        sem_trace_pos_t3_by_cell{i}];
    writematrix(sem_trace_pos_by_cell,output_filename,'Sheet',sprintf('SEM, pos, %s', groups{i}),'Range','B2');

    writecell(Header,output_filename,'Sheet',sprintf('sem, neg, %s', groups{i}),'Range','A1');
    writematrix(cells_neg{i},output_filename,'Sheet',sprintf('sem, neg, %s', groups{i}),'Range','A2');
    sem_trace_neg_by_cell = [sem_trace_neg_pre_by_cell{i}, sem_trace_neg_t1_by_cell{i}, sem_trace_neg_t2_by_cell{i}, ...
        sem_trace_neg_t3_by_cell{i}];
    writematrix(sem_trace_neg_by_cell,output_filename,'Sheet',sprintf('SEM, neg, %s', groups{i}),'Range','B2');

    writecell(Header,output_filename,'Sheet',sprintf('sem, nr, %s', groups{i}),'Range','A1');
    writematrix(cells_nr{i},output_filename,'Sheet',sprintf('sem, nr, %s', groups{i}),'Range','A2');
    sem_trace_nr_by_cell = [sem_trace_nr_pre_by_cell{i}, sem_trace_nr_t1_by_cell{i}, sem_trace_nr_t2_by_cell{i}, ...
        sem_trace_nr_t3_by_cell{i}];
    writematrix(sem_trace_nr_by_cell,output_filename,'Sheet',sprintf('SEM, nr, %s', groups{i}),'Range','B2');

    % Write AUCs by cell for each cluster
    writecell(Header,output_filename,'Sheet',sprintf('AUC, pos, %s', groups{i}),'Range','A1');
    writematrix(cells_pos{i},output_filename,'Sheet',sprintf('AUC, pos, %s', groups{i}),'Range','A2');
    AUC_trace_pos_by_cell = [AUC_trace_pos_pre_by_cell{i}, AUC_trace_pos_t1_by_cell{i}, AUC_trace_pos_t2_by_cell{i}, ...
        AUC_trace_pos_t3_by_cell{i}];
    writematrix(AUC_trace_pos_by_cell,output_filename,'Sheet',sprintf('AUC, pos, %s', groups{i}),'Range','B2');

    writecell(Header,output_filename,'Sheet',sprintf('AUC, neg, %s', groups{i}),'Range','A1');
    writematrix(cells_neg{i},output_filename,'Sheet',sprintf('AUC, neg, %s', groups{i}),'Range','A2');
    AUC_trace_neg_by_cell = [AUC_trace_neg_pre_by_cell{i}, AUC_trace_neg_t1_by_cell{i}, AUC_trace_neg_t2_by_cell{i}, ...
        AUC_trace_neg_t3_by_cell{i}];
    writematrix(AUC_trace_neg_by_cell,output_filename,'Sheet',sprintf('AUC, neg, %s', groups{i}),'Range','B2');

    writecell(Header,output_filename,'Sheet',sprintf('AUC, nr, %s', groups{i}),'Range','A1');
    writematrix(cells_nr{i},output_filename,'Sheet',sprintf('AUC, nr, %s', groups{i}),'Range','A2');
    AUC_trace_nr_by_cell = [AUC_trace_nr_pre_by_cell{i}, AUC_trace_nr_t1_by_cell{i}, AUC_trace_nr_t2_by_cell{i}, ...
        AUC_trace_nr_t3_by_cell{i}];
    writematrix(AUC_trace_nr_by_cell,output_filename,'Sheet',sprintf('AUC, nr, %s', groups{i}),'Range','B2');
end

% heat map with neurons sorted by mean 0-30s activity

heatmap_filename = 'one_photon_mean_sorted_heatmap.xlsx';

for i=1:numel(groups)
    time_base_30s{i} = time{i}(time{i} >= -5 & time{i} < 30);
    trace_base_30s{i} = trace{i}(:, time{i} >= -5 & time{i} < 30);
    trace_30s{i} = trace{i}(:, time{i} >= 0 & time{i} < 30);
    
    trace_means{i} = mean(trace_30s{i},2);
    [trace_means_sorted{i}, sort_idx{i}] = sort(trace_means{i},'descend');

    cells_sorted{i} = cell_id{i}(sort_idx{i});
    trace_sorted{i} = trace_base_30s{i}(sort_idx{i},:);
    figure;
    imagesc(time_base_30s{i}, 1, trace_sorted{i});
    colormap('jet');
    title(groups{i});
    colorbar;
    writematrix(time_base_30s{i},heatmap_filename,'Sheet',groups{i},'Range','B1');
    writematrix(cells_sorted{i},heatmap_filename,'Sheet',groups{i},'Range','A2');
    writematrix(trace_sorted{i},heatmap_filename,'Sheet',groups{i},'Range','B2');
end