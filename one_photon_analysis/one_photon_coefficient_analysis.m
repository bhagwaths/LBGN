% File information
coef_input = '\\niaaa-fcdat2\labdata5\LBSG\Olena Bukalo\AS project\AS data\neurons\neurons 1p\coefficient.xlsx';
trace_input = 'Z:\Olena Bukalo\AS project\AS data\neurons\neurons 1p\ret_clustering_results_HB.xlsx';
output = 'coefficient_output.xlsx';
groups = {'VEH-CNO';
          'CNO-VEH'};

% Coef ranges
Range_Header = {'-0.3 to -0.2', '-0.2 to -0.1', '-0.1 to 0', '0 to 0.1', '0.1 to 0.2', '0.2 to 0.3'};

coef_ranges = {[-.3,-.2];
               [-.2,-.1];
               [-.1,0];
               [0,.1];
               [.1,.2];
               [.2,.3]};

% Read coef data
[coef_data, group] = xlsread(coef_input);
neuron = coef_data(:,1);
coef = coef_data(:,2);
group = group(2:end,4);

% Read Ca2+ data
for i=1:numel(groups)
    trace_data{i} = xlsread(trace_input,sprintf('%s_average_traces', groups{i}));
    cell_id{i} = trace_data{i}(2:end,1);
    trace{i} = trace_data{i}(2:end,2:end);
    time{i} = trace_data{i}(1,2:end);
end

% Sort coef by neuron, so we can find average coef per neuron
[neuron_sorted, sort_idx] = sortrows(neuron);
coef_sorted = coef(sort_idx,:);
group_sorted = group(sort_idx,:);
Mean_Header = {'neuron', 'mean coef', 'group'};
writecell(Mean_Header, output, 'Range', 'A1', 'Sheet', 'mean coef');

neuron_means = [];
coef_means = [];
group_means = [];

mean_coef = {};
% Calculate average coef per neuron, across 5 folds... write to file
for i=1:5:numel(coef_sorted)
    curr_neuron = neuron_sorted(i);
    curr_group = group_sorted(i);
    coef_total = coef_sorted(i:i+4);
    coef_mean = mean(coef_total);
    neuron_means = [neuron_means; curr_neuron];
    coef_means = [coef_means; coef_mean];
    group_means = [group_means; curr_group];
    row_data = [curr_neuron coef_mean curr_group];
    mean_coef = [mean_coef; row_data];
end
writecell(mean_coef, output, 'Range', 'A2', 'Sheet', 'mean_coef');

% Group neurons by coef range, as defined in coef_ranges
for i=1:numel(coef_ranges)
    inrange = find(coef_means >= coef_ranges{i}(1) & coef_means < coef_ranges{i}(2));
    range_neurons = neuron_means(inrange);
    range_groups = group_means(inrange);
    for j=1:numel(groups)
        range_group_neurons = range_neurons(strcmp(range_groups, groups{j}));
        neurons_list{j}{i} = range_group_neurons; %#ok<*SAGROW>
        num_neurons{j}{i} = numel(range_group_neurons);
    end
end

% Write number of neurons to file
writecell(Range_Header, output, 'Range', 'B1', 'Sheet', '# neurons');
writecell(groups, output, 'Range', 'A2', 'Sheet', '# neurons');
num_neurons_combined = [];
for i=1:numel(groups)
    num_neurons_combined = [num_neurons_combined; num_neurons{i}];
end
writecell(num_neurons_combined, output, 'Range', 'B2', 'Sheet', '# neurons');

% Group Ca2+ traces by neuron coef range
plot_colors = {[0 0.4470 0.7410]; [0.8500 0.3250 0.0980]};
cell_ids = cell(1,numel(groups));
neuron_traces = cell(1,numel(groups));
for i=1:numel(groups)
    cell_ids{i} = cell(1,numel(coef_ranges));
    neuron_traces{i} = cell(1,numel(coef_ranges));
end

% Plot average Ca2+ trace (group comparison) for each coef range
for i=1:numel(coef_ranges)
    figure;
    title(sprintf('coef = %s', Range_Header{i})); hold on;
    for j=1:numel(groups)
        cell_id_idx = find(ismember(cell_id{j}, neurons_list{j}{i}));
        cell_ids{j}{i} = [cell_ids{j}{i}; cell_id{j}(cell_id_idx)];
        neuron_trace = trace{j}(cell_id_idx,:);
        neuron_traces{j}{i} = [neuron_traces{j}{i}; neuron_trace];
        mean_neuron_trace = mean(neuron_trace,1);
        sem_neuron_trace = std(neuron_trace,[],1) / sqrt(size(neuron_trace,1));
        plot(time{j}, mean_neuron_trace,'LineWidth',1.5,'Color',plot_colors{j}); hold on;
        errorplot3(mean_neuron_trace-sem_neuron_trace, mean_neuron_trace+sem_neuron_trace, [time{j}(1) time{j}(end)], ...
            plot_colors{j},0.3); hold on;
    end
end

Trace_Header = {'neuron', time{1}};

% Write neuron and Ca2+ data for each group and coef range
for i=1:numel(groups)
    for j=1:numel(coef_ranges)
        sheet_name = sprintf('%s (%s)', groups{i}, Range_Header{j});
        writecell(Trace_Header, output, 'Range', 'A1', 'Sheet', sheet_name);
        writematrix(cell_ids{i}{j}, output, 'Range', 'A2', 'Sheet', sheet_name);
        writematrix(neuron_traces{i}{j}, output, 'Range', 'B2', 'Sheet', sheet_name);
    end
end