filename = 'C:\Users\bhagwaths\Documents\2p area data.xlsx';
output = 'two_photon_spatial_reformatted_HB.xlsx';
mouse_names = {'GR12', 'GR15', 'GR18', 'GR28', 'GR45', 'GR46'};
num_events = {92, 32, 57, 26, 318, 179};
num_clusters = {15, 4, 4, 4, 16, 8};
stages = {'Pre-con', 'F-Con', 'Ext1', 'Ext2', 'E-Ret'};
CS_ranges = {1:5, 6:10, 11:35, 36:60, 61:65};

% read and reformat AQuA event IDs

event_id_data = readtable(filename,'NumHeaderLines',1,'Sheet','AQuA event ID');
area_mean_full_data = readtable(filename,'NumHeaderLines',1','Sheet','Area mean full');
event_duration_full_data = readtable(filename,'NumHeaderLines',1,'Sheet','Event duration full');
vecgrowmean_full_data = readtable(filename,'NumHeaderLines',1,'Sheet','Event vecGrowMean full');
vecgrowsd_full_data = readtable(filename,'NumHeaderLines',1,'Sheet','Event vecGrowSD full');

event_id_table = event_id_data(:,3:8);
area_mean_full_table = area_mean_full_data(:,3:8);
event_duration_full_table = event_duration_full_data(:,3:8);
vecgrowmean_full_table = vecgrowmean_full_data(:,3:8);
vecgrowsd_full_table = vecgrowsd_full_data(:,3:8);

event_ids = cell(65,numel(mouse_names));
for i=1:size(event_id_table,1)
    for j=1:size(event_id_table,2)
        event_ids{i,j} = convert_array(table2array(event_id_table(i,j)));
        area_mean_full{i,j} = convert_array(table2array(area_mean_full_table(i,j)));
        event_duration_full{i,j} = convert_array(table2array(event_duration_full_table(i,j)));
        vecgrowmean_full{i,j} = convert_array(table2array(vecgrowmean_full_table(i,j)));
        vecgrowsd_full{i,j} = convert_array(table2array(vecgrowsd_full_table(i,j)));
    end
end

% read and reformat spatial overlap data
overlap_data = readtable(filename,'Sheet','AQuA eventID ManualCommon');

overlap = cell(size(overlap_data,1),numel(mouse_names));
for i=1:size(overlap_data,1)
    for j=1:size(overlap_data,2)
        overlap{i,j} = convert_array(table2array(overlap_data(i,j)));
    end
end

% clear event_id_data;
clear event_id_table;
clear area_mean_full_data;
clear area_mean_full_table;
clear event_duration_full_data;
clear event_duration_full_table;
clear vecgrowmean_full_data;
clear vecgrowmean_full_table;
clear vecgrowsd_full_data;
clear vecgrowsd_full_table;

all_mice = cell(1,numel(mouse_names));
for mouse=1:numel(mouse_names)
    curr_mouse = [];
    for i=1:size(event_ids,1)
        curr_stage = event_id_data.Var1(i);
        curr_CS = event_id_data.Var2(i);
        for j=1:numel(event_ids{i,mouse})
            curr_event_id = event_ids{i,mouse}(j);
            curr_area_mean_full = area_mean_full{i,mouse}(j);
            curr_event_duration_full = event_duration_full{i,mouse}(j);
            curr_vecgrowmean_full = vecgrowmean_full{i,mouse}(j);
            curr_vecgrowsd_full = vecgrowsd_full{i,mouse}(j);
            curr_row = [curr_event_id, curr_stage, curr_CS, curr_area_mean_full, curr_event_duration_full,...
                curr_vecgrowmean_full, curr_vecgrowsd_full];
            curr_mouse = [curr_mouse; curr_row];
        end
    end
    all_mice{mouse} = curr_mouse;
end

for mouse=1:numel(mouse_names)
    mouse_clusters = [];
    for event=1:num_events{mouse}
        idx = NaN;
        for cluster=1:num_clusters{mouse}
            if ismember(event,overlap{cluster,mouse})
                idx = cluster;
            end
        end
        mouse_clusters = [mouse_clusters; idx];
    end
    all_mice{mouse} = [all_mice{mouse}, num2cell(mouse_clusters)];
end

for mouse=1:numel(mouse_names)
    for i=size(all_mice{mouse},1)
        curr_event_id = all_mice{mouse}(:,1);
    end
end

Header = {'AQuA event ID', 'Stage', 'CS', 'Area mean', 'Event duration', 'Event vecGrowMean', 'Event vecGrowSD', 'Overlap group'};

all_mice_tables = cell(1,numel(mouse_names));
for mouse=1:numel(mouse_names)
    all_mice_tables{mouse} = array2table(all_mice{mouse},'VariableNames',Header);
    writetable(all_mice_tables{mouse},output,'Sheet',mouse_names{mouse});
end

blocks = {1:5, 6:10, 11:15, 16:20, 21:25};

% 5-CS block means
all_mice_mean = cell(1,numel(mouse_names));
for mouse=1:numel(mouse_names)
    mean5CS_rows = [];
    for stage=1:numel(stages)
        if stage ~= 3 && stage ~= 4
            curr_stage = all_mice{mouse}(strcmp(all_mice{mouse}(:,2),stages{stage}),:);
            curr_stage_nums = cell2mat(curr_stage(:,4:7));
            if ~isempty(curr_stage)
                mean5CS = mean(curr_stage_nums,1);
                mean5CS_row = {stages{stage}, "1-5", size(curr_stage,1), mean5CS(1), mean5CS(2), mean5CS(3), mean5CS(4)};
            else
                mean5CS_row = {stages{stage}, "1-5", 0, NaN, NaN, NaN, NaN};
            end
            mean5CS_rows = [mean5CS_rows; mean5CS_row];
        else
            for block=1:numel(blocks)
                curr_block = all_mice{mouse}(strcmp(all_mice{mouse}(:,2),stages{stage}) &...
                    ismember(cell2mat(all_mice{mouse}(:,3)),blocks{block}),:);
                curr_block_nums = cell2mat(curr_block(:,4:7));
                if ~isempty(curr_block)
                    mean5CS = mean(curr_block_nums,1);
                    mean5CS_row = {stages{stage}, sprintf("%d-%d",blocks{block}(1),blocks{block}(end)),...
                        size(curr_block,1), mean5CS(1), mean5CS(2), mean5CS(3), mean5CS(4)};
                else
                    mean5CS_row = {stages{stage}, sprintf("%d-%d",blocks{block}(1),blocks{block}(end)),...
                        0, NaN, NaN, NaN, NaN};
                end
                mean5CS_rows = [mean5CS_rows; mean5CS_row];
            end
        end
    end
    all_mice_mean{mouse} = mean5CS_rows;
end

Header_mean = {'Stage', 'CS', 'Num events', 'Area mean', 'Event duration', 'Event vecGrowMean', 'Event vecGrowSD'};

all_mice_mean_tables = cell(1,numel(mouse_names));
for mouse=1:numel(mouse_names)
    all_mice_mean_tables{mouse} = array2table(all_mice_mean{mouse},'VariableNames',Header_mean);
    writetable(all_mice_mean_tables{mouse},output,'Sheet',sprintf('mean_%s', mouse_names{mouse}));
end

% 5-CS block means - all mice combined
mean5CS_rows = [];
for stage=1:numel(stages)
    if stage ~= 3 && stage ~= 4
        curr_stage_combined = [];
        for mouse=1:numel(mouse_names)
            curr_stage = all_mice{mouse}(strcmp(all_mice{mouse}(:,2),stages{stage}),:);
            curr_stage_combined = [curr_stage_combined; curr_stage];
        end
        curr_stage_combined_nums = cell2mat(curr_stage_combined(:,4:7));
        if ~isempty(curr_stage_combined)
            mean5CS = mean(curr_stage_combined_nums,1);
            mean5CS_row = {stages{stage}, "1-5", size(curr_stage_combined,1), mean5CS(1), mean5CS(2), mean5CS(3), mean5CS(4)};
        else
            mean5CS_row = {stages{stage}, "1-5", 0, NaN, NaN, NaN, NaN};
        end
        mean5CS_rows = [mean5CS_rows; mean5CS_row];
    else
        for block=1:numel(blocks)
            curr_block_combined = [];
            for mouse=1:numel(mouse_names)
                curr_block = all_mice{mouse}(strcmp(all_mice{mouse}(:,2),stages{stage}) &...
                        ismember(cell2mat(all_mice{mouse}(:,3)),blocks{block}),:);
                curr_block_combined = [curr_block_combined; curr_block];
            end
            curr_block_combined_nums = cell2mat(curr_block_combined(:,4:7));
            if ~isempty(curr_block_combined)
                mean5CS = mean(curr_block_combined_nums,1);
                mean5CS_row = {stages{stage}, sprintf("%d-%d",blocks{block}(1),blocks{block}(end)),...
                        size(curr_block_combined,1), mean5CS(1), mean5CS(2), mean5CS(3), mean5CS(4)};
            else
                mean5CS_row = {stages{stage}, sprintf("%d-%d",blocks{block}(1),blocks{block}(end)),...
                    0, NaN, NaN, NaN, NaN};
            end
            mean5CS_rows = [mean5CS_rows; mean5CS_row];
        end
    end 
end

combined_mice_mean_table = array2table(mean5CS_rows,'VariableNames',Header_mean);
writetable(combined_mice_mean_table,output,'Sheet','mean_allMice');

% Overlap analysis
output2 = 'two_photon_spatial_overlap_HB.xlsx';

cluster_data = cell(1,numel(mouse_names));
cluster_stage_pcts = cell(1,numel(mouse_names));
cluster_sizes = cell(1,numel(mouse_names));
for mouse=1:numel(mouse_names)
    mouse_cluster_data = [];
    mouse_cluster_stage_pcts = [];
    mouse_cluster_sizes = [];
    for cluster=1:num_clusters{mouse}
        curr_mouse_data = all_mice{mouse}(:,4:7);
        curr_mouse_stages = all_mice{mouse}(:,2:3);

        curr_cluster_data = cell2mat(curr_mouse_data(cell2mat(all_mice{mouse}(:,8)) == cluster,:));
        curr_cluster_size = size(curr_cluster_data,1);
        mouse_cluster_sizes = [mouse_cluster_sizes; curr_cluster_size];
        mean_cluster = mean(curr_cluster_data,1);
        mouse_cluster_data = [mouse_cluster_data; mean_cluster];

        curr_cluster_data_stages = curr_mouse_stages(cell2mat(all_mice{mouse}(:,8)) == cluster,:);
        curr_cluster_stage_pcts = [];
        for stage=1:numel(stages)
            if stage ~= 3 && stage ~= 4
                curr_stage = sprintf("%s 1-5", stages{stage});
                curr_stage_cond = nnz(strcmp(curr_cluster_data_stages(:,1),stages{stage}));
                pct_curr_stage = curr_stage_cond;
                curr_cluster_stage_pcts = [curr_cluster_stage_pcts, pct_curr_stage];
            else
                for block=1:numel(blocks)
                    curr_stage = sprintf("%s %d-%d", stages{stage}, blocks{block}(1), blocks{block}(end));
                    curr_stage_cond = nnz(strcmp(curr_cluster_data_stages(:,1),stages{stage}) &...
                        cell2mat(curr_cluster_data_stages(:,2)) >= blocks{block}(1) & cell2mat(curr_cluster_data_stages(:,2))...
                        <= blocks{block}(end));
                    pct_curr_stage = curr_stage_cond;
                    curr_cluster_stage_pcts = [curr_cluster_stage_pcts, pct_curr_stage];
                end
            end
        end
        mouse_cluster_stage_pcts = [mouse_cluster_stage_pcts; curr_cluster_stage_pcts];
    end
    cluster_data{mouse} = mouse_cluster_data;
    cluster_stage_pcts{mouse} = mouse_cluster_stage_pcts;
    cluster_sizes{mouse} = mouse_cluster_sizes;
end

Header_clusters = {'Overlap group', 'Num events', 'Area mean', 'Event duration', 'Event vecGrowMean', 'Event vecGrowSD'};

Header_stages = {'Overlap group', 'Num events', 'Pre-con 1-5', 'F-Con 1-5', 'Ext1 1-5', 'Ext1 6-10', 'Ext1 11-15', 'Ext1 16-20', 'Ext1 21-25',...
    'Ext2 1-5', 'Ext2 6-10', 'Ext2 11-15', 'Ext2 16-20', 'Ext2 21-25', 'E-Ret 1-5'};

for mouse=1:numel(mouse_names)
    data_stage_array{mouse} = [(1:num_clusters{mouse})', cluster_sizes{mouse}, cluster_data{mouse}];
    data_stage_table{mouse} = array2table(data_stage_array{mouse},'VariableNames',Header_clusters);
    writetable(data_stage_table{mouse},output2,'Sheet',sprintf('%s_data',mouse_names{mouse}));
end

for mouse=1:numel(mouse_names)
    pct_stage_array{mouse} = [(1:num_clusters{mouse})', cluster_sizes{mouse}, cluster_stage_pcts{mouse}];
    pct_stage_table{mouse} = array2table(pct_stage_array{mouse},'VariableNames',Header_stages);
    writetable(pct_stage_table{mouse},output2,'Sheet',sprintf('%s_stages', mouse_names{mouse}));
end

function [result] = convert_array(str_array)
    if strcmp(str_array,'[]')
        result = [];
    elseif ~isnan(str2double(str_array))
        result = str2double(str_array);
    else
        str_array_cut = str_array{1}(2:end-1);
        str_array_split = split(str_array_cut,',');
        str_array_split = split(str_array_split,';');
        result = str2double(str_array_split);
    end
end