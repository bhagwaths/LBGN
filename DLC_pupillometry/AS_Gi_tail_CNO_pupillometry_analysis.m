% Set inputs

names = {'AS-Gi-3';
         'AS-Gi-4';
         'AS-Gi-7';
         'AS-Gi-8';
         'AS-Gi-11';
         'AS-Gi-12'};

groupNames = {'mCherry','Gi'};

groups = {'Gi';
          'mCherry';
          'Gi';
          'mCherry';
          'mCherry';
          'Gi'};

filenames = {"C:\Users\bhagwaths\Desktop\AS-Gi_tail_pupillometry_DLC_results\coordinates\AS-Gi-3_tail_CNO_croppedDLC_Resnet50_AS-Gi_pupillometryApr1shuffle1_snapshot_040.csv";
"C:\Users\bhagwaths\Desktop\AS-Gi_tail_pupillometry_DLC_results\coordinates\AS-Gi-4_tail_CNO_croppedDLC_Resnet50_AS-Gi_pupillometryApr1shuffle1_snapshot_040.csv";
"C:\Users\bhagwaths\Desktop\AS-Gi_tail_pupillometry_DLC_results\coordinates\AS-Gi-7_tail_CNO_croppedDLC_Resnet50_AS-Gi_pupillometryApr1shuffle1_snapshot_040.csv";
"C:\Users\bhagwaths\Desktop\AS-Gi_tail_pupillometry_DLC_results\coordinates\AS-Gi-8_tail_CNO_croppedDLC_Resnet50_AS-Gi_pupillometryApr1shuffle1_snapshot_040.csv";
"C:\Users\bhagwaths\Desktop\AS-Gi_tail_pupillometry_DLC_results\coordinates\AS-Gi-11_tail_CNO_croppedDLC_Resnet50_AS-Gi_pupillometryApr1shuffle1_snapshot_040.csv";
"C:\Users\bhagwaths\Desktop\AS-Gi_tail_pupillometry_DLC_results\coordinates\AS-Gi-12_tail_CNO_croppedDLC_Resnet50_AS-Gi_pupillometryApr1shuffle1_snapshot_040.csv"};

% 180, 240, 300, 360, 420
tail_pinch_times = {[180, 242, 300, 359, 420];
                    [181, 245, 313, 360, 420];
                    [181, 244, 301, 363, 423];
                    [179, 241, 301, 361, 420];
                    [182, 241, 303, 362, 424];
                    [180, 240, 303, 360, 421]};

FPS = 10;
time_range = [-179, 300];
likelihood_thresh = 0.75; % areas with likelihoods below this threshold are marked in the plot

AUC_filename = 'AS-Gi_tail_CNO_pupillometry_AUCs.xlsx';

plot_colors = {[0 0.4470 0.7410]; [0.4660 0.6740 0.1880]};

pinch_time_range = [-15,15];

AUC_pre_time = [-15,0];
AUC_post_time = [0,15];

AUC_base_time = [-179,0];
AUC_trial_time = [0,300];

%% Individual pupil areas, marking low likelihoods

times_combined = cell(1,numel(groupNames));
areas_combined = cell(1,numel(groupNames));

for mouse=1:numel(filenames)
    curr_group = find(strcmp(groupNames,groups{mouse}));

    data = readtable(filenames{mouse},'NumHeaderLines',3);
        
    coords = data.Var1;
    times = (coords / FPS) - tail_pinch_times{mouse}(1);
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
    for i=1:numel(tail_pinch_times{mouse})
       a = tail_pinch_times{mouse}(i) - tail_pinch_times{mouse}(1);
       xline(a,'Label','Tail pinch', 'LineStyle', ':', 'Color', 'r');
       hold on;
    end
    plot(times, areas, 'LineWidth', 2, 'Color', plot_colors{curr_group}); hold on;
    plot(times, low_prob_times, 'LineWidth', 10, 'Color', 'r');
    xlabel('Time (s)');
    ylabel('Pupil area');
    title(sprintf('%s (%s)', names{mouse}, groupNames{curr_group}));

    times_combined{curr_group} = [times_combined{curr_group}; times'];
    areas_combined{curr_group} = [areas_combined{curr_group}; areas'];
end

AUCs_base = cell(1,numel(groupNames));
AUCs_trial = cell(1,numel(groupNames));

header = cellfun(@(x) sprintf('%d-%ds', x(1), x(2)), {AUC_base_time, AUC_trial_time}, 'UniformOutput', false);

base_duration = AUC_base_time(2) - AUC_base_time(1);
trial_duration = AUC_trial_time(2) - AUC_trial_time(1);
base_trial_ratio = trial_duration / base_duration;

for group=1:numel(groupNames)
    AUCs_base{group} = [];
    AUCs_trial{group} = [];
    for i=1:size(areas_combined{group},1)
        base_time = times_combined{group}(i,times_combined{group}(i,:)>=AUC_base_time(1) & times_combined{group}(i,:)<AUC_base_time(2));
        base_areas = areas_combined{group}(i,times_combined{group}(i,:)>=AUC_base_time(1) & times_combined{group}(i,:)<AUC_base_time(2));
        trial_time = times_combined{group}(i,times_combined{group}(i,:)>=AUC_trial_time(1) & times_combined{group}(i,:)<AUC_trial_time(2));
        trial_areas = areas_combined{group}(i,times_combined{group}(i,:)>=AUC_trial_time(1) & times_combined{group}(i,:)<AUC_trial_time(2));
        base_areas_norm = base_areas - median(base_areas);
        trial_areas_norm = trial_areas - median(base_areas);
        AUCs_base{group} = [AUCs_base{group}; trapz(base_time,base_areas_norm)];
        AUCs_trial{group} = [AUCs_trial{group}; trapz(trial_time,trial_areas_norm) / base_trial_ratio];    
    end
    curr_AUCs = [AUCs_base{group}, AUCs_trial{group}];
    writecell(header,AUC_filename,'Range','A1','Sheet',sprintf('%s (session)', groupNames{group}));
    writematrix(curr_AUCs,AUC_filename,'Range','A2','Sheet',sprintf('%s (session)', groupNames{group}));
end

%% Average pupil area

pinch_times_by_group = cell(1,numel(groupNames));

for mouse=1:numel(filenames)
    curr_group = find(strcmp(groupNames,groups{mouse}));
    pinch_times_by_group{curr_group} = [pinch_times_by_group{curr_group}; tail_pinch_times{mouse}];
    pinch_times_by_group{curr_group} = pinch_times_by_group{curr_group} - pinch_times_by_group{curr_group}(:,1);
end

for group=1:numel(groupNames)
    mean_pinch_times_by_group{group} = mean(pinch_times_by_group{group},1);
end

for group=1:numel(groupNames)
    mean_times = mean(times_combined{group},1);
    mean_areas = mean(areas_combined{group},1);
    sem_areas = std(areas_combined{group},[],1) / sqrt(size(areas_combined{group},1));
    
    figure;
    for i=1:numel(mean_pinch_times_by_group{group})
       xline(mean_pinch_times_by_group{group}(i),'Label','Tail pinch', 'LineStyle', ':', 'Color', 'r');
       hold on;
    end
    plot(mean_times,mean_areas,'LineWidth',2,'Color',plot_colors{group}); hold on;
    errorplot3(mean_areas-sem_areas,mean_areas+sem_areas,time_range,plot_colors{group},0.2); hold on;
    xlabel('Time (s)');
    ylabel('Mean pupil area');
    title(sprintf('All mice (%s)', groupNames{group}));
end

%% Average pupil area at tail pinch

for group=1:numel(groupNames)
    pinch_areas_combined{group} = [];
    mean_curr_mouse_areas{group} = [];
    for mouse=1:size(pinch_times_by_group{group},1)
        curr_mouse_areas = [];
        for pinch_time=1:size(pinch_times_by_group{group},2)
            curr_pinch_time = pinch_times_by_group{group}(mouse,pinch_time);
            curr_times = times_combined{group}(mouse,times_combined{group}(mouse,:) >= curr_pinch_time+pinch_time_range(1) & times_combined{group}(mouse,:) <= curr_pinch_time+pinch_time_range(2));
            curr_areas = areas_combined{group}(mouse,times_combined{group}(mouse,:) >= curr_pinch_time+pinch_time_range(1) & times_combined{group}(mouse,:) <= curr_pinch_time+pinch_time_range(2));
            pinch_areas_combined{group} = [pinch_areas_combined{group}; curr_areas];
            curr_mouse_areas = [curr_mouse_areas; curr_areas];
        end
        mean_curr_mouse_areas{group} = [mean_curr_mouse_areas{group}; mean(curr_mouse_areas,1)];
    end
    mean_pinch_areas{group} = mean(pinch_areas_combined{group},1);
    sem_pinch_areas{group} = std(pinch_areas_combined{group},[],1) / sqrt(size(pinch_areas_combined{group},1));
end

pinch_x_range = linspace(pinch_time_range(1),pinch_time_range(2),length(mean_pinch_areas{1}));

for group=1:numel(groupNames)
    figure;
    plot(pinch_x_range, mean_pinch_areas{group},'LineWidth',2,'Color',plot_colors{group});
    errorplot3(mean_pinch_areas{group}-sem_pinch_areas{group},mean_pinch_areas{group}+sem_pinch_areas{group},...
        [pinch_time_range(1),pinch_time_range(2)], plot_colors{group},0.2);
    xline(0,'Label','Tail pinch', 'LineStyle',':');
    xlabel('Time from tail pinch (s)');
    ylabel('Mean pupil area');
    title(sprintf('All mice (%s)', groupNames{group}));
end

header = cellfun(@(x) sprintf('%d-%ds', x(1), x(2)), {AUC_pre_time, AUC_post_time}, 'UniformOutput', false);

pre_duration = AUC_pre_time(2) - AUC_pre_time(1);
post_duration = AUC_post_time(2) - AUC_post_time(1);
pre_post_ratio = post_duration / pre_duration;

for group=1:numel(groupNames)
    pre_idx = pinch_x_range >= AUC_pre_time(1) & pinch_x_range < AUC_pre_time(2);
    pre_areas = mean_curr_mouse_areas{group}(:,pre_idx);
    pre_areas_norm = pre_areas - median(pre_areas,2);
    pre_AUCs{group} = trapz(pre_areas_norm,2);

    post_idx = pinch_x_range >= AUC_post_time(1) & pinch_x_range < AUC_post_time(2);
    post_areas = mean_curr_mouse_areas{group}(:,post_idx);
    post_areas_norm = post_areas - median(pre_areas,2);
    post_AUCs{group} = trapz(post_areas_norm,2) / pre_post_ratio;

    curr_AUCs = [pre_AUCs{group}, post_AUCs{group}];

    writecell(header,AUC_filename,'Range','A1','Sheet',sprintf('%s (pinch)', groupNames{group}));
    writematrix(curr_AUCs,AUC_filename,'Range','A2','Sheet',sprintf('%s (pinch)', groupNames{group}));
end