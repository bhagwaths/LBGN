animalNames = {'GR46'; 'GR45'; 'GR28'; 'GR18'; 'GR15'; 'GR12'};
num_events = {19; 18; 10; 20; 14; 29};

events = {1:19, 1:18, 1:10, 1:20, 1:14, 1:29};

norm_5s = true;
norm_stage = false;

filter = true; % applies Savitzky-Golay filtering to signal
order = 3; % smaller = smoother filtered data
framelen = 11; % larger = smoother filtered data

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

CS_nums = [5; 5; 25; 25; 5];

for mouse=1:numel(animalNames)
    % read excel data
    [data, txt] = xlsread('Yuta data2.xlsx', animalNames{mouse});
    txt(1,:) = [];
    stage = txt(:,3);
    time = data(:,1);
    CS = data(:,4);
    US = data(:,5);
    disc = data(:,6);
    signal = data(:,6+events{mouse});

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

    CS_signal_combined{mouse} = cell(1,numel(stages));
    CS_ind_signal_combined{mouse} = cell(1,numel(stages));
    for j=1:numel(stages)
        CS_ind_signal_combined{mouse}{j} = cell(1,num_events{mouse});
    end

    % CS onset signal for current mouse (separate)
    for i=events{mouse}(1):events{mouse}(end)
        for j=1:numel(stages)
            event_CS_onset_signals = [];
            event_CS_disc_values = [];
            for k=CS_ranges{j}(1):CS_ranges{j}(2)
                CS_onset = CS_start_times(k);
                CS_onset_idx = find(time == CS_onset);
                if j==2 %#ok<IFBDUP> % conditioning
                    CS_onset_signal = signal((CS_onset_idx - 10):(CS_onset_idx + 100),i);
                    % CS_onset_signal = signal((CS_onset_idx - 10):(CS_onset_idx + 100),i);
                else
                    CS_onset_signal = signal((CS_onset_idx - 10):(CS_onset_idx + 100),i);
                end
                CS_disc_value = disc((CS_onset_idx - 10):(CS_onset_idx + 50),:);
                event_CS_onset_signals = [event_CS_onset_signals CS_onset_signal];
                event_CS_disc_values = [event_CS_disc_values CS_disc_value];
            end
           
            % normalize event_CS_onset_signals with 5 s preCS baseline
            if norm_5s
                for k=1:size(event_CS_onset_signals,2)
                    preCS = event_CS_onset_signals(1:10,k);
                    preCS_mean = mean(preCS);
                    event_CS_onset_signals(:,k) = event_CS_onset_signals(:,k) - preCS_mean;
                end
            end

            % normalize event_CS_onset_signals with mean signal of stage
            if norm_stage
                stage_event_signal = signal(strcmp(stage,stage_labels{j}),i);
                stage_mean = mean(stage_event_signal);
                event_CS_onset_signals = event_CS_onset_signals - stage_mean;
            end

            % filter event_CS_onset_signals
            if filter
                for k=1:size(event_CS_onset_signals,2)
                    event_CS_onset_signals(:,k) = sgolayfilt(event_CS_onset_signals(:,k),order,framelen);
                end
            end

            mean_event_CS_onset_signal = mean(event_CS_onset_signals,2);
            sem_event_CS_onset_signal = std(event_CS_onset_signals,[],2) / sqrt(size(event_CS_onset_signals,2));
            mean_event_CS_disc_values = mean(event_CS_disc_values,2);
            sem_event_CS_disc_values = std(event_CS_disc_values,[],2) / sqrt(size(event_CS_disc_values,2));

            if j == 3 % early extinction
                CS_signal_combined{mouse}{j} = [CS_signal_combined{mouse}{j}; mean(event_CS_onset_signals(:,1:5),2)']; 
            elseif j == 4
                CS_signal_combined{mouse}{j} = [CS_signal_combined{mouse}{j}; mean(event_CS_onset_signals(:,21:25),2)'];
            else
                CS_signal_combined{mouse}{j} = [CS_signal_combined{mouse}{j}; mean_event_CS_onset_signal'];
            end

            CS_ind_signal_combined{mouse}{j}{i} = [CS_ind_signal_combined{mouse}{j}{i}; event_CS_onset_signals'];

            % figure;
            % yyaxis left;
            % plot(linspace(-5,25,size(mean_event_CS_onset_signal,1)),mean_event_CS_onset_signal,'LineWidth',2); hold on;
            % errorplot3((mean_event_CS_onset_signal-sem_event_CS_onset_signal)',(mean_event_CS_onset_signal+sem_event_CS_onset_signal)',[-5 25],[0 0.4470 0.7410],0.3); hold on;
            % yyaxis right;
            % plot(linspace(-5,25,size(mean_event_CS_disc_values,1)),mean_event_CS_disc_values,'LineWidth',2); hold on;
            % errorplot3((mean_event_CS_disc_values-sem_event_CS_disc_values)',(mean_event_CS_disc_values+sem_event_CS_disc_values)',[-5 25],[0.8500 0.3250 0.0980],0.3); hold on;
            % xline(0,'LineStyle','--'); hold on;
            % title(strcat("CS onset (", stages{j}, ", ", animalNames{mouse}, ", event ", num2str(events{mouse}(i)), ")"));
        end
    end

    % US onset signal for current mouse (separate)
    for i=1:length(events{mouse})
        event_US_onset_signals = [];
        event_US_disc_values = [];
        for j=CS_ranges{2}(1)-5:CS_ranges{2}(2)-5
            US_onset = US_start_times(j);
            US_onset_idx = find(time == US_onset);
            US_onset_signal = signal((US_onset_idx-10):(US_onset_idx+50),i);
            US_disc_value = disc((US_onset_idx-10):(US_onset_idx+50),:);
            event_US_onset_signals = [event_US_onset_signals US_onset_signal];
            event_US_disc_values = [event_US_disc_values US_disc_value];
        end

        % normalize event_US_onset_signals with 5 s preCS baseline
        if norm_5s
            for j=1:size(event_US_onset_signals,2)
                preUS = event_US_onset_signals(1:10,j);
                preUS_mean = mean(preUS);
                event_US_onset_signals(:,j) = event_US_onset_signals(:,j) - preUS_mean;
            end
        end

        % normalize event_US_onset_signals with mean signal of stage
        if norm_stage
            stage_event_signal = signal(strcmp(stage,stage_labels{2}),i);
            stage_mean = mean(stage_event_signal);
            event_US_onset_signals = event_US_onset_signals - stage_mean;
        end

        % filter event_US_onset_signals
        if filter
            for j=1:size(event_US_onset_signals,2)
                event_US_onset_signals(:,j) = sgolayfilt(event_US_onset_signals(:,j),order,framelen);
            end
        end

        mean_event_US_onset_signal = mean(event_US_onset_signals,2);
        sem_event_US_onset_signal = std(event_US_onset_signals,[],2) / sqrt(size(event_US_onset_signals,2));
        mean_event_US_disc_values = mean(event_US_disc_values,2);
        sem_event_US_disc_values = std(event_US_disc_values,[],2) / sqrt(size(event_US_disc_values,2));

        % figure;
        % yyaxis left;
        % plot(linspace(-5,25,size(mean_event_US_onset_signal,1)),mean_event_US_onset_signal,'LineWidth',2); hold on;
        % errorplot3((mean_event_US_onset_signal-sem_event_US_onset_signal)',(mean_event_US_onset_signal+sem_event_US_onset_signal)',[-5 25],[0 0.4470 0.7410],0.3); hold on;
        % yyaxis right;
        % plot(linspace(-5,25,size(mean_event_US_disc_values,1)),mean_event_US_disc_values,'LineWidth',2); hold on;
        % errorplot3((mean_event_US_disc_values-sem_event_US_disc_values)',(mean_event_US_disc_values+sem_event_US_disc_values)',[-5 25],[0.8500 0.3250 0.0980],0.3); hold on;
        % xline(0,'LineStyle','--','Color','red'); hold on;
        % title(strcat("US onset (conditioning, ", animalNames{mouse}, ", event ", num2str(events{mouse}(i)), ")"));
    end

    % mean CS-US time difference
    CSUS_diff = [];
    for i=CS_ranges{2}(1):CS_ranges{2}(2)
        CSUS_diff = [CSUS_diff; US_start_times(i-5) - CS_start_times(i)];
    end
    mean_CSUS_diff = mean(CSUS_diff);

    % CS+US onset signal for current mouse (separate)
    for i=1:length(events{mouse})
        event_CSUS_onset_signals = [];
        event_CSUS_disc_values = [];
        for j=CS_ranges{2}(1):CS_ranges{2}(2)
            CSUS_onset = CS_start_times(j);
            CSUS_onset_idx = find(time == CSUS_onset);
            CSUS_onset_signal = signal((CSUS_onset_idx-10):(CSUS_onset_idx+100),i);
            CSUS_disc_value = disc((CSUS_onset_idx-10):(CSUS_onset_idx+100),:);
            event_CSUS_onset_signals = [event_CSUS_onset_signals CSUS_onset_signal];
            event_CSUS_disc_values = [event_CSUS_disc_values CSUS_disc_value];
        end

        % normalize event_US_onset_signals with 5 s preCS baseline
        if norm_5s
            for j=1:size(event_CSUS_onset_signals,2)
                preCSUS = event_CSUS_onset_signals(1:10,j);
                preCSUS_mean = mean(preCSUS);
                event_CSUS_onset_signals(:,j) = event_CSUS_onset_signals(:,j) - preCSUS_mean;
            end
        end

        % normalize event_CSUS_onset_signals with mean signal of stage
        if norm_stage
            stage_event_signal = signal(strcmp(stage,stage_labels{2}),i);
            stage_mean = mean(stage_event_signal);
            event_CSUS_onset_signals = event_CSUS_onset_signals - stage_mean;
        end

        % filter event_CSUS_onset_signals
        if filter
            for j=1:size(event_CSUS_onset_signals,2)
                event_CSUS_onset_signals(:,j) = sgolayfilt(event_CSUS_onset_signals(:,j),order,framelen);
            end
        end

        mean_event_CSUS_onset_signal = mean(event_CSUS_onset_signals,2);
        sem_event_CSUS_onset_signal = std(event_CSUS_onset_signals,[],2) / sqrt(size(event_CSUS_onset_signals,2));
        mean_event_CSUS_disc_values = mean(event_CSUS_disc_values,2);
        sem_event_CSUS_disc_values = std(event_CSUS_disc_values,[],2) / sqrt(size(event_CSUS_disc_values,2));

        % figure;
        % yyaxis left;
        % plot(linspace(-5,50,size(mean_event_CSUS_onset_signal,1)),mean_event_CSUS_onset_signal,'LineWidth',2); hold on;
        % errorplot3((mean_event_CSUS_onset_signal-sem_event_CSUS_onset_signal)',(mean_event_CSUS_onset_signal+sem_event_CSUS_onset_signal)',[-5 50],[0 0.4470 0.7410],0.3); hold on;
        % yyaxis right;
        % plot(linspace(-5,50,size(mean_event_CSUS_disc_values,1)),mean_event_CSUS_disc_values,'LineWidth',2); hold on;
        % errorplot3((mean_event_CSUS_disc_values-sem_event_CSUS_disc_values)',(mean_event_CSUS_disc_values+sem_event_CSUS_disc_values)',[-5 50],[0.8500 0.3250 0.0980],0.3); hold on;
        % xline(0,'LineStyle','--'); hold on;
        % xline(mean_CSUS_diff,'LineStyle','--','Color','red'); hold on;
        % title(strcat("CS+US onset (conditioning, ", animalNames{mouse}, ", event ", num2str(events{mouse}(i)), ")"));
    end
end

% % write CS signal for each mouse, stage and event to Excel (cond: 0-60 s,
% % early ext and late ext)
% output_prefix = 'two_photon_analysis_sepMice_sep_Events';
% output_suffix = '.xlsx';
% for mouse=1:numel(animalNames)
%     output_filename = sprintf('%s_%s%s', output_prefix, animalNames{mouse}, output_suffix);
%     for stage_num=1:numel(stages)
%         if stage_num==2 %#ok<IFBDUP> % conditioning
%             Time_Header = -5:0.5:50;
%         else
%             Time_Header = -5:0.5:50;
%         end
%         writematrix(Time_Header,output_filename,'Range','A1','Sheet',stage_labels{stage_num});
%         writematrix(CS_signal_combined{mouse}{stage_num},output_filename,'Range','A2','Sheet',stage_labels{stage_num});
%     end
% end
% 
% % write AUC of CS signal for each mouse, stage and event to Excel (cond: 0-60 s,
% % early ext and late ext)
% output_prefix = 'two_photon_analysis_sepMice_sepEvents_AUC';
% output_suffix = '.xlsx';
% time_range = -5:0.5:50;
% Header = {'-5-0s', '0-10s', '10-20s', '20-30s', '30-40s', '40-50s'};
% row_AUC_outputs = cell(1,numel(stages));
% for mouse=1:numel(animalNames)
%     output_filename = sprintf('%s_%s%s', output_prefix, animalNames{mouse}, output_suffix);
%     row_AUC_outputs{mouse} = cell(num_events{mouse},6);
%     for stage_num=1:numel(stages)
%         writecell(Header,output_filename,'Range','A1','Sheet',stage_labels{stage_num});
%         for row=1:num_events{mouse}
%             row_signal = CS_signal_combined{mouse}{stage_num}(row,:);
%             idx_base = find(time_range >= -5 & time_range < 0);
%             idx_t1 = find(time_range >= 0 & time_range < 10);
%             idx_t2 = find(time_range >= 10 & time_range < 20);
%             idx_t3 = find(time_range >= 20 & time_range < 30);
%             idx_t4 = find(time_range >= 30 & time_range < 40);
%             idx_t5 = find(time_range >= 40 & time_range < 50);
% 
%             AUC_base = trapz(time_range(idx_base), row_signal(idx_base));
%             AUC_t1 = trapz(time_range(idx_t1), row_signal(idx_t1));
%             AUC_t2 = trapz(time_range(idx_t2), row_signal(idx_t2));
%             AUC_t3 = trapz(time_range(idx_t3), row_signal(idx_t3));
%             AUC_t4 = trapz(time_range(idx_t4), row_signal(idx_t4));
%             AUC_t5 = trapz(time_range(idx_t5), row_signal(idx_t5));
% 
%             row_AUC_output = [AUC_base, AUC_t1, AUC_t2, AUC_t3, AUC_t4, AUC_t5];
%             row_AUC_outputs{mouse}{stage_num} = [row_AUC_outputs{mouse}{stage_num}; row_AUC_output];
%         end
%         writematrix(row_AUC_outputs{mouse}{stage_num},output_filename,'Range','A2','Sheet',stage_labels{stage_num});
%     end
% end

% write event, mouse, CS #, CS onset signal to Excel (individual CS)
output_filename = 'two_photon_analysis_sepMice_sepEvents_ind.xlsx';
Header = {'event', 'mouse', 'CS', -5:0.5:25};
row_outputs = cell(1,numel(stages));
for stage_num=1:numel(stages)
    writecell(Header, output_filename, 'Sheet', stage_labels{stage_num}, 'Range', 'A1');
    for mouse=1:numel(animalNames)
        for CS_num=1:CS_nums(stage_num)
            for event=1:num_events{mouse}
                row_output = {event, animalNames{mouse}, CS_num, CS_ind_signal_combined{mouse}{stage_num}{event}(CS_num,:)};
                row_outputs{stage_num} = [row_outputs{stage_num}; row_output];
            end
        end
    end
    writecell(row_outputs{stage_num}, output_filename, 'Sheet', stage_labels{stage_num},'Range','A2');
end

% write event, mouse, CS #, AUC of CS onset signal to Excel (individual CS)
% AUC for these time ranges: -5 to 0, 0 to 10, 10 to 20, 20 to 30, 30 to 40, 40 to 50
output_filename = 'two_photon_analysis_sepMice_sepEvents_ind_AUC.xlsx';
Header = {'event', 'mouse', 'CS', '-5-0s', '0-10s', '10-20s', '20-30s', '30-40s', '40-50s'};
time_range = -5:0.5:50;
row_AUC_outputs = cell(1,numel(stages));
for stage_num=1:numel(stages)
    writecell(Header, output_filename, 'Sheet', stage_labels{stage_num}, 'Range', 'A1');
    row_signal_combined = row_outputs{stage_num}(:,4);
    for row=1:size(row_signal_combined,1)
        row_signal = cell2mat(row_signal_combined(row,:));
        idx_base = find(time_range >= -5 & time_range < 0);
        idx_t1 = find(time_range >= 0 & time_range < 10);
        idx_t2 = find(time_range >= 10 & time_range < 20);
        idx_t3 = find(time_range >= 20 & time_range < 30);
        idx_t4 = find(time_range >= 30 & time_range < 40);
        idx_t5 = find(time_range >= 40 & time_range < 50);

        AUC_base = trapz(time_range(idx_base), row_signal(idx_base));
        AUC_t1 = trapz(time_range(idx_t1), row_signal(idx_t1));
        AUC_t2 = trapz(time_range(idx_t2), row_signal(idx_t2));
        AUC_t3 = trapz(time_range(idx_t3), row_signal(idx_t3));
        AUC_t4 = trapz(time_range(idx_t4), row_signal(idx_t4));
        AUC_t5 = trapz(time_range(idx_t5), row_signal(idx_t5));

        row_AUC_output = [AUC_base, AUC_t1, AUC_t2, AUC_t3, AUC_t4, AUC_t5];
        row_AUC_outputs{stage_num} = [row_AUC_outputs{stage_num}; row_AUC_output];
    end
    writecell(row_outputs{stage_num}(:,1:3), output_filename, 'Sheet', stage_labels{stage_num}, 'Range', 'A2');
    writematrix(row_AUC_outputs{stage_num}, output_filename, 'Sheet', stage_labels{stage_num}, 'Range', 'D2');
end

% write event, mouse, CS #, CS onset signal to Excel (5-CS bins)
output_filename = 'two_photon_analysis_sepMice_sepEvents_block.xlsx';
Header = {'event', 'mouse', '5-CS bin', -5:0.5:25};
block_outputs = cell(1,numel(stages));
for stage_num=1:numel(stages)
    writecell(Header, output_filename, 'Sheet', stage_labels{stage_num}, 'Range', 'A1');
    event_col = cell2mat(row_outputs{stage_num}(:,1));
    mouse_col = row_outputs{stage_num}(:,2);
    CS_col = cell2mat(row_outputs{stage_num}(:,3));
    for mouse=1:numel(animalNames)
        for CS_block_num=1:(CS_nums(stage_num)/5)
            for event=1:num_events{mouse}
                output_by_event = row_outputs{stage_num}(event_col==event & strcmp(mouse_col,animalNames{mouse}) & ...
                    ismember(CS_col,5*CS_block_num-4:5*CS_block_num), :);
                mouse_event_signals_combined = cell2mat(output_by_event(:,4));
                mouse_event_signals_mean = mean(mouse_event_signals_combined,1);
                block_output = {event, animalNames{mouse}, CS_block_num, mouse_event_signals_mean};
                block_outputs{stage_num} = [block_outputs{stage_num}; block_output];
            end
        end
    end
    writecell(block_outputs{stage_num}, output_filename, 'Sheet', stage_labels{stage_num},'Range','A2');
end

% write event, mouse, CS #, AUC of CS onset signal to Excel (5-CS bins)
% AUC for these time ranges: -5 to 0, 0 to 10, 10 to 20, 20 to 30, 30 to 40, 40 to 50
output_filename = 'two_photon_analysis_sepMice_sepEvents_block_AUC.xlsx';
Header = {'event', 'mouse', '5-CS bin', '-5-0s', '0-10s', '10-20s', '20-30s', '30-40s', '40-50s'};
time_range = -5:0.5:50;
block_AUC_outputs = cell(1,numel(stages));
for stage_num=1:numel(stages)
    writecell(Header, output_filename, 'Sheet', stage_labels{stage_num}, 'Range', 'A1');
    block_signal_combined = block_outputs{stage_num}(:,4);
    for block=1:size(block_signal_combined,1)
        block_signal = cell2mat(block_signal_combined(block,:));
        idx_base = find(time_range >= -5 & time_range < 0);
        idx_t1 = find(time_range >= 0 & time_range < 10);
        idx_t2 = find(time_range >= 10 & time_range < 20);
        idx_t3 = find(time_range >= 20 & time_range < 30);
        idx_t4 = find(time_range >= 30 & time_range < 40);
        idx_t5 = find(time_range >= 40 & time_range < 50);

        AUC_base = trapz(time_range(idx_base), block_signal(idx_base));
        AUC_t1 = trapz(time_range(idx_t1), block_signal(idx_t1));
        AUC_t2 = trapz(time_range(idx_t2), block_signal(idx_t2));
        AUC_t3 = trapz(time_range(idx_t3), block_signal(idx_t3));
        AUC_t4 = trapz(time_range(idx_t4), block_signal(idx_t4));
        AUC_t5 = trapz(time_range(idx_t5), block_signal(idx_t5));

        block_AUC_output = [AUC_base, AUC_t1, AUC_t2, AUC_t3, AUC_t4, AUC_t5];
        block_AUC_outputs{stage_num} = [block_AUC_outputs{stage_num}; block_AUC_output];
    end
    writecell(block_outputs{stage_num}(:,1:3), output_filename, 'Sheet', stage_labels{stage_num}, 'Range', 'A2');
    writematrix(block_AUC_outputs{stage_num}, output_filename, 'Sheet', stage_labels{stage_num}, 'Range', 'D2');
end

% heat map of average signal per CS (across all mice, all events)
output_filename = 'two_photon_analysis_CS_heatmap.xlsx';
mean_signals_by_CS = cell(1,numel(stages));
for stage_num=1:numel(stages)
    for CS_num=1:CS_nums(stage_num)
        CS_col = cell2mat(row_outputs{stage_num}(:,3));
        signal_col = row_outputs{stage_num}(:,4);
        signals_by_CS = cell2mat(signal_col(CS_col == CS_num));
        mean_signal_by_CS = mean(signals_by_CS,1);
        mean_signals_by_CS{stage_num} = [mean_signals_by_CS{stage_num}; mean_signal_by_CS];
    end
    figure;
    imagesc(linspace(-5,50,size(mean_signals_by_CS{stage_num},2)), 1, mean_signals_by_CS{stage_num});
    colormap('jet');
    title(stages{stage_num});
    colorbar;
    writematrix(mean_signals_by_CS{stage_num},output_filename,'Sheet', stage_labels{stage_num});
end