num_clusters = 5;
num_groups = 2;
group_names = {'CNO-VEH', 'VEH-CNO'};
filename = 'ret_clustering_results_HB.xlsx';

% read cluster map
for group=1:num_groups
    cluster_map{group} = xlsread(filename, sprintf('%s_cluster_map', group_names{group}));
    cell_id{group} = cluster_map{group}(:,2);
    cluster{group} = cluster_map{group}(:,3);
end

% sort cells by cluster
for group=1:num_groups
    for curr_cluster=1:num_clusters
        cells_by_cluster{group}{curr_cluster} = cell_id{group}(cluster{group} == curr_cluster-1);
    end
end

% read average traces and time
for group=1:num_groups
    average_traces_raw{group} = xlsread(filename, sprintf('%s_average_traces', group_names{group}));
    average_traces{group} = average_traces_raw{group}(2:end,2:end);
    trace_cell_id{group} = average_traces_raw{group}(2:end,1);
end
time = average_traces_raw{1}(1,2:end);

% sort average traces by cluster and plot heat maps by cluster
for group=1:num_groups
    for curr_cluster=1:num_clusters
        cluster_rows = find(ismember(trace_cell_id{group},cells_by_cluster{group}{curr_cluster}));
        average_traces_by_cluster{group}{curr_cluster} = average_traces{group}(cluster_rows,:);
        % % Separate by cluster
        % figure;
        % imagesc(time,1,average_traces_by_cluster{group}{curr_cluster}); hold on;
        % title(sprintf('%s, Cluster %d', group_names{group}, curr_cluster-1));
        % colormap('jet');
        % colorbar;
    end
end

% plot group heat maps in specific cluster order and write to excel
cluster_order = [1,5,4,2,3]; % real cluster numbers are 0-indexed: [0,4,3,1,2]
average_traces_combined = cell(1,num_groups);
for group=1:num_groups
    for curr_cluster=1:num_clusters
        average_traces_combined{group} = [average_traces_combined{group}; average_traces_by_cluster{group}{cluster_order(curr_cluster)}];
    end
    figure;
    imagesc(time,1,average_traces_combined{group}); hold on;
    title(group_names{group});
    colormap('jet');
    colorbar;
    % xlswrite('one_photon_clustering_heatmaps.xlsx', average_traces_combined{group}, group_names{group});
end

% for each group and cluster, average and sem of signal: -5 to 0, 0 to 10, 20 to 30, and 0 to 30
pre = find(time >= -5 & time < 0);
t1 = find(time >= 0 & time < 10);
t2 = find(time >= 20 & time < 30);
t3 = find(time >= 0 & time < 30);

Header = {'Cluster','-5-0s','0-10s','20-30s','0-30s'};

% Split signal by group, cluster and time range
for group=1:num_groups
    for curr_cluster=1:num_clusters
        cluster_AUC_cell = [];
        trace = average_traces_by_cluster{group}{curr_cluster};
        cluster_signal_pre = trace(:,pre);
        cluster_signal_t1 = trace(:,t1);
        cluster_signal_t2 = trace(:,t2);
        cluster_signal_t3 = trace(:,t3);
        xlswrite('one_photon_clustering_ranges.xlsx', cluster_signal_pre, sprintf('%s, c%d, %s', group_names{group},...
            curr_cluster-1, Header{2}));
        xlswrite('one_photon_clustering_ranges.xlsx', cluster_signal_t1, sprintf('%s, c%d, %s', group_names{group},...
            curr_cluster-1, Header{3}));
        xlswrite('one_photon_clustering_ranges.xlsx', cluster_signal_t2, sprintf('%s, c%d, %s', group_names{group},...
            curr_cluster-1, Header{4}));
        xlswrite('one_photon_clustering_ranges.xlsx', cluster_signal_t3, sprintf('%s, c%d, %s', group_names{group},...
            curr_cluster-1, Header{5}));

        for row=1:size(trace,1)
            AUC_pre = trapz(time(:,pre), cluster_signal_pre(row,:));
            AUC_t1 = trapz(time(:,t1), cluster_signal_t1(row,:));
            AUC_t2 = trapz(time(:,t2), cluster_signal_t2(row,:));
            AUC_t3 = trapz(time(:,t3), cluster_signal_t3(row,:));
            AUC_cell = [AUC_pre AUC_t1 AUC_t2 AUC_t3];
            cluster_AUC_cell = [cluster_AUC_cell; AUC_cell];
        end
        xlswrite('one_photon_clustering_AUC_ranges.xlsx', {'-5-0s','0-10s','20-30s','0-30s'}, sprintf('%s, c%d',...
            group_names{group}, curr_cluster-1), 'A1');
        xlswrite('one_photon_clustering_AUC_ranges.xlsx', cluster_AUC_cell, sprintf('%s, c%d', group_names{group},...
            curr_cluster-1), 'A2');
    end
end

% Mean trace
for group=1:num_groups
    mean_signal_pre = []; 
    mean_signal_t1 = []; 
    mean_signal_t2 = [];
    mean_signal_t3 = []; 
    for curr_cluster=1:num_clusters
        trace = average_traces_by_cluster{group}{curr_cluster};
        mean_signal_pre = [mean_signal_pre; mean(trace(:,pre),"all")];
        mean_signal_t1 = [mean_signal_t1; mean(trace(:,t1),"all")];
        mean_signal_t2 = [mean_signal_t2; mean(trace(:,t2),"all")];
        mean_signal_t3 = [mean_signal_t3; mean(trace(:,t3),"all")];
    end
    trace_combined = average_traces{group};
    mean_signal_pre = [mean_signal_pre; mean(trace_combined(:,pre),"all")];
    mean_signal_t1 = [mean_signal_t1; mean(trace_combined(:,t1),"all")];
    mean_signal_t2 = [mean_signal_t2; mean(trace_combined(:,t2),"all")];
    mean_signal_t3 = [mean_signal_t3; mean(trace_combined(:,t3),"all")];

    xlswrite('one_photon_clustering_summary.xlsx', Header, strcat(group_names{group}, ' means'), 'A1');
    xlswrite('one_photon_clustering_summary.xlsx', (0:num_clusters-1)', strcat(group_names{group}, ' means'), 'A2');
    xlswrite('one_photon_clustering_summary.xlsx', [mean_signal_pre mean_signal_t1 mean_signal_t2 mean_signal_t3], strcat(group_names{group}, ' means'), 'B2');
end

% SEM of trace
for group=1:num_groups
    sem_signal_pre = [];
    sem_signal_t1 = [];
    sem_signal_t2 = [];
    sem_signal_t3 = [];
    for curr_cluster=1:num_clusters
        trace = average_traces_by_cluster{group}{curr_cluster};
        sem_signal_pre = [sem_signal_pre; std(trace(:,pre),[],"all") / sqrt(numel(trace(:,pre)))];
        sem_signal_t1 = [sem_signal_t1; std(trace(:,t1),[],"all") / sqrt(numel(trace(:,t1)))];
        sem_signal_t2 = [sem_signal_t2; std(trace(:,t2),[],"all") / sqrt(numel(trace(:,t2)))];
        sem_signal_t3 = [sem_signal_t3; std(trace(:,t3),[],"all") / sqrt(numel(trace(:,t3)))];
    end
    trace_combined = average_traces{group};
    sem_signal_pre = [sem_signal_pre; std(trace_combined(:,pre),[],"all") / sqrt(numel(trace_combined(:,pre)))];
    sem_signal_t1 = [sem_signal_t1; std(trace_combined(:,t1),[],"all") / sqrt(numel(trace_combined(:,t1)))];
    sem_signal_t2 = [sem_signal_t2; std(trace_combined(:,t2),[],"all") / sqrt(numel(trace_combined(:,t2)))];
    sem_signal_t3 = [sem_signal_t3; std(trace_combined(:,t3),[],"all") / sqrt(numel(trace_combined(:,t3)))];

    xlswrite('one_photon_clustering_summary.xlsx', Header, strcat(group_names{group}, ' sem'), 'A1');
    xlswrite('one_photon_clustering_summary.xlsx', (0:num_clusters-1)', strcat(group_names{group}, ' sem'), 'A2');
    xlswrite('one_photon_clustering_summary.xlsx', [sem_signal_pre sem_signal_t1 sem_signal_t2 sem_signal_t3], strcat(group_names{group}, ' sem'), 'B2');
end

% SD of trace
for group=1:num_groups
    sd_signal_pre = [];
    sd_signal_t1 = [];
    sd_signal_t2 = [];
    sd_signal_t3 = [];
    for curr_cluster=1:num_clusters
        trace = average_traces_by_cluster{group}{curr_cluster};
        sd_signal_pre = [sd_signal_pre; std(trace(:,pre),[],"all")];
        sd_signal_t1 = [sd_signal_t1; std(trace(:,t1),[],"all")];
        sd_signal_t2 = [sd_signal_t2; std(trace(:,t2),[],"all")];
        sd_signal_t3 = [sd_signal_t3; std(trace(:,t3),[],"all")];
    end
    trace_combined = average_traces{group};
    sd_signal_pre = [sd_signal_pre; std(trace_combined(:,pre),[],"all")];
    sd_signal_t1 = [sd_signal_t1; std(trace_combined(:,t1),[],"all")];
    sd_signal_t2 = [sd_signal_t2; std(trace_combined(:,t2),[],"all")];
    sd_signal_t3 = [sd_signal_t3; std(trace_combined(:,t3),[],"all")];

    xlswrite('one_photon_clustering_summary.xlsx', Header, strcat(group_names{group}, ' sd'), 'A1');
    xlswrite('one_photon_clustering_summary.xlsx', (0:num_clusters-1)', strcat(group_names{group}, ' sd'), 'A2');
    xlswrite('one_photon_clustering_summary.xlsx', [sd_signal_pre sd_signal_t1 sd_signal_t2 sd_signal_t3], strcat(group_names{group}, ' sd'), 'B2');
end

% AUC of mean trace (for t1 to t3, baseline is already subtracted)
for group=1:num_groups
    AUC_trace_pre = [];
    AUC_trace_t1 = [];
    AUC_trace_t2 = [];
    AUC_trace_t3 = [];
    for curr_cluster=1:num_clusters
        trace = average_traces_by_cluster{group}{curr_cluster};
        AUC_trace_pre = [AUC_trace_pre; trapz(time(pre), mean(trace(:,pre),1))];
        AUC_trace_t1 = [AUC_trace_t1; trapz(time(t1), mean(trace(:,t1),1))];
        AUC_trace_t2 = [AUC_trace_t2; trapz(time(t2), mean(trace(:,t2),1))];
        AUC_trace_t3 = [AUC_trace_t3; trapz(time(t3), mean(trace(:,t3),1))];
    end
    trace_combined = average_traces{group};
    AUC_trace_pre = [AUC_trace_pre; trapz(time(pre), mean(trace_combined(:,pre),1))];
    AUC_trace_t1 = [AUC_trace_t1; trapz(time(t1), mean(trace_combined(:,t1),1))];
    AUC_trace_t2 = [AUC_trace_t2; trapz(time(t2), mean(trace_combined(:,t2),1))];
    AUC_trace_t3 = [AUC_trace_t3; trapz(time(t3), mean(trace_combined(:,t3),1))];
    
    xlswrite('one_photon_clustering_summary.xlsx', Header, strcat(group_names{group}, ' auc'), 'A1');
    xlswrite('one_photon_clustering_summary.xlsx', (0:num_clusters-1)', strcat(group_names{group}, ' auc'), 'A2');
    xlswrite('one_photon_clustering_summary.xlsx', [AUC_trace_pre AUC_trace_t1 AUC_trace_t2 AUC_trace_t3], strcat(group_names{group}, ' auc'), 'B2');
end