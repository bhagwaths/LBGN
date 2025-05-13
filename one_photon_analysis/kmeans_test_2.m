% stages = {'Hab', 'EExt', 'LExt', 'ERet'};
stages = {'EExt', 'LExt', 'ERet'};

% Hab_resp_filename = "C:\Users\bhagwaths\Documents\hab-tone_CS_traces_and_responses.xlsx";
EExt_resp_filename = "C:\Users\bhagwaths\Documents\Copy of E-Ext_CS_traces_and_responses.xlsx";
LExt_resp_filename = "C:\Users\bhagwaths\Documents\L-Ext_CS_traces_and_responses.xlsx";
ERet_resp_filename = "C:\Users\bhagwaths\Documents\E-Ret_CS_traces_and_responses.xlsx";

% Hab_act_filename = "Y:\Olena Bukalo\AS project\AS data\neurons\neurons 1p\hab-tone_CS_traces_and_responses_HB.xlsx";
EExt_act_filename = "Y:\Olena Bukalo\AS project\AS data\neurons\neurons 1p\final\E-Ext_activity_HB.xlsx";
LExt_act_filename = "Y:\Olena Bukalo\AS project\AS data\neurons\neurons 1p\final\L-Ext_activity_HB.xlsx";
ERet_act_filename = "Y:\Olena Bukalo\AS project\AS data\neurons\neurons 1p\final\E-Ret_activity_HB.xlsx";

time_range = {[0 30], [-5 30]};
k_list = [4, 5, 6];

% Hab_data = readtable(Hab_resp_filename,'Sheet','auc_diff_obs');
EExt_data = readtable(EExt_resp_filename,'Sheet','auc_diff_obs');
LExt_data = readtable(LExt_resp_filename,'Sheet','auc_diff_obs');
ERet_data = readtable(ERet_resp_filename,'sheet','auc_diff_obs');

% Hab_traces_full = readmatrix(Hab_act_filename, 'Sheet', 'aligned_traces');
EExt_traces_full = readmatrix(EExt_act_filename, 'Sheet', 'aligned_traces');
LExt_traces_full = readmatrix(LExt_act_filename, 'Sheet', 'aligned_traces');
ERet_traces_full = readmatrix(ERet_act_filename, 'Sheet', 'aligned_traces');

% cells_combined = [Hab_data.cell_id; EExt_data.cell_id; LExt_data.cell_id; ERet_data.cell_id];
% groups_combined = [Hab_data.group; EExt_data.group; LExt_data.group; ERet_data.group];
cells_combined = [EExt_data.cell_id; LExt_data.cell_id; ERet_data.cell_id];
groups_combined = [EExt_data.group; LExt_data.group; ERet_data.group];

[cells_unique, unique_idx] = unique(cells_combined);
groups_unique = groups_combined(unique_idx);

chi2_filename = "C:\Users\bhagwaths\Pictures\kmeans_plots\chi2.xlsx";
chi2_t = [];
chi2_k = [];
chi2_vals = [];
chi2_crit = [];
chi2_p = [];

summary_filename = "C:\Users\bhagwaths\Pictures\kmeans_plots\summary.xlsx";

cells_per_cluster_filename = "C:\Users\bhagwaths\Pictures\kmeans_plots\cells_per_cluster.xlsx";

%%

for curr_range=1:numel(time_range)
    for curr_k=1:numel(k_list)
        % Hab_resp_cells = [Hab_data.cell_id(strcmp(Hab_data.group, 'VEH-VEH')); Hab_data.cell_id(strcmp(Hab_data.group, 'VEH-CNO'))];
        EExt_resp_cells = [EExt_data.cell_id(strcmp(EExt_data.group, 'VEH-VEH')); EExt_data.cell_id(strcmp(EExt_data.group, 'VEH-CNO'))];
        LExt_resp_cells = [LExt_data.cell_id(strcmp(LExt_data.group, 'VEH-VEH')); LExt_data.cell_id(strcmp(LExt_data.group, 'VEH-CNO'))];
        ERet_resp_cells = [ERet_data.cell_id(strcmp(ERet_data.group, 'VEH-VEH')); ERet_data.cell_id(strcmp(ERet_data.group, 'VEH-CNO'))];
        
        % Hab_times = Hab_traces_full(2:end,1);
        EExt_times = EExt_traces_full(2:end,1);
        LExt_times = LExt_traces_full(2:end,1);
        ERet_times = ERet_traces_full(2:end,1);
        
        % Hab_traces_cells = Hab_traces_full(1,3:end);
        EExt_traces_cells = EExt_traces_full(1,3:end);
        LExt_traces_cells = LExt_traces_full(1,3:end);
        ERet_traces_cells = ERet_traces_full(1,3:end);
        
        % Hab_traces = Hab_traces_full(2:end,3:end);
        EExt_traces = EExt_traces_full(2:end,3:end);
        LExt_traces = LExt_traces_full(2:end,3:end);
        ERet_traces = ERet_traces_full(2:end,3:end);
        
        % Hab_traces_mean = [];
        EExt_traces_mean = [];
        LExt_traces_mean = [];
        ERet_traces_mean = [];
        
        % Hab_times_mean = [];
        EExt_times_mean = [];
        LExt_times_mean = [];
        ERet_times_mean = [];
        
        for i=1:5:size(EExt_traces,1)
            % curr_Hab_mean = mean(Hab_traces(i:i+4, :), 1);
            % Hab_traces_mean = [Hab_traces_mean; curr_Hab_mean];
        
            curr_EExt_mean = mean(EExt_traces(i:i+4, :), 1);
            EExt_traces_mean = [EExt_traces_mean; curr_EExt_mean];
            
            curr_LExt_mean = mean(LExt_traces(i:i+4, :), 1);
            LExt_traces_mean = [LExt_traces_mean; curr_LExt_mean];
        
            curr_ERet_mean = mean(ERet_traces(i:i+4, :), 1);
            ERet_traces_mean = [ERet_traces_mean; curr_ERet_mean];
        
            % curr_Hab_time = mean(Hab_times(i:i+4, :), 1);
            % Hab_times_mean = [Hab_times_mean; curr_Hab_time];
        
            curr_EExt_time = mean(EExt_times(i:i+4, :), 1);
            EExt_times_mean = [EExt_times_mean; curr_EExt_time];

            curr_LExt_time = mean(LExt_times(i:i+4, :), 1);
            LExt_times_mean = [LExt_times_mean; curr_LExt_time];
        
            curr_ERet_time = mean(ERet_times(i:i+4, :), 1);
            ERet_times_mean = [ERet_times_mean; curr_ERet_time];
        end
        
        % Hab_traces_mean = Hab_traces_mean(Hab_times_mean >= time_range{curr_range}(1) & Hab_times_mean <= time_range{curr_range}(2), :)';
        EExt_traces_mean = EExt_traces_mean(EExt_times_mean >= time_range{curr_range}(1) & EExt_times_mean <= time_range{curr_range}(2), :)';
        LExt_traces_mean = LExt_traces_mean(LExt_times_mean >= time_range{curr_range}(1) & LExt_times_mean <= time_range{curr_range}(2), :)';
        ERet_traces_mean = ERet_traces_mean(ERet_times_mean >= time_range{curr_range}(1) & ERet_times_mean <= time_range{curr_range}(2), :)';
        
        % Hab_times_mean = Hab_times_mean(Hab_times_mean >= time_range{curr_range}(1) & Hab_times_mean <= time_range{curr_range}(2), :)';
        EExt_times_mean = EExt_times_mean(EExt_times_mean >= time_range{curr_range}(1) & EExt_times_mean <= time_range{curr_range}(2), :)';
        LExt_times_mean = LExt_times_mean(LExt_times_mean >= time_range{curr_range}(1) & LExt_times_mean <= time_range{curr_range}(2), :)';
        ERet_times_mean = ERet_times_mean(ERet_times_mean >= time_range{curr_range}(1) & ERet_times_mean <= time_range{curr_range}(2), :)';
        
        % shared_traces_cells = intersect(intersect(Hab_traces_cells,intersect(LExt_traces_cells, EExt_traces_cells)),ERet_traces_cells);
        % shared_cells = intersect(shared_traces_cells, [Hab_resp_cells; EExt_resp_cells; LExt_resp_cells; ERet_resp_cells]);
        shared_traces_cells = intersect(intersect(LExt_traces_cells, EExt_traces_cells),ERet_traces_cells);
        shared_cells = intersect(shared_traces_cells, [EExt_resp_cells; LExt_resp_cells; ERet_resp_cells]);


        % [~, Hab_idx] = ismember(shared_cells, Hab_traces_cells);
        [~, EExt_idx] = ismember(shared_cells, EExt_traces_cells);
        [~, LExt_idx] = ismember(shared_cells, LExt_traces_cells);        
        [~, ERet_idx] = ismember(shared_cells, ERet_traces_cells);
        
        % Hab_traces_ordered = Hab_traces_mean(Hab_idx,:);
        EExt_traces_ordered = EExt_traces_mean(EExt_idx,:);
        LExt_traces_ordered = LExt_traces_mean(LExt_idx,:);
        ERet_traces_ordered = ERet_traces_mean(ERet_idx,:);
        
        % combined_traces_ordered = [Hab_traces_ordered, EExt_traces_ordered, LExt_traces_ordered, ERet_traces_ordered];
        % combined_times_ordered = [Hab_times_mean, EExt_times_mean, LExt_times_mean, ERet_times_mean];
        combined_traces_ordered = [EExt_traces_ordered, LExt_traces_ordered, ERet_traces_ordered];
        combined_times_ordered = [EExt_times_mean, LExt_times_mean, ERet_times_mean];
        
        %% Elbow curve
        
        wcss = [];
        for k_test=1:10
            [~, ~, sumd] = kmeans(combined_traces_ordered, k_test, 'Replicates', 10);
            wcss = [wcss, sum(sumd)];
        end
        
        figure;
        plot(1:10, wcss, '-o');
        xlabel('Number of clusters');
        ylabel('Sum of squared distances');
        title('Elbow curve');

        saveas(gcf,sprintf('C:\\Users\\bhagwaths\\Pictures\\kmeans_plots\\elbow_curve_t=%d-%d_k=%d.png', time_range{curr_range}(1),...
            time_range{curr_range}(2), k_list(curr_k)));
        
        %% Heat map
        
        idx = kmeans(combined_traces_ordered, k_list(curr_k), 'Replicates', 10);
        figure;
        [s,h] = silhouette(combined_traces_ordered,idx);

        saveas(gcf,sprintf('C:\\Users\\bhagwaths\\Pictures\\kmeans_plots\\silhouette_plot_t=%d-%d_k=%d.png', time_range{curr_range}(1),...
            time_range{curr_range}(2), k_list(curr_k)));
        
        cluster_activity_combined = [];
        for i=1:k_list(curr_k)
            curr_cluster_activity = combined_traces_ordered(idx==i,:);
            cluster_activity_combined = [cluster_activity_combined; curr_cluster_activity];
        end
        
        figure;
        imagesc(combined_times_ordered, 1, cluster_activity_combined);
        axis off;
        colormap('jet');
        colorbar;

        saveas(gcf,sprintf('C:\\Users\\bhagwaths\\Pictures\\kmeans_plots\\heatmap_t=%d-%d_k=%d.png', time_range{curr_range}(1),...
            time_range{curr_range}(2), k_list(curr_k)));
        
        %% Average traces by cluster
        
        plot_colors = [[0 0.4470 0.7410]; [0.8500 0.3250 0.0980]; [0.9290 0.6940 0.1250]; [0.4940 0.1840 0.5560]; [0.4660 0.6740 0.1880]; [0.3010 0.7450 0.9330]];
        
        time_range_total = (time_range{curr_range}(2)-time_range{curr_range}(1))*numel(stages);
        
        figure;
        for i=1:k_list(curr_k)
            curr_cluster_activity = combined_traces_ordered(idx==i, :);
            mean_cluster_activity = mean(curr_cluster_activity,1);
            sem_cluster_activity = std(curr_cluster_activity,[],1) / sqrt(size(curr_cluster_activity,1));
            plot(linspace(0,time_range_total,length(mean_cluster_activity)),mean_cluster_activity, 'LineWidth', 2, 'Color', plot_colors(i,:)); hold on;
            errorplot3(mean_cluster_activity-sem_cluster_activity, mean_cluster_activity+sem_cluster_activity,...
                [0 time_range_total], plot_colors(i,:),.15);
        end
        title('Activity by cluster');
        xlabel('Time (s)');
        ylabel('dF/F');
        xlim([0 time_range_total]);
        
        for i = 1:k_list(curr_k)
            legend_vals{2*i-1} = num2str(i);
            legend_vals{2*i} = '';
        end
        
        legend(legend_vals);

        saveas(gcf,sprintf('C:\\Users\\bhagwaths\\Pictures\\kmeans_plots\\activity_by_cluster_t=%d-%d_k=%d.png', time_range{curr_range}(1),...
            time_range{curr_range}(2), k_list(curr_k)));
        
        %% Pie chart
        
        pie_labels = arrayfun(@(x) sprintf('Cluster %d', x), 1:k_list(curr_k), 'UniformOutput', false);
        
        num_cells_per_cluster = [];
        for i=1:k_list(curr_k)
            curr_cluster = idx == i;
            num_cells_per_cluster = [num_cells_per_cluster, sum(curr_cluster)];
        end
        
        pct_per_cluster = (num_cells_per_cluster / sum(num_cells_per_cluster))*100;
        new_labels = strcat(pie_labels, ": ", string(num_cells_per_cluster), " (", string(round(pct_per_cluster, 1)), "%)");

        figure;
        piechart(num_cells_per_cluster, pie_labels, 'Labels', new_labels);
        colormap(plot_colors);
        title('Percent cells by cluster');

        saveas(gcf,sprintf('C:\\Users\\bhagwaths\\Pictures\\kmeans_plots\\cells_by_cluster_t=%d-%d_k=%d.png', time_range{curr_range}(1),...
            time_range{curr_range}(2), k_list(curr_k)));

        %% VEH-VEH vs. VEH-CNO comparison

        groups = {'VEH-VEH', 'VEH-CNO'};
        group_plot_colors = [[0 0.4470 0.7410]; [0.8500 0.3250 0.0980]];

        for i=1:k_list(curr_k)
            cluster_idx = find(idx==i);
            curr_cluster_activity = combined_traces_ordered(cluster_idx, :);
            cluster_cells = shared_cells(cluster_idx);
            figure;
            for curr_group=1:numel(groups)
                [~, cell_group_idx] = ismember(cluster_cells, cells_unique);
                shared_cells_groups = groups_unique(cell_group_idx);
                group_cluster_activity = curr_cluster_activity(strcmp(shared_cells_groups,groups{curr_group}), :);
                mean_cluster_activity = mean(group_cluster_activity,1);
                sem_cluster_activity = std(group_cluster_activity,[],1) / sqrt(size(group_cluster_activity,1));
                plot(linspace(0,time_range_total,length(mean_cluster_activity)),mean_cluster_activity, 'LineWidth', 2, 'Color', group_plot_colors(curr_group,:)); hold on;
                errorplot3(mean_cluster_activity-sem_cluster_activity, mean_cluster_activity+sem_cluster_activity,...
                    [0 time_range_total], group_plot_colors(curr_group,:),.15); hold on;
            end
            title(sprintf('Activity (cluster %d)', i));
            xlabel('Time (s)');
            ylabel('dF/F');
            xlim([0 time_range_total]);
            legend({'VEH-VEH', '', 'VEH-CNO', ''});

            saveas(gcf,sprintf('C:\\Users\\bhagwaths\\Pictures\\kmeans_plots\\grouped_activity_by_cluster_t=%d-%d_k=%d_clust=%d.png', time_range{curr_range}(1),...
                time_range{curr_range}(2), k_list(curr_k), i));
        end
        %%
        [~, cell_group_idx] = ismember(shared_cells, cells_unique);
        shared_cells_groups = groups_unique(cell_group_idx);

        grouped_cells_per_cluster = cell(1,numel(groups));
        for curr_group=1:numel(groups)
            grouped_idx = idx(strcmp(shared_cells_groups, groups{curr_group}));
            for i=1:k_list(curr_k)
                curr_cluster = grouped_idx == i;
                grouped_cells_per_cluster{curr_group} = [grouped_cells_per_cluster{curr_group}, sum(curr_cluster)];
            end
            grouped_pct_per_cluster{curr_group} = (grouped_cells_per_cluster{curr_group} / sum(grouped_cells_per_cluster{curr_group}))*100;
        end

        figure;
        tiledlayout(1,numel(groups));
        for curr_group=1:numel(groups)
            clusters = strcat(pie_labels, ": ", string(grouped_cells_per_cluster{curr_group}), " (", string(round(grouped_pct_per_cluster{curr_group}, 1)), "%)");
            counts = [grouped_cells_per_cluster{curr_group}];
            tbl = table(clusters, counts);
            nexttile
            piechart(tbl, "counts", "clusters", 'Labels', clusters);
            title(groups{curr_group});
        end
        saveas(gcf,sprintf('C:\\Users\\bhagwaths\\Pictures\\kmeans_plots\\grouped_cells_by_cluster_t=%d-%d_k=%d.png', time_range{curr_range}(1),...
            time_range{curr_range}(2), k_list(curr_k)));
        
        for curr_group=1:numel(groups)
            writecell({'cluster_id', 'num_cells'}, cells_per_cluster_filename, 'Range', 'A1', 'Sheet',...
                sprintf('t=%d-%d, k=%d (%s)', time_range{curr_range}(1), time_range{curr_range}(2),...
                k_list(curr_k), groups{curr_group}));
            writematrix((1:k_list(curr_k))', cells_per_cluster_filename, 'Range', 'A2', 'Sheet',...
                sprintf('t=%d-%d, k=%d (%s)', time_range{curr_range}(1), time_range{curr_range}(2),...
                k_list(curr_k), groups{curr_group}));
            writematrix(grouped_cells_per_cluster{curr_group}', cells_per_cluster_filename, 'Range', 'B2', 'Sheet',...
                sprintf('t=%d-%d, k=%d (%s)', time_range{curr_range}(1), time_range{curr_range}(2),...
                k_list(curr_k), groups{curr_group}));
        end

        %% Chi-squared test of independence
        alpha = 0.05;

        obs_table = [];
        for i=1:numel(groups)
            obs_table = [obs_table, grouped_cells_per_cluster{i}'];
        end

        row_sums = sum(obs_table,2);
        col_sums = sum(obs_table,1);
        total = sum(obs_table,'all');

        exp_table = (row_sums * col_sums) / total;

        chi2 = sum((obs_table - exp_table).^2 ./ exp_table, 'all');
        df = (size(obs_table,1) - 1) * (size(obs_table,2) - 1);
        crit_val = chi2inv(1-alpha, df);
        p_val = 1 - chi2cdf(chi2, df);

        chi2_t = [chi2_t; sprintf("%d-%ds", time_range{curr_range}(1), time_range{curr_range}(2))];
        chi2_k = [chi2_k; k_list(curr_k)];
        chi2_vals = [chi2_vals; chi2];
        chi2_crit = [chi2_crit; crit_val];
        chi2_p = [chi2_p; p_val];

        %% Cluster assignments

        for curr_group=1:numel(groups)
            shared_cells_by_group{curr_group} = shared_cells(strcmp(shared_cells_groups, groups{curr_group}));
            clusters_by_group{curr_group} = idx(strcmp(shared_cells_groups, groups{curr_group}));
            combined_traces_by_group{curr_group} = combined_traces_ordered(strcmp(shared_cells_groups, groups{curr_group}),:);

            writecell({'cell_id', 'cluster_id'}, summary_filename, 'Range', 'A1', 'Sheet',...
                sprintf('t=%d-%d, k=%d (%s)', time_range{curr_range}(1), time_range{curr_range}(2),...
                k_list(curr_k), groups{curr_group}));
            writematrix(shared_cells_by_group{curr_group}, summary_filename, 'Range', 'A2', 'Sheet',...
                sprintf('t=%d-%d, k=%d (%s)', time_range{curr_range}(1), time_range{curr_range}(2),...
                k_list(curr_k), groups{curr_group}));
            writematrix(clusters_by_group{curr_group}, summary_filename, 'Range', 'B2', 'Sheet',...
                sprintf('t=%d-%d, k=%d (%s)', time_range{curr_range}(1), time_range{curr_range}(2),...
                k_list(curr_k), groups{curr_group}));
            writematrix(combined_times_ordered, summary_filename, 'Range', 'C1', 'Sheet',...
                sprintf('t=%d-%d, k=%d (%s)', time_range{curr_range}(1), time_range{curr_range}(2),...
                k_list(curr_k), groups{curr_group}));
            writematrix(combined_traces_by_group{curr_group}, summary_filename, 'Range', 'C2', 'Sheet',...
                sprintf('t=%d-%d, k=%d (%s)', time_range{curr_range}(1), time_range{curr_range}(2),...
                k_list(curr_k), groups{curr_group}));
        end
    end
end
%%
chi2_table = table(chi2_t, chi2_k, chi2_vals, chi2_crit, chi2_p);
chi2_table.Properties.VariableNames = {'time', 'k', 'chi2', 'crit_val', 'p_val'};
writetable(chi2_table, chi2_filename);