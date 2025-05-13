% stages = {'pre-cond';
%         'cond CS';
%         'cond US';
%         'f-ret';
%         'ext';
%         'ext-ret';
%         'late-ret';
%         'renewal'};
% 
% filenames = {'Z:\Olena Bukalo\AS project\AS data\neurons\neurons 1p\final\Pre-con CS_responsivity.xlsx';
% 'Z:\Olena Bukalo\AS project\AS data\neurons\neurons 1p\final\F-Con CS_responsivity.xlsx';
% 'Z:\Olena Bukalo\AS project\AS data\neurons\neurons 1p\final\F-Con US_responsivity.xlsx';
% 'Z:\Olena Bukalo\AS project\AS data\neurons\neurons 1p\final\F-Ret CS_responsivity.xlsx';
% 'Z:\Olena Bukalo\AS project\AS data\neurons\neurons 1p\final\E-Ext CS_responsivity.xlsx';
% 'Z:\Olena Bukalo\AS project\AS data\neurons\neurons 1p\final\E-Ret CS_responsivity.xlsx';
% 'Z:\Olena Bukalo\AS project\AS data\neurons\neurons 1p\final\Late E-Ret CS_responsivity.xlsx';
% 'Z:\Olena Bukalo\AS project\AS data\neurons\neurons 1p\final\F-Ren CS_responsivity.xlsx'};

stages = {'f-ret'};

filenames = {'Y:\Olena Bukalo\AS project\AS data\neurons\neurons 1p\final\F-Ret CS_responsivity.xlsx'};

stage_resp_filename = 'one_photon_responder_analysis_stage_resp.xlsx'; % each cell's response by stage

heatmap_filename = 'one_photon_responder_analysis_heatmap.xlsx'; % trace for each cell, sorted by cluster

summary_filename = 'one_photon_responder_analysis_summary.xlsx'; % compares mean and AUC signal (-5-0s vs. 0-5s)

groups = {'VEH-CNO', 'CNO-VEH'};

nr_cells_by_stage = cell(1,numel(stages));
pos_cells_by_stage = cell(1,numel(stages));
neg_cells_by_stage = cell(1,numel(stages));

auc_grouped = cell(1,numel(stages));

for stage=1:numel(stages)
    trace = readtable(filenames{stage},'Sheet','average_trace_obs');
    time = trace.aligned_time;
    trace.aligned_time = [];
    trace_cells = str2double(erase(trace.Properties.VariableNames,'x'));
    
    auc = readtable(filenames{stage},'Sheet','auc_diff_obs');
    % auc.cell_id = str2double(auc.cell_id);

    for i=1:numel(groups)
        auc_grouped{stage}{i} = auc(strcmp(auc.group,groups{i}),:);

        auc_nr{i} = auc_grouped{stage}{i}(auc_grouped{stage}{i}.p_val > 0.05, :);
        auc_pos{i} = auc_grouped{stage}{i}(auc_grouped{stage}{i}.p_val <= 0.05 & auc_grouped{stage}{i}.post_sub_pre > 0, :);
        auc_neg{i} = auc_grouped{stage}{i}(auc_grouped{stage}{i}.p_val <= 0.05 & auc_grouped{stage}{i}.post_sub_pre < 0, :);

        nr_cells_by_stage{stage}{i} = auc_nr{i}.cell_id;
        pos_cells_by_stage{stage}{i} = auc_pos{i}.cell_id;
        neg_cells_by_stage{stage}{i} = auc_neg{i}.cell_id;
    end
    
    plot_colors = {[0 0.4470 0.7410]; [0.8500 0.3250 0.0980]};

    for i=1:numel(groups)
        auc_nr_trace{i} = table2array(trace(:,ismember(trace_cells,auc_nr{i}.cell_id)));
        auc_pos_trace{i} = table2array(trace(:,ismember(trace_cells,auc_pos{i}.cell_id)));
        auc_neg_trace{i} = table2array(trace(:,ismember(trace_cells,auc_neg{i}.cell_id)));

        auc_nr_trace_cells{i} = trace_cells(:,ismember(trace_cells,auc_nr{i}.cell_id));
        auc_pos_trace_cells{i} = trace_cells(:,ismember(trace_cells,auc_pos{i}.cell_id));
        auc_neg_trace_cells{i} = trace_cells(:,ismember(trace_cells,auc_neg{i}.cell_id));
    end

    % Permutation test
    sig = .05;
    consec_thresh = 3.3;

    perm_nr = permutation_test(auc_nr_trace{1}',auc_nr_trace{2}',sig,consec_thresh,0.2);
    perm_pos = permutation_test(auc_pos_trace{1}',auc_pos_trace{2}',sig,consec_thresh,0.65);
    perm_neg = permutation_test(auc_neg_trace{1}',auc_neg_trace{2}',sig,consec_thresh,0.6);

    % Bootstrapping
    sig = .05;
    consec_thresh = 3.3;

    bCI_nr{1} = bootstrapping(auc_nr_trace{1}',sig,consec_thresh,0.25);
    bCI_pos{1} = bootstrapping(auc_pos_trace{1}',sig,consec_thresh,0.7);
    bCI_neg{1} = bootstrapping(auc_neg_trace{1}',sig,consec_thresh,0.65);
    
    bCI_nr{2} = bootstrapping(auc_nr_trace{2}',sig,consec_thresh,0.3);
    bCI_pos{2} = bootstrapping(auc_pos_trace{2}',sig,consec_thresh,0.75);
    bCI_neg{2} = bootstrapping(auc_neg_trace{2}',sig,consec_thresh,0.7);
    
    % plot mean trace for each cluster (group comparison)
    figure;
    for i=1:numel(groups)
        mean_auc_nr_trace = mean(auc_nr_trace{i},2)';
        sem_auc_nr_trace = (std(auc_nr_trace{i},[],2) / sqrt(size(auc_nr_trace{i},2)))';
        plot(time, mean_auc_nr_trace, 'LineWidth', 2, 'Color', plot_colors{i}); hold on;
        errorplot3(mean_auc_nr_trace-sem_auc_nr_trace, mean_auc_nr_trace+sem_auc_nr_trace, [time(1) time(end)], plot_colors{i}, .15); hold on;
        title(sprintf('%s, non-responsive', stages{stage})); hold on;
        plot(time,bCI_nr{i},'Color',plot_colors{i},'LineWidth',2); hold on;
        if i==2
            plot(time,perm_nr,'Color',[0.4660 0.6740 0.1880],'LineWidth', 2);
        end
    end
    
    figure;
    for i=1:numel(groups)
        mean_auc_pos_trace = mean(auc_pos_trace{i},2)';
        sem_auc_pos_trace = (std(auc_pos_trace{i},[],2) / sqrt(size(auc_pos_trace{i},2)))';
        plot(time, mean_auc_pos_trace, 'LineWidth', 2, 'Color', plot_colors{i}); hold on;
        errorplot3(mean_auc_pos_trace-sem_auc_pos_trace, mean_auc_pos_trace+sem_auc_pos_trace, [time(1) time(end)], plot_colors{i}, .15); hold on;
        title(sprintf('%s, positive', stages{stage})); hold on;
        plot(time,bCI_pos{i},'Color',plot_colors{i},'LineWidth',2); hold on;
        if i==2
            plot(time,perm_pos,'Color',[0.4660 0.6740 0.1880],'LineWidth', 2);
        end
    end
    
    figure;
    for i=1:numel(groups)
        mean_auc_neg_trace = mean(auc_neg_trace{i},2)';
        sem_auc_neg_trace = (std(auc_neg_trace{i},[],2) / sqrt(size(auc_neg_trace{i},2)))';
        plot(time, mean_auc_neg_trace, 'LineWidth', 2, 'Color', plot_colors{i}); hold on;
        errorplot3(mean_auc_neg_trace-sem_auc_neg_trace, mean_auc_neg_trace+sem_auc_neg_trace, [time(1) time(end)], plot_colors{i}, .15); hold on;
        title(sprintf('%s, negative', stages{stage})); hold on;
        plot(time,bCI_neg{i},'Color',plot_colors{i},'LineWidth',2); hold on;
        if i==2
            plot(time,perm_neg,'Color',[0.4660 0.6740 0.1880],'LineWidth', 2);
        end
    end

    % Heatmap
    for i=1:numel(groups)
        figure;
        traces_combined{i} = [auc_pos_trace{i}'; auc_neg_trace{i}'; auc_nr_trace{i}'];
        cells_combined{i} = [auc_pos_trace_cells{i}'; auc_neg_trace_cells{i}'; auc_nr_trace_cells{i}'];
        imagesc(time', 1, traces_combined{i});
        colormap('jet');
        title(sprintf('%s, %s', stages{stage}, groups{i}));
        colorbar;
        writematrix(time',heatmap_filename,'Sheet',sprintf('%s, %s', stages{stage}, groups{i}),'Range','B1');
        writematrix(cells_combined{i},heatmap_filename,'Sheet',sprintf('%s, %s', stages{stage}, groups{i}),'Range','A2');
        writematrix(traces_combined{i},heatmap_filename,'Sheet',sprintf('%s, %s', stages{stage}, groups{i}),'Range','B2');
    end

    % compares pre and post AUC and mean signal (-5-0s vs. 0-5s)
    pre = find(time >= -5 & time <= 0);
    post = find(time >= 0 & time <= 5);

    Header = {'-5-0s mean', '0-5s mean', '-5-0s AUC', '0-5s AUC'};

    for i=1:numel(groups)
        % nr
        nr_pre = auc_nr_trace{i}(pre,:)';
        nr_post = auc_nr_trace{i}(post,:)';

        % nr means
        nr_pre_mean{i} = mean(nr_pre,2);
        nr_post_mean{i} = mean(nr_post,2);

        % nr AUCs
        nr_pre_AUC{i} = [];
        for j=1:size(nr_pre,1)
            nr_pre_AUC{i} = [nr_pre_AUC{i}; trapz(time(pre),nr_pre(j,:))];
        end

        nr_post_AUC{i} = [];
        for j=1:size(nr_post,1)
            nr_post_AUC{i} = [nr_post_AUC{i}; trapz(time(post),nr_post(j,:))];
        end

        nr_combined = [nr_pre_mean{i} nr_post_mean{i} nr_pre_AUC{i} nr_post_AUC{i}];
        
        % neg
        neg_pre = auc_neg_trace{i}(pre,:)';
        neg_post = auc_neg_trace{i}(post,:)';

        % neg means
        neg_pre_mean{i} = mean(neg_pre,2);
        neg_post_mean{i} = mean(neg_post,2);

        % neg AUCs
        neg_pre_AUC{i} = [];
        for j=1:size(neg_pre,1)
            neg_pre_AUC{i} = [neg_pre_AUC{i}; trapz(time(pre),neg_pre(j,:))];
        end

        neg_post_AUC{i} = [];
        for j=1:size(neg_post,1)
            neg_post_AUC{i} = [neg_post_AUC{i}; trapz(time(post),neg_post(j,:))];
        end

        neg_combined = [neg_pre_mean{i} neg_post_mean{i} neg_pre_AUC{i} neg_post_AUC{i}];

        % pos
        pos_pre = auc_pos_trace{i}(pre,:)';
        pos_post = auc_pos_trace{i}(post,:)';

        % pos means
        pos_pre_mean{i} = mean(pos_pre,2);
        pos_post_mean{i} = mean(pos_post,2);

        % pos AUCs
        pos_pre_AUC{i} = [];
        for j=1:size(pos_pre,1)
            pos_pre_AUC{i} = [pos_pre_AUC{i}; trapz(time(pre),pos_pre(j,:))];
        end

        pos_post_AUC{i} = [];
        for j=1:size(pos_post,1)
            pos_post_AUC{i} = [pos_post_AUC{i}; trapz(time(post),pos_post(j,:))];
        end
        
        pos_combined = [pos_pre_mean{i} pos_post_mean{i} pos_pre_AUC{i} pos_post_AUC{i}];

        writecell(Header,summary_filename,'Sheet',sprintf('%s, %s, nr', stages{stage}, groups{i}),'Range','B1');
        writematrix(nr_combined,summary_filename,'Sheet',sprintf('%s, %s, nr', stages{stage}, groups{i}),'Range','B2');
        writematrix(auc_nr_trace_cells{i}',summary_filename,'Sheet',sprintf('%s, %s, nr', stages{stage}, groups{i}),'Range','A2');

        writecell(Header,summary_filename,'Sheet',sprintf('%s, %s, neg', stages{stage}, groups{i}),'Range','B1');
        writematrix(neg_combined,summary_filename,'Sheet',sprintf('%s, %s, neg', stages{stage}, groups{i}),'Range','B2');
        writematrix(auc_neg_trace_cells{i}',summary_filename,'Sheet',sprintf('%s, %s, neg', stages{stage}, groups{i}),'Range','A2');

        writecell(Header,summary_filename,'Sheet',sprintf('%s, %s, pos', stages{stage}, groups{i}),'Range','B1');
        writematrix(pos_combined,summary_filename,'Sheet',sprintf('%s, %s, pos', stages{stage}, groups{i}),'Range','B2');
        writematrix(auc_pos_trace_cells{i}',summary_filename,'Sheet',sprintf('%s, %s, pos', stages{stage}, groups{i}),'Range','A2');
    end

    % percent of cells in each cluster
    figure;
    tiledlayout(1,2);
    for i=1:numel(groups)
        clusters = ["Non-responsive", "Negative", "Positive"];
        num_cells_nr = numel(auc_nr_trace_cells{i});
        num_cells_neg = numel(auc_neg_trace_cells{i});
        num_cells_pos = numel(auc_pos_trace_cells{i});
        counts = [num_cells_nr, num_cells_neg, num_cells_pos];
        tbl = table(clusters, counts);

        nexttile
        piechart(tbl,"counts","clusters");
        title(groups{i});
    end
    sgtitle(stages{stage});
end

group_cells = cell(1,numel(groups));
group_names = cell(1,numel(groups));
group_resp = cell(1,numel(groups));
sorted_group_cells = cell(1,numel(groups));
sorted_group_names = cell(1,numel(groups));

% create ascending list of unique cell_ids (by group) in sorted_group_cells
for i=1:numel(groups)
    for stage=1:numel(stages)
        group_stage_cells = auc_grouped{stage}{i}.cell_id;
        group_stage_names = auc_grouped{stage}{i}.mouse_name;
        group_stage_cells_new = group_stage_cells(~ismember(group_stage_cells,group_cells{i}));
        group_stage_names_new = group_stage_names(~ismember(group_stage_cells,group_cells{i}));
        group_cells{i} = [group_cells{i}; group_stage_cells_new];
        group_names{i} = [group_names{i}; group_stage_names_new];
    end
    [sorted_group_cells{i}, sort_idx] = sort(group_cells{i});
    sorted_group_names{i} = group_names{i}(sort_idx);
end

% for each group and stage, mark if cells are non-responsive (NR) to CS, show positive
% (POS) or negative (NEG) response to CS, or are inactive (I)
for i=1:numel(groups)
    nr_pct{i} = [];
    neg_pct{i} = [];
    pos_pct{i} = [];
    inact_pct{i} = [];
    act_pct{i} = [];
    for stage=1:numel(stages)
        group_stage_resp = strings(numel(sorted_group_cells{i}),1);
        group_names = strings(numel(sorted_group_cells{i}),1);

        curr_nr = nr_cells_by_stage{stage}{i};
        curr_pos = pos_cells_by_stage{stage}{i};
        curr_neg = neg_cells_by_stage{stage}{i};

        nr_idx = ismember(sorted_group_cells{i},curr_nr);
        pos_idx = ismember(sorted_group_cells{i},curr_pos);
        neg_idx = ismember(sorted_group_cells{i},curr_neg);
        inact_idx = ~ismember(sorted_group_cells{i},[curr_nr; curr_pos; curr_neg]);

        group_stage_resp(nr_idx) = 'NR';
        group_stage_resp(pos_idx) = 'POS';
        group_stage_resp(neg_idx) = 'NEG';
        group_stage_resp(inact_idx) = 'I';

        group_resp{i} = [group_resp{i} group_stage_resp];
        nr_pct{i} = [nr_pct{i} sum(nr_idx) / numel(nr_idx)];
        neg_pct{i} = [neg_pct{i} sum(neg_idx) / numel(neg_idx)];
        pos_pct{i} = [pos_pct{i} sum(pos_idx) / numel(pos_idx)];
        inact_pct{i} = [inact_pct{i} sum(inact_idx) / numel(inact_idx)];
        act_pct{i} = [act_pct{i} nr_pct{i}(stage) + neg_pct{i}(stage) + pos_pct{i}(stage)];
    end
end

% create cell overlap matrix (% of cells in stage 1 that are also in stage 2)
for i=1:numel(groups)
    cell_overlap_matrix{i} = zeros(numel(stages),numel(stages));
    for stage_1=1:numel(stages)
        for stage_2=1:numel(stages)
            stage_1_cells = [nr_cells_by_stage{stage_1}{i}; neg_cells_by_stage{stage_1}{i}; pos_cells_by_stage{stage_1}{i}];
            stage_2_cells = [nr_cells_by_stage{stage_2}{i}; neg_cells_by_stage{stage_2}{i}; pos_cells_by_stage{stage_2}{i}];
            overlap_cells = intersect(stage_1_cells,stage_2_cells);
            overlap_pct = numel(overlap_cells) / numel(stage_1_cells);
            cell_overlap_matrix{i}(stage_1,stage_2) = overlap_pct;
        end
    end
end

% write cell responses by stage to Excel
for i=1:numel(groups)
    writecell(stages',stage_resp_filename,'Sheet',sprintf('%s_summary', groups{i}),'Range','B1');
    summary = {'% inactive'; '% active'; '% nr'; '% neg'; '% pos'};
    writecell(summary,stage_resp_filename,'Sheet',sprintf('%s_summary', groups{i}),'Range','A2');
    pcts_combined = [inact_pct{i}; act_pct{i}; nr_pct{i}; neg_pct{i}; pos_pct{i}];
    writematrix(pcts_combined,stage_resp_filename,'Sheet',sprintf('%s_summary', groups{i}),'Range','B2');

    writecell(stages',stage_resp_filename,'Sheet',sprintf('%s_cell_overlap', groups{i}),'Range','B1');
    writecell(upper(stages),stage_resp_filename,'Sheet',sprintf('%s_cell_overlap', groups{i}),'Range','A2');
    writematrix(cell_overlap_matrix{i},stage_resp_filename,'Sheet',sprintf('%s_cell_overlap', groups{i}),'Range','B2');

    writecell({'cell_id', 'mouse_name'},stage_resp_filename,'Sheet',sprintf('%s_ind', groups{i}),'Range','A1');
    writecell(stages',stage_resp_filename,'Sheet',sprintf('%s_ind', groups{i}),'Range','C1');
    writematrix(sorted_group_cells{i},stage_resp_filename,'Sheet',sprintf('%s_ind', groups{i}),'Range','A2');
    writecell(sorted_group_names{i},stage_resp_filename,'Sheet',sprintf('%s_ind', groups{i}),'Range','B2');
    writematrix(group_resp{i},stage_resp_filename,'Sheet',sprintf('%s_ind', groups{i}),'Range','C2');
end