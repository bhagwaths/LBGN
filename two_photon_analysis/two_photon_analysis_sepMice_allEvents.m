% animalNames = {'GR46'; 'GR45'; 'GR28'; 'GR18'; 'GR15'; 'GR12'};
% num_events = {19; 18; 10; 20; 14; 29};

norm_5s = true; % normalize CS onset plot to 5-second pre-CS period
norm_stage = false; % normalize CS onset plot to average signal in stage

filter = true; % applies Savitzky-Golay filtering to signal
order = 3; % smaller = smoother filtered data
framelen = 11; % larger = smoother filtered data

animalNames = {'GR46'};
num_events = {19};

% don't change
stages = {'habituation';
          'conditioning';
          'extinction 1';
          'extinction 2';
          'retrieval'};
stage_labels = {'Hab';
                'Con';
                'Ex1';
                'Ex2';
                'ERet'};
CS_ranges = {[1,5]; % Habituation: 5 CS
             [6,10]; % Conditioning: 5 CS
             [11,35]; % Extinction 1: 25 CS
             [36,60]; % Extinction 2: 25 CS
             [61,65]}; % Retrieval: 5 CS
                     % -----------------------
                     % Entire session: 65 CS

for mouse=1:numel(animalNames)
    % read excel data
    [data, txt] = xlsread('Yuta data.xlsx', animalNames{mouse});
    txt(1,:) = [];
    stage = txt(:,3);
    time = data(:,1);
    CS = data(:,4);
    US = data(:,5);
    disc = data(:,6);
    signal = data(:,7:7+num_events{mouse}-1);

    % clean data
    stage = stage(~cellfun('isempty', stage));
    time = time(~isnan(time));
    CS = CS(~isnan(CS));
    US = US(~isnan(US));
    disc = disc(~isnan(disc));
    signal = signal(~any(isnan(signal), 2), :);
    
    % CS start and end times
    first_idx = 1;
    last_idx = numel(CS);

    CS_start_times = [];
    CS_end_times = [];
    cons_CS = 0;
    for i=first_idx:last_idx
        if CS(i) == 1
            if cons_CS == 0
                CS_start_times = [CS_start_times; time(i)];
            end
            cons_CS = cons_CS + 1;
        else
            if cons_CS > 0
                CS_end_times = [CS_end_times; time(i-1)];
            end
            cons_CS = 0;
        end
    end
    
    % US start and end times
    US_start_times = [];
    US_end_times = [];
    cons_US = 0;
    for i=first_idx:last_idx
        if US(i) == 1
            if cons_US == 0
                US_start_times = [US_start_times; time(i)];
            end
            cons_US = cons_US + 1;
        else
            if cons_US > 0
                US_end_times = [US_end_times; time(i-1)];
            end
            cons_US = 0;
        end
    end
    
    % entire session plot
    mean_signal = mean(signal,2);
    sem_signal = std(signal,[],2) / sqrt(size(signal,2));

    figure;
    yyaxis left;
    for i=1:numel(CS_start_times)
        patch([CS_start_times(i) CS_start_times(i) CS_end_times(i) CS_end_times(i)], [0 7 7 0], [.8 1 1], 'EdgeColor','none'); 
        hold on;
    end
    for i=1:numel(US_start_times)
        patch([US_start_times(i) US_start_times(i) US_end_times(i) US_end_times(i)], [0 7 7 0], [1 .8 .8], 'EdgeColor','none'); 
        hold on;
    end
    plot(time,mean_signal,'Color',[0 0.4470 0.7410]); hold on;
    errorplot3((mean_signal-sem_signal)', (mean_signal+sem_signal)', [time(1) time(end)],[0 0.4470 0.7410],0.3); hold on;
    yyaxis right;
    plot(time,disc,'Color',[0.8500 0.3250 0.0980]); hold on;
    title(strcat("session (",animalNames{mouse},")"));

    % entire session plot - separated by stage
    stage_signal_combined = cell(1,numel(stages));
    for i=1:numel(stages)
        stage_time = time(strcmp(stage,stage_labels{i}));
        stage_signal = mean_signal(strcmp(stage,stage_labels{i}));
        stage_signal_sem = sem_signal(strcmp(stage,stage_labels{i}));
        stage_signal_combined{i} = stage_signal;
        stage_disc = disc(strcmp(stage,stage_labels{i}));
        stage_CS_start_times = CS_start_times(CS_ranges{i}(1):CS_ranges{i}(2));
        stage_CS_end_times = CS_end_times(CS_ranges{i}(1):CS_ranges{i}(2));

        figure;
        yyaxis left;
        for j=1:numel(stage_CS_start_times)
            patch([stage_CS_start_times(j) stage_CS_start_times(j) stage_CS_end_times(j) stage_CS_end_times(j)], [0 7 7 0], [.8 1 1], 'EdgeColor','none'); 
            hold on;
        end
        if strcmp(stages{i},'conditioning')
            for j=1:numel(US_start_times)
                patch([US_start_times(j) US_start_times(j) US_end_times(j) US_end_times(j)], [0 7 7 0], [1 .8 .8], 'EdgeColor','none'); 
                hold on;
            end
        end
        plot(stage_time, stage_signal); hold on;
        errorplot3((stage_signal-stage_signal_sem)',(stage_signal+stage_signal_sem)',[stage_time(1) stage_time(end)],[0 0.4470 0.7410],0.3); hold on;
        yyaxis right;
        plot(stage_time, stage_disc,'Color',[0.8500 0.3250 0.0980]); hold on;
        title(strcat(stages{i}," (",animalNames{mouse},")"));
    end

    % CS onset signal for current mouse (separate)
    stage_CS_signals = cell(1,numel(stages));
    stage_CS_disc_values = cell(1,numel(stages));
    stage_CS_signals_mean = cell(1,numel(stages));
    stage_CS_signals_sem = cell(1,numel(stages));
    stage_CS_disc_values_mean = cell(1,numel(stages));
    stage_CS_disc_values_sem = cell(1,numel(stages));

    for i=1:numel(stages)
        for j=CS_ranges{i}(1):CS_ranges{i}(2)
            CS_onset = CS_start_times(j);
            CS_onset_idx = find(time == CS_onset);
            CS_onset_signal = signal((CS_onset_idx - 10):(CS_onset_idx + 50),:);
            CS_disc_value = disc((CS_onset_idx - 10):(CS_onset_idx + 50),:);
            stage_CS_signals{i} = [stage_CS_signals{i} CS_onset_signal];
            stage_CS_disc_values{i} = [stage_CS_disc_values{i} CS_disc_value];
        end
    end

    % US onset signal for current mouse (separate) - conditioning only
    US_signals = [];
    US_disc_values = [];

    for i=1:5
        US_onset = US_start_times(i);
        US_onset_idx = find(time == US_onset);
        US_onset_signal = signal((US_onset_idx-10):(US_onset_idx+50),:);
        US_disc_value = disc((US_onset_idx-10):(US_onset_idx+50),:);
        US_signals = [US_signals US_onset_signal];
        US_disc_values = [US_disc_values US_disc_value];
    end

    % CS+US onset signal for current mouse (separate) - conditioning only
    CSUS_signals = [];
    CSUS_disc_values = [];

    for i=6:10
        CSUS_onset = CS_start_times(i);
        CSUS_onset_idx = find(time == CSUS_onset);
        CSUS_onset_signal = signal((CSUS_onset_idx-10):(CSUS_onset_idx+100),:);
        CSUS_disc_value = disc((CSUS_onset_idx-10):(CSUS_onset_idx+100),:);
        CSUS_signals = [CSUS_signals CSUS_onset_signal];
        CSUS_disc_values = [CSUS_disc_values CSUS_disc_value];
    end

    % normalize stage_CS_signals with 5 s preCS baseline
    if norm_5s
        for i=1:numel(stages)
            for j=1:size(stage_CS_signals{i},2)
                preCS = stage_CS_signals{i}(1:10, j);
                preCS_mean = mean(preCS);
                stage_CS_signals{i}(:,j) = stage_CS_signals{i}(:,j) - preCS_mean;
            end
        end
    end

    % normalize stage_CS_signals with mean signal of stage
    if norm_stage
        for i=1:numel(stages)
            stage_mean = mean(stage_signal_combined{i});
            stage_CS_signals{i} = stage_CS_signals{i} - stage_mean;
        end
    end

    % filter stage_CS_signals
    if filter
        for i=1:numel(stages)
            for j=1:size(stage_CS_signals{i},2)
                stage_CS_signals{i}(:,j) = sgolayfilt(stage_CS_signals{i}(:,j),order,framelen);
            end
        end
    end

    % mean CS onset signal
    for i=1:numel(stage_CS_signals)
        stage_CS_signals_mean{i} = mean(stage_CS_signals{i},2);
        stage_CS_signals_sem{i} = std(stage_CS_signals{i},[],2) / sqrt(size(stage_CS_signals{i},2));
        stage_CS_disc_values_mean{i} = mean(stage_CS_disc_values{i},2);
        stage_CS_disc_values_sem{i} = std(stage_CS_disc_values{i},[],2) / sqrt(size(stage_CS_disc_values{i},2));

        % bootstrap CI (bCI)
        sig = .05;
        consec_thresh = 3.3;
        ERT_test.CS = stage_CS_signals{i}';

        [n_CS,ev_win_CS{i}] = size(ERT_test.CS); 
        mean_CS = mean(ERT_test.CS,1);
        sem_CS = std(ERT_test.CS) / sqrt(size(ERT_test.CS,1));
        CS_bCI = boot_CI(ERT_test.CS,1000,sig);
        [adjLCI,adjUCI] = CIadjust(CS_bCI(1,:),CS_bCI(2,:),[],n_CS,2);
        CS_bCIexp = [adjLCI;adjUCI];
        CS_bCIexp_sig{i} = NaN(1,ev_win_CS{i});
        sig_idx = find((CS_bCIexp(1,:) > 0) | (CS_bCIexp(2,:) < 0));
        consec = consec_idx(sig_idx,consec_thresh);
        CS_bCIexp_sig{i}(sig_idx(consec)) = max(mean_CS)*1.1;
    end

    % normalize US_signals with 5 s preUS baseline
    if norm_5s
        for i=1:size(US_signals,2)
            preUS = US_signals(1:10, i);
            preUS_mean = mean(preUS);
            US_signals(:,i) = US_signals(:,i) - preUS_mean;
        end
    end

    % normalize US_signals with mean signal of stage
    if norm_stage
        cond_mean = mean(stage_signal_combined{2});
        US_signals = US_signals - cond_mean;
    end
    
    % filter US_signals
    if filter
        for i=1:size(US_signals,2)
            US_signals(:,i) = sgolayfilt(US_signals(:,i),order,framelen);
        end
    end

    % mean US onset signal
    US_signals_mean = mean(US_signals,2);
    US_signals_sem = std(US_signals,[],2) / sqrt(size(US_signals,2));
    US_disc_values_mean = mean(US_disc_values,2);
    US_disc_values_sem = std(US_disc_values,[],2) / sqrt(size(US_disc_values,2));

    % bootstrap CI (bCI)
    sig = .05;
    consec_thresh = 3.3;
    ERT_test.US = US_signals';

    [n_US,ev_win_US] = size(ERT_test.US);
    mean_US = mean(ERT_test.US,1);
    sem_US = std(ERT_test.US) / sqrt(size(ERT_test.US,1));
    US_bCI = boot_CI(ERT_test.US,1000,sig);
    [adjLCI,adjUCI] = CIadjust(US_bCI(1,:),US_bCI(2,:),[],n_US,2);
    US_bCIexp = [adjLCI;adjUCI];
    US_bCIexp_sig = NaN(1,ev_win_US);
    sig_idx = find((US_bCIexp(1,:) > 0) | (US_bCIexp(2,:) < 0));
    consec = consec_idx(sig_idx,consec_thresh);
    US_bCIexp_sig(sig_idx(consec)) = max(mean_US)*1.1;

    % normalize CSUS_signals with 5 s preCS baseline
    if norm_5s
        for i=1:size(CSUS_signals,2)
            preCSUS = CSUS_signals(1:10, i);
            preCSUS_mean = mean(preCSUS);
            CSUS_signals(:,i) = CSUS_signals(:,i) - preCSUS_mean;
        end
    end

    % normalize CSUS_signals with mean signal of stage
    if norm_stage
        cond_mean = mean(stage_signal_combined{2});
        CSUS_signals = CSUS_signals - cond_mean;
    end
    
    % filter CSUS_signals
    if filter
        for i=1:size(CSUS_signals,2)
            CSUS_signals(:,i) = sgolayfilt(CSUS_signals(:,i),order,framelen);
        end
    end

    % mean CS+US onset signal
    CSUS_signals_mean = mean(CSUS_signals,2);
    CSUS_signals_sem = std(CSUS_signals,[],2) / sqrt(size(CSUS_signals,2));
    CSUS_disc_values_mean = mean(CSUS_disc_values,2);
    CSUS_disc_values_sem = std(CSUS_disc_values,[],2) / sqrt(size(CSUS_disc_values,2));

    % bootstrap CI (bCI)
    sig = .05;
    consec_thresh = 3.3;
    ERT_test.CSUS = CSUS_signals';

    [n_CSUS,ev_win_CSUS] = size(ERT_test.CSUS);
    mean_CSUS = mean(ERT_test.CSUS,1);
    sem_CSUS = std(ERT_test.CSUS) / sqrt(size(ERT_test.CSUS,1));
    CSUS_bCI = boot_CI(ERT_test.CSUS,1000,sig);
    [adjLCI,adjUCI] = CIadjust(CSUS_bCI(1,:),CSUS_bCI(2,:),[],n_CSUS,2);
    CSUS_bCIexp = [adjLCI;adjUCI];
    CSUS_bCIexp_sig = NaN(1,ev_win_CSUS);
    sig_idx = find((CSUS_bCIexp(1,:) > 0) | (CSUS_bCIexp(2,:) < 0));
    consec = consec_idx(sig_idx,consec_thresh);
    CSUS_bCIexp_sig(sig_idx(consec)) = max(mean_CSUS)*1.1;

    % mean CS onset plot
    for i=1:numel(stages)
        figure;
        yyaxis left;
        plot(linspace(-5,25,length(stage_CS_signals_mean{i})), stage_CS_signals_mean{i},'Color',[0 0.4470 0.7410],'LineWidth',2); hold on;
        errorplot3((stage_CS_signals_mean{i}-stage_CS_signals_sem{i})',(stage_CS_signals_mean{i}+stage_CS_signals_sem{i})',[-5 25],[0 0.4470 0.7410],0.3); hold on;
        yyaxis right;
        plot(linspace(-5,25,length(stage_CS_disc_values_mean{i})), stage_CS_disc_values_mean{i},'Color',[0.8500 0.3250 0.0980],'LineWidth',2); hold on;
        errorplot3((stage_CS_disc_values_mean{i}-stage_CS_disc_values_sem{i})',(stage_CS_disc_values_mean{i}+stage_CS_disc_values_sem{i})',[-5 25],[0.8500 0.3250 0.0980],0.3); hold on;
        title(strcat("CS onset (",stages{i},", ",animalNames{mouse},")")); hold on;
        xline(0,'LineStyle','--'); hold on;
        % plot bCI
        yyaxis left;
        timeline = linspace(-5,25,ev_win_CS{i});
        plot(timeline,CS_bCIexp_sig{i},'Color',[0 0.4470 0.7410],'Marker','.');
    end

    % mean US onset plot
    figure;
    yyaxis left;
    plot(linspace(-5,25,length(US_signals_mean)), US_signals_mean, 'Color',[0 0.4470 0.7410],'LineWidth',2); hold on;
    errorplot3((US_signals_mean-US_signals_sem)',(US_signals_mean+US_signals_sem)',[-5 25],[0 0.4470 0.7410],0.3); hold on;
    yyaxis right;
    plot(linspace(-5,25,length(US_disc_values_mean)), US_disc_values_mean, 'Color',[0.8500 0.3250 0.0980],'LineWidth',2); hold on;
    errorplot3((US_disc_values_mean-US_disc_values_sem)',(US_disc_values_mean+US_disc_values_sem)',[-5 25],[0.8500 0.3250 0.0980],0.3); hold on;
    xline(0,'LineStyle','--', 'Color', 'red'); hold on;
    title(strcat("US onset (conditioning, ",animalNames{mouse},")")); hold on;
    % plot bCI
    yyaxis left;
    timeline = linspace(-5,25,ev_win_US);
    plot(timeline,US_bCIexp_sig,'Color',[0 0.4470 0.7410],'Marker','.');

    % mean CS+US onset plot
    figure;
    yyaxis left;
    plot(linspace(-5,50,length(CSUS_signals_mean)), CSUS_signals_mean, 'Color',[0 0.4470 0.7410],'LineWidth',2); hold on;
    errorplot3((CSUS_signals_mean-CSUS_signals_sem)',(CSUS_signals_mean+CSUS_signals_sem)',[-5 50],[0 0.4470 0.7410],0.3); hold on;
    yyaxis right;
    plot(linspace(-5,50,length(CSUS_disc_values_mean)), CSUS_disc_values_mean, 'Color',[0.8500 0.3250 0.0980],'LineWidth',2); hold on;
    errorplot3((CSUS_disc_values_mean-CSUS_disc_values_sem)',(CSUS_disc_values_mean+CSUS_disc_values_sem)',[-5 50],[0.8500 0.3250 0.0980],0.3); hold on;
    xline(0,'LineStyle','--'); hold on;
        % avg US-CS delay
        diff = [];
        for i=6:10
            diff = [diff; US_start_times(i-5) - CS_start_times(i)];
        end
        CSUS_delay = mean(diff);
    xline(CSUS_delay,'LineStyle','--','Color','red'); hold on;
    title(strcat("CS+US onset (conditioning, ",animalNames{mouse},")")); hold on;
    % plot bCI
    yyaxis left;
    timeline = linspace(-5,50,ev_win_CSUS);
    plot(timeline,CSUS_bCIexp_sig,'Color',[0 0.4470 0.7410],'Marker','.');
end