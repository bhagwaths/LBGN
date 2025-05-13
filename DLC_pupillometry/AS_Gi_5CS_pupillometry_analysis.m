% Set inputs

names = {'8.AS-Gi-5';
    '8.AS-Gi-6';
    '8.AS-Gi-9';
    '8.AS-Gi-10';
    '8.AS-Gi-15';
    '8.AS-Gi-16';
    '8.AS-Gi-17';
    '8.AS-Gi-18';
    '8.AS-Gi-19';
    '8.AS-Gi-20';
    '8.AS-Gi-21';
    '8.AS-Gi-22';
    '8.AS-Gi-23';
    '8.AS-Gi-24'};

groupNames = {'mCherry', 'Gi'};

groups = {'Gi';
        'mCherry';
        'Gi';
        'mCherry';
        'mCherry';
        'Gi';
        'Gi';
        'Gi';
        'Gi';
        'Gi';
        'Gi';
        'Gi';
        'mCherry';
        'mCherry'};

filenames = {"C:\Users\bhagwaths\Desktop\8.AS-Gi_pupillometry_DLC_results\coordinates\8.AS-Gi-5_5CS_croppedDLC_Resnet50_AS-Gi_pupillometryApr1shuffle1_snapshot_040.csv";
"C:\Users\bhagwaths\Desktop\8.AS-Gi_pupillometry_DLC_results\coordinates\8.AS-Gi-6_5CS_croppedDLC_Resnet50_AS-Gi_pupillometryApr1shuffle1_snapshot_040.csv";
"C:\Users\bhagwaths\Desktop\8.AS-Gi_pupillometry_DLC_results\coordinates\8.AS-Gi-9_5CS_croppedDLC_Resnet50_AS-Gi_pupillometryApr1shuffle1_snapshot_040.csv";
"C:\Users\bhagwaths\Desktop\8.AS-Gi_pupillometry_DLC_results\coordinates\8.AS-Gi-10_5CS_croppedDLC_Resnet50_AS-Gi_pupillometryApr1shuffle1_snapshot_040.csv";
"C:\Users\bhagwaths\Desktop\8.AS-Gi_pupillometry_DLC_results\coordinates\8.AS-Gi-15_5CS_croppedDLC_Resnet50_AS-Gi_pupillometryApr1shuffle1_snapshot_040.csv";
"C:\Users\bhagwaths\Desktop\8.AS-Gi_pupillometry_DLC_results\coordinates\8.AS-Gi-16_5CS_croppedDLC_Resnet50_AS-Gi_pupillometryApr1shuffle1_snapshot_040.csv";
"C:\Users\bhagwaths\Desktop\8.AS-Gi_pupillometry_DLC_results\coordinates\8.AS-Gi-17_5CS_croppedDLC_Resnet50_AS-Gi_pupillometryApr1shuffle1_snapshot_040.csv";
"C:\Users\bhagwaths\Desktop\8.AS-Gi_pupillometry_DLC_results\coordinates\8.AS-Gi-18_5CS_croppedDLC_Resnet50_AS-Gi_pupillometryApr1shuffle1_snapshot_040.csv";
"C:\Users\bhagwaths\Desktop\8.AS-Gi_pupillometry_DLC_results\coordinates\8.AS-Gi-19_5CS_croppedDLC_Resnet50_AS-Gi_pupillometryApr1shuffle1_snapshot_040.csv";
"C:\Users\bhagwaths\Desktop\8.AS-Gi_pupillometry_DLC_results\coordinates\8.AS-Gi-20_5CS_croppedDLC_Resnet50_AS-Gi_pupillometryApr1shuffle1_snapshot_040.csv";
"C:\Users\bhagwaths\Desktop\8.AS-Gi_pupillometry_DLC_results\coordinates\8.AS-Gi-21_5CS_croppedDLC_Resnet50_AS-Gi_pupillometryApr1shuffle1_snapshot_040.csv";
"C:\Users\bhagwaths\Desktop\8.AS-Gi_pupillometry_DLC_results\coordinates\8.AS-Gi-22_5CS_croppedDLC_Resnet50_AS-Gi_pupillometryApr1shuffle1_snapshot_040.csv";
"C:\Users\bhagwaths\Desktop\8.AS-Gi_pupillometry_DLC_results\coordinates\8.AS-Gi-23_5CS_croppedDLC_Resnet50_AS-Gi_pupillometryApr1shuffle1_snapshot_040.csv";
"C:\Users\bhagwaths\Desktop\8.AS-Gi_pupillometry_DLC_results\coordinates\8.AS-Gi-24_5CS_croppedDLC_Resnet50_AS-Gi_pupillometryApr1shuffle1_snapshot_040.csv"};

first_CS_onset_times = [182;
                        179;
                        179;
                        179;
                        179;
                        181;
                        183;
                        195;
                        184;
                        181;
                        182;
                        182;
                        186;
                        182];

FPS = 10;
time_range = [-179, 430];
likelihood_thresh = 0.75; % areas with likelihoods below this threshold are marked in the plot
CS_onset_times = [0, 90, 180, 270, 360];
CS_offset_times = [30, 120, 210, 300, 390];
CS_time_range = [-5,5];

AUC_filename = 'AS-Gi_5CS_pupillometry_AUCs.xlsx';

%% Individual pupil areas, marking low likelihoods

times_combined = cell(1,numel(groupNames));
areas_combined = cell(1,numel(groupNames));

for mouse=1:numel(filenames)
    curr_group = find(strcmp(groupNames,groups{mouse}));

    data = readtable(filenames{mouse},'NumHeaderLines',3);
        
    coords = data.Var1;
    times = (coords / FPS) - first_CS_onset_times(mouse);
    x = [data.Var2, data.Var5, data.Var8, data.Var11, data.Var14, data.Var17, data.Var20, data.Var23];
    y = [data.Var3, data.Var6, data.Var9, data.Var12, data.Var15, data.Var18, data.Var21, data.Var24];
    likelihoods = [data.Var4, data.Var7, data.Var10, data.Var13, data.Var16, data.Var19, data.Var22, data.Var25];
    
    low_prob_times = NaN(size(coords));
    
    areas = [];
    for i=1:height(coords)
        curr_area = polyarea(x(i,:), y(i,:));
        areas = [areas; curr_area];
    end

    idx = times >= time_range(1) & times <= time_range(2);

    areas = areas(idx);
    times = times(idx);
    low_prob_times = low_prob_times(idx);
    likelihoods = likelihoods(idx,:);

    mean_area_val = mean(areas);

    for i=1:length(times)
        if nnz(likelihoods(i,:) < likelihood_thresh) > 0
            low_prob_times(i) = mean_area_val;
        end
    end
    
    figure;
    for i=1:numel(CS_onset_times)
       a = CS_onset_times(i);
       patch([a a+30 a+30 a], [min(areas) min(areas) max(areas) max(areas)], [.8 1 1], 'EdgeColor','none');
       hold on;
    end
    plot(times, areas, 'LineWidth', 2); hold on;
    plot(times, low_prob_times, 'LineWidth', 10, 'Color', 'r');
    xlabel('Time (s)');
    ylabel('Pupil area');
    title(sprintf('%s (%s)', names{mouse}, groupNames{curr_group}));

    times_combined{curr_group} = [times_combined{curr_group}; times'];
    areas_combined{curr_group} = [areas_combined{curr_group}; areas'];
end

%% Average pupil area

for group=1:numel(groupNames)
    mean_times = mean(times_combined{group},1);
    mean_areas = mean(areas_combined{group},1);
    sem_areas = std(areas_combined{group},[],1) / sqrt(size(areas_combined{group},1));
    
    figure;
    for i=1:numel(CS_onset_times)
       a = CS_onset_times(i);
       patch([a a+30 a+30 a], [min(mean_areas-sem_areas) min(mean_areas-sem_areas) max(mean_areas+sem_areas) max(mean_areas+sem_areas)], [.8 1 1], 'EdgeColor','none');
       hold on;
    end
    plot(mean_times,mean_areas,'LineWidth',2); hold on;
    errorplot3(mean_areas-sem_areas,mean_areas+sem_areas,time_range,[0 0.4470 0.7410],0.2); hold on;
    xlabel('Time (s)');
    ylabel('Mean pupil area');
    title(sprintf('All mice (%s)', groupNames{group}));
end

%% Average pupil area at CS onset

figure;
plot_colors = {[0 0.4470 0.7410]; [0.8500 0.3250 0.0980]};

CS_onset_times_combined = cell(1,numel(groupNames));
CS_onset_areas_combined = cell(1,numel(groupNames));

for group=1:numel(groupNames)
    CS_onset_times_combined{group} = [];
    CS_onset_areas_combined{group} = [];
    for CS=1:numel(CS_onset_times)
        curr_CS_idx = times_combined{group}(1,:) >= CS_onset_times(CS)+CS_time_range(1) & times_combined{group}(1,:) <= CS_onset_times(CS)+CS_time_range(2);
        curr_CS_times = times_combined{group}(:,curr_CS_idx);
        curr_CS_areas = areas_combined{group}(:,curr_CS_idx);
        CS_onset_times_combined{group} = [CS_onset_times_combined{group}; curr_CS_times-CS_onset_times(CS)];
        CS_onset_areas_combined{group} = [CS_onset_areas_combined{group}; curr_CS_areas];
    end

    group_size = size(times_combined{group},1);
    for i=1:group_size
        idx = i:group_size:size(CS_onset_times_combined{group},1);
        mean_CS_onset_areas_CSavg{group}(i,:) = mean(CS_onset_areas_combined{group}(idx,:),1);
        sem_CS_onset_areas_CSavg{group}(i,:) = std(CS_onset_areas_combined{group}(idx,:),[],1) / sqrt(size(CS_onset_areas_combined{group}(idx,:),1));
    end

    mean_CS_onset_areas = mean(CS_onset_areas_combined{group},1);
    sem_CS_onset_areas = std(CS_onset_areas_combined{group},[],1) / sqrt(size(CS_onset_areas_combined{group},1));

    plot(linspace(CS_time_range(1),CS_time_range(2),numel(mean_CS_onset_areas)),mean_CS_onset_areas,'LineWidth',2,'Color',plot_colors{group});
    errorplot3(mean_CS_onset_areas-sem_CS_onset_areas,mean_CS_onset_areas+sem_CS_onset_areas,CS_time_range,plot_colors{group},0.2); hold on;
    h = xline(0,'--');
    h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    xlabel('Time from CS onset (s)');
    ylabel('Mean pupil area');
    title('CS onset');
end

legend_groupNames = reshape([groupNames; repmat({''}, 1, numel(groupNames))], 1, []);
legend(legend_groupNames);

%% Average pupil area at CS offset

figure;
plot_colors = {[0 0.4470 0.7410]; [0.8500 0.3250 0.0980]};

CS_offset_times_combined = cell(1,numel(groupNames));
CS_offset_areas_combined = cell(1,numel(groupNames));

for group=1:numel(groupNames)
    CS_offset_times_combined{group} = [];
    CS_offset_areas_combined{group} = [];
    for CS=1:numel(CS_offset_times)
        curr_CS_idx = times_combined{group}(1,:) >= CS_offset_times(CS)+CS_time_range(1) & times_combined{group}(1,:) <= CS_offset_times(CS)+CS_time_range(2);
        curr_CS_times = times_combined{group}(:,curr_CS_idx);
        curr_CS_areas = areas_combined{group}(:,curr_CS_idx);
        CS_offset_times_combined{group} = [CS_offset_times_combined{group}; curr_CS_times-CS_offset_times(CS)];
        CS_offset_areas_combined{group} = [CS_offset_areas_combined{group}; curr_CS_areas];
    end
    
    group_size = size(times_combined{group},1);
    for i=1:group_size
        idx = i:group_size:size(CS_offset_times_combined{group},1);
        mean_CS_offset_areas_CSavg{group}(i,:) = mean(CS_offset_areas_combined{group}(idx,:),1);
        sem_CS_offset_areas_CSavg{group}(i,:) = std(CS_offset_areas_combined{group}(idx,:),[],1) / sqrt(size(CS_offset_areas_combined{group}(idx,:),1));
    end

    mean_CS_offset_areas = mean(CS_offset_areas_combined{group},1);
    sem_CS_offset_areas = std(CS_offset_areas_combined{group},[],1) / sqrt(size(CS_offset_areas_combined{group},1));

    plot(linspace(CS_time_range(1),CS_time_range(2),numel(mean_CS_offset_areas)),mean_CS_offset_areas,'LineWidth',2,'Color',plot_colors{group});
    errorplot3(mean_CS_offset_areas-sem_CS_offset_areas,mean_CS_offset_areas+sem_CS_offset_areas,CS_time_range,plot_colors{group},0.2); hold on;
    h = xline(0,'--');
    h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    xlabel('Time from CS offset (s)');
    ylabel('Mean pupil area');
    title('CS offset');
end

legend_groupNames = reshape([groupNames; repmat({''}, 1, numel(groupNames))], 1, []);
legend(legend_groupNames);

%% AUCs by time range

AUC_pre_time = [-5,0];
AUC_post_time = [0,5];

header = cellfun(@(x) sprintf('%d-%ds', x(1), x(2)), {AUC_pre_time, AUC_post_time}, 'UniformOutput', false);

pre_duration = AUC_pre_time(2) - AUC_pre_time(1);
post_duration = AUC_post_time(2) - AUC_post_time(1);
pre_post_ratio = post_duration / pre_duration;

for group=1:numel(groupNames)
    % CS onset
    pre_idx = CS_onset_times_combined{group}(1,:) >= AUC_pre_time(1) & CS_onset_times_combined{group}(1,:) < AUC_pre_time(2);
    post_idx = CS_onset_times_combined{group}(1,:) >= AUC_post_time(1) & CS_onset_times_combined{group}(1,:) < AUC_post_time(2);

    CS_onset_times_pre = CS_onset_times_combined{group}(1,pre_idx);
    CS_onset_times_post = CS_onset_times_combined{group}(1,post_idx);
    CS_onset_areas_pre = mean_CS_onset_areas_CSavg{group}(:,pre_idx);
    CS_onset_areas_post = mean_CS_onset_areas_CSavg{group}(:,post_idx);

    CS_onset_AUCs_pre = trapz(CS_onset_times_pre,CS_onset_areas_pre,2);
    CS_onset_AUCs_post = trapz(CS_onset_times_post,CS_onset_areas_post,2) / pre_post_ratio;
    CS_onset_AUCs_pre_post = [CS_onset_AUCs_pre, CS_onset_AUCs_post];

    writecell(header,AUC_filename,'Range','A1','Sheet',sprintf('CS onset (%s)', groupNames{group}));
    writematrix(CS_onset_AUCs_pre_post,AUC_filename,'Range','A2','Sheet',sprintf('CS onset (%s)', groupNames{group}));

    % CS offset
    pre_idx = CS_offset_times_combined{group}(1,:) >= AUC_pre_time(1) & CS_offset_times_combined{group}(1,:) < AUC_pre_time(2);
    post_idx = CS_offset_times_combined{group}(1,:) >= AUC_post_time(1) & CS_offset_times_combined{group}(1,:) < AUC_post_time(2);

    CS_offset_times_pre = CS_offset_times_combined{group}(1,pre_idx);
    CS_offset_times_post = CS_offset_times_combined{group}(1,post_idx);
    CS_offset_areas_pre = mean_CS_offset_areas_CSavg{group}(:,pre_idx);
    CS_offset_areas_post = mean_CS_offset_areas_CSavg{group}(:,post_idx);

    CS_offset_AUCs_pre = trapz(CS_offset_times_pre,CS_offset_areas_pre,2);
    CS_offset_AUCs_post = trapz(CS_offset_times_post,CS_offset_areas_post,2) / pre_post_ratio;
    CS_offset_AUCs_pre_post = [CS_offset_AUCs_pre, CS_offset_AUCs_post];

    writecell(header,AUC_filename,'Range','A1','Sheet',sprintf('CS offset (%s)', groupNames{group}));
    writematrix(CS_offset_AUCs_pre_post,AUC_filename,'Range','A2','Sheet',sprintf('CS offset (%s)', groupNames{group}));
end