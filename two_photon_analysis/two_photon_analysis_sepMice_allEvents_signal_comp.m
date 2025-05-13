animalNames = {'GR46'; 'GR45'; 'GR28'; 'GR18'; 'GR15'; 'GR12'};
num_events = {19; 18; 10; 20; 14; 29};

preCS_range = [-50 -1]; % frames (2 fps)
CS_range = [0 50]; % frames (2 fps)

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

CS_start_times = cell(1,numel(animalNames));
CS_end_times = cell(1,numel(animalNames));
US_start_times = cell(1,numel(animalNames));
US_end_times = cell(1,numel(animalNames));

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

    % save data in variables
    all_signals{mouse} = signal;
    all_times{mouse} = time;
    
    % CS start and end times
    first_idx = 1;
    last_idx = numel(CS);

    cons_CS = 0;
    for i=first_idx:last_idx
        if CS(i) == 1
            if cons_CS == 0
                CS_start_times{mouse} = [CS_start_times{mouse}; time(i)];
            end
            cons_CS = cons_CS + 1;
        else
            if cons_CS > 0
                CS_end_times{mouse} = [CS_end_times{mouse}; time(i-1)];
            end
            cons_CS = 0;
        end
    end
    
    % US start and end times
    cons_US = 0;
    for i=first_idx:last_idx
        if US(i) == 1
            if cons_US == 0
                US_start_times{mouse} = [US_start_times{mouse}; time(i)];
            end
            cons_US = cons_US + 1;
        else
            if cons_US > 0
                US_end_times{mouse} = [US_end_times{mouse}; time(i-1)];
            end
            cons_US = 0;
        end
    end
end

preCS_combined = cell(1,numel(animalNames));
CS_combined = cell(1,numel(animalNames));
preCS_combined_sem = cell(1,numel(animalNames));
CS_combined_sem = cell(1,numel(animalNames));

for mouse=1:numel(animalNames)
    preCS_combined{mouse} = cell(1,numel(stages));
    CS_combined{mouse} = cell(1,numel(stages));
    preCS_combined_sem{mouse} = cell(1,numel(stages));
    CS_combined_sem{mouse} = cell(1,numel(stages));
    for stage=1:numel(stages)
        % extinction: mean for 5-CS blocks
        if stage == 3 || stage == 4
            preCS = [];
            CS = [];
            for i=CS_ranges{stage}(1):CS_ranges{stage}(2)
                CS_onset = CS_start_times{mouse}(i);
                CS_onset_idx = find(all_times{mouse} == CS_onset);

                preCS = [preCS; all_signals{mouse}(CS_onset_idx+preCS_range(1):CS_onset_idx+preCS_range(2),:)];
                CS = [CS; all_signals{mouse}(CS_onset_idx+CS_range(1):CS_onset_idx+CS_range(2),:)];

                if mod(i,5)==0
                    preCS_combined{mouse}{stage} = [preCS_combined{mouse}{stage}; mean(preCS,"all")];
                    CS_combined{mouse}{stage} = [CS_combined{mouse}{stage}; mean(CS,"all")];
                    preCS_combined_sem{mouse}{stage} = [preCS_combined_sem{mouse}{stage}; std(preCS,[],"all") / sqrt(numel(preCS))];
                    CS_combined_sem{mouse}{stage} = [CS_combined_sem{mouse}{stage}; std(CS,[],"all") / sqrt(numel(CS))];
                    preCS = [];
                    CS = [];
                end
            end
        else
            for i=CS_ranges{stage}(1):CS_ranges{stage}(2)
                CS_onset = CS_start_times{mouse}(i);
                CS_onset_idx = find(all_times{mouse} == CS_onset);
    
                preCS = all_signals{mouse}(CS_onset_idx+preCS_range(1):CS_onset_idx+preCS_range(2),:);
                CS = all_signals{mouse}(CS_onset_idx+CS_range(1):CS_onset_idx+CS_range(2),:);
    
                preCS_combined{mouse}{stage} = [preCS_combined{mouse}{stage}; mean(preCS,"all")];
                CS_combined{mouse}{stage} = [CS_combined{mouse}{stage}; mean(CS,"all")];
                preCS_combined_sem{mouse}{stage} = [preCS_combined_sem{mouse}{stage}; std(preCS,[],"all") / sqrt(numel(preCS))];
                CS_combined_sem{mouse}{stage} = [CS_combined_sem{mouse}{stage}; std(CS,[],"all") / sqrt(numel(CS))];
            end
        end
    end
end

stage_col = {'Hab-1', 'Hab-2', 'Hab-3', 'Hab-4', 'Hab-5', ...
             'Con-1', 'Con-2', 'Con-3', 'Con-4', 'Con-5', ...
             'Ex1-B1', 'Ex1-B2', 'Ex1-B3', 'Ex1-B4', 'Ex1-B5', ...
             'Ex2-B1', 'Ex2-B2', 'Ex2-B3', 'Ex2-B4', 'Ex2-B5', ...
             'ERet-1', 'ERet-2', 'ERet-3', 'ERet-4', 'ERet-5'};

stage_labels = categorical(stage_col);
stage_labels = reordercats(stage_labels,stage_col);

Header = {'pre-CS (mean)', 'CS (mean)', 'pre-CS (sem)', 'CS (sem)'};

output_filename = 'two_photon_analysis_sepMice_allEvents_signal_comp.xlsx';

for mouse=1:numel(animalNames)
    preCS_array{mouse} = cell2mat(preCS_combined{mouse});
    CS_array{mouse} = cell2mat(CS_combined{mouse});
    preCS_array_sem{mouse} = cell2mat(preCS_combined_sem{mouse});
    CS_array_sem{mouse} = cell2mat(CS_combined_sem{mouse});
    signal_array{mouse} = [reshape(preCS_array{mouse}, [25,1]) reshape(CS_array{mouse}, [25,1])];
    signal_array_sem{mouse} = [reshape(preCS_array_sem{mouse}, [25,1]) reshape(CS_array_sem{mouse}, [25,1])];
    figure;
    bar(stage_labels, signal_array{mouse}); hold on;
    title(strcat("Average pre-CS vs. CS signal (", animalNames{mouse}, ")")); hold on;
    ylim([0 1]);

    writecell(Header, output_filename, 'Range', 'B1', 'Sheet', animalNames{mouse});
    writecell(stage_col', output_filename, 'Range', 'A2', 'Sheet', animalNames{mouse});
    writematrix(signal_array{mouse}, output_filename, 'Range', 'B2', 'Sheet', animalNames{mouse});
    writematrix(signal_array_sem{mouse}, output_filename, 'Range', 'D2', 'Sheet', animalNames{mouse});
end