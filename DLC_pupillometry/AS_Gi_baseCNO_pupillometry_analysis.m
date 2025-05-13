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
    '8.AS-Gi-24';
    'AS-Gi-3-CNO';
    'AS-Gi-4-CNO'};

groupNames = {'mCherry', 'Gi', 'CNO'};

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
        'mCherry';
        'CNO';
        'CNO'};

filenames = {"C:\Users\bhagwaths\Desktop\8.AS-Gi_pupillometry_DLC_results\coordinates\8.AS-Gi-5_base+CNO_croppedDLC_Resnet50_AS-Gi_pupillometryApr1shuffle1_snapshot_040.csv";
"C:\Users\bhagwaths\Desktop\8.AS-Gi_pupillometry_DLC_results\coordinates\8.AS-Gi-6_base+CNO_croppedDLC_Resnet50_AS-Gi_pupillometryApr1shuffle1_snapshot_040.csv";
"C:\Users\bhagwaths\Desktop\8.AS-Gi_pupillometry_DLC_results\coordinates\8.AS-Gi-9_base+CNO_croppedDLC_Resnet50_AS-Gi_pupillometryApr1shuffle1_snapshot_040.csv";
"C:\Users\bhagwaths\Desktop\8.AS-Gi_pupillometry_DLC_results\coordinates\8.AS-Gi-10_base+CNO_croppedDLC_Resnet50_AS-Gi_pupillometryApr1shuffle1_snapshot_040.csv";
"C:\Users\bhagwaths\Desktop\8.AS-Gi_pupillometry_DLC_results\coordinates\8.AS-Gi-15_base+CNO_croppedDLC_Resnet50_AS-Gi_pupillometryApr1shuffle1_snapshot_040.csv";
"C:\Users\bhagwaths\Desktop\8.AS-Gi_pupillometry_DLC_results\coordinates\8.AS-Gi-16_base+CNO_croppedDLC_Resnet50_AS-Gi_pupillometryApr1shuffle1_snapshot_040.csv";
"C:\Users\bhagwaths\Desktop\8.AS-Gi_pupillometry_DLC_results\coordinates\8.AS-Gi-17_base+CNO_croppedDLC_Resnet50_AS-Gi_pupillometryApr1shuffle1_snapshot_040.csv";
"C:\Users\bhagwaths\Desktop\8.AS-Gi_pupillometry_DLC_results\coordinates\8.AS-Gi-18_base+CNO_croppedDLC_Resnet50_AS-Gi_pupillometryApr1shuffle1_snapshot_040.csv";
"C:\Users\bhagwaths\Desktop\8.AS-Gi_pupillometry_DLC_results\coordinates\8.AS-Gi-19_base+CNO_croppedDLC_Resnet50_AS-Gi_pupillometryApr1shuffle1_snapshot_040.csv";
"C:\Users\bhagwaths\Desktop\8.AS-Gi_pupillometry_DLC_results\coordinates\8.AS-Gi-20_base+CNO_croppedDLC_Resnet50_AS-Gi_pupillometryApr1shuffle1_snapshot_040.csv";
"C:\Users\bhagwaths\Desktop\8.AS-Gi_pupillometry_DLC_results\coordinates\8.AS-Gi-21_base+CNO_croppedDLC_Resnet50_AS-Gi_pupillometryApr1shuffle1_snapshot_040.csv";
"C:\Users\bhagwaths\Desktop\8.AS-Gi_pupillometry_DLC_results\coordinates\8.AS-Gi-22_base+CNO_croppedDLC_Resnet50_AS-Gi_pupillometryApr1shuffle1_snapshot_040.csv";
"C:\Users\bhagwaths\Desktop\8.AS-Gi_pupillometry_DLC_results\coordinates\8.AS-Gi-23_base+CNO_croppedDLC_Resnet50_AS-Gi_pupillometryApr1shuffle1_snapshot_040.csv";
"C:\Users\bhagwaths\Desktop\8.AS-Gi_pupillometry_DLC_results\coordinates\8.AS-Gi-24_base+CNO_croppedDLC_Resnet50_AS-Gi_pupillometryApr1shuffle1_snapshot_040.csv";
"C:\Users\bhagwaths\Desktop\AS-Gi_tail_pupillometry_DLC_results\coordinates\AS-Gi-3_tail_base+CNO_croppedDLC_Resnet50_AS-Gi_pupillometryApr1shuffle1_snapshot_040.csv";
"C:\Users\bhagwaths\Desktop\AS-Gi_tail_pupillometry_DLC_results\coordinates\AS-Gi-4_tail_base+CNO_croppedDLC_Resnet50_AS-Gi_pupillometryApr1shuffle1_snapshot_040.csv"};

injection_times = [195;
                   192;
                   193;
                   191;
                   197;
                   221;
                   200;
                   195;
                   192;
                   219;
                   198;
                   194;
                   203;
                   209;
                   195;
                   186];

FPS = 10;
time_range = [-180, 1450];
likelihood_thresh = 0.75; % areas with likelihoods below this threshold are marked in the plot

AUC_time_ranges = {[-180,0];
                   [0,1610];
                   [0,540];
                   [540,1080];
                   [1080,1450]};

AUC_filename = 'AS-Gi_base+CNO_pupillometry_AUCs.xlsx';

%% Individual pupil areas, marking low likelihoods

times_combined = cell(1,numel(groupNames));
areas_combined = cell(1,numel(groupNames));

for mouse=1:numel(filenames)
    curr_group = find(strcmp(groupNames,groups{mouse}));

    data = readtable(filenames{mouse},'NumHeaderLines',3);
    
    coords = data.Var1;
    times = (coords / FPS) - injection_times(mouse);
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
    plot(times, areas, 'LineWidth', 2); hold on;
    plot(times, low_prob_times, 'LineWidth', 10, 'Color', 'r');
    xline(0, '--', 'Label', 'CNO');
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
    plot(mean_times,mean_areas,'LineWidth',2); hold on;
    errorplot3(mean_areas-sem_areas,mean_areas+sem_areas,time_range,[0 0.4470 0.7410],0.2); hold on;
    xline(0, '--', 'Label', 'CNO');
    xlabel('Time (s)');
    ylabel('Mean pupil area');
    title(sprintf('All mice (%s)', groupNames{group}));
end


%% AUCs by time range

header = cellfun(@(x) sprintf('%d-%ds', x(1), x(2)), AUC_time_ranges, 'UniformOutput', false)';

group_AUCs = cell(1,numel(groupNames));

for group=1:numel(groupNames)
    group_AUCs{group} = [];
    for i=1:numel(AUC_time_ranges)
        curr_duration = AUC_time_ranges{i}(2) - AUC_time_ranges{i}(1);
        full_duration = time_range(2) - time_range(1);
        ratio = full_duration / curr_duration;
        time_range_idx = times >= AUC_time_ranges{i}(1) & times < AUC_time_ranges{i}(2);
        time_range_times = times(time_range_idx);
        time_range_areas = areas_combined{group}(:,time_range_idx);
        time_range_AUCs = trapz(time_range_times, time_range_areas, 2) * ratio;
        group_AUCs{group} = [group_AUCs{group}, time_range_AUCs];
    end

    writecell(header,AUC_filename,'Range','A1','Sheet',groupNames{group});
    writematrix(group_AUCs{group},AUC_filename,'Range','A2','Sheet',groupNames{group});
end
