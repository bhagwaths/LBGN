% for each mouse:
animalNames = {'GR46', 'GR45'};
num_events = {19, 18};
events = {[1,2,3,4], [3,4,5]};
peak_height = [0.3, 1]; % Minimum peak height
peak_dist = [3, 3]; % Minimum peak separation

% for each stage in all mice:
stages = {'habituation', 'conditioning', 'extinction 1', 'extinction 2', 'retrieval'};
stage_labels = {'Hab', 'Con', 'Ex1', 'Ex2', 'ERet'};
CS_nums = [5, 5, 25, 25, 5];

for mouse=1:numel(animalNames)
    data = readtable('Yuta data2.xlsx', 'Sheet', animalNames{mouse});
    output_filename = sprintf('two_photon_peaks_%s.xlsx', animalNames{mouse});

    for stage=1:numel(stages)
        stage_data = data(strcmp(data.Phase,stage_labels{stage}), :);
        stage_signals = stage_data(:, 8:8+num_events{mouse}-1);

        % CS start and end times  
        CS_start_times = [];
        CS_end_times = [];
        cons_CS = 0;
        for i=1:height(stage_data)
            if stage_data.CS(i) == 1
                if cons_CS == 0
                    CS_start_times = [CS_start_times; stage_data.Time_s_(i)];
                end
                cons_CS = cons_CS + 1;
            else
                if cons_CS > 0
                    CS_end_times = [CS_end_times; stage_data.Time_s_(i-1)];
                end
                cons_CS = 0;
            end
        end

        % ITI start and end times
        ITI_end_times = [];
        ITI_start_times = CS_end_times + 0.5;
        for i=1:CS_nums(stage)
            stage_trial = stage_data(stage_data.Trial == i, :);
            curr_trial_end = stage_trial.Time_s_(end);
            ITI_end_times = [ITI_end_times; curr_trial_end];
        end

        % CS/ITI start/end indices
        CS_start_idx = [];
        CS_end_idx = [];
        ITI_start_idx = [];
        ITI_end_idx = [];

        for i=1:CS_nums(stage)
            CS_start_idx = [CS_start_idx; find(stage_data.Time_s_ == CS_start_times(i))];
            CS_end_idx = [CS_end_idx; find(stage_data.Time_s_ == CS_end_times(i))];
            ITI_start_idx = [ITI_start_idx; find(stage_data.Time_s_ == ITI_start_times(i))];
            ITI_end_idx = [ITI_end_idx; find(stage_data.Time_s_ == ITI_end_times(i))];
        end
        
        for event=1:numel(events{mouse})
            % Find individual event and apply filter, if filter = true
            stage_event = table2array(stage_signals(:,events{mouse}(event)));

            % Find peaks based on defined threshold and plot data
            [pks, locs] = findpeaks(stage_event, stage_data.Time_s_, 'MinPeakHeight', peak_height(mouse), 'MinPeakDistance', peak_dist(mouse)); % find peaks
            figure;
            findpeaks(stage_event, stage_data.Time_s_, 'MinPeakHeight', peak_height(mouse), 'MinPeakDistance', peak_dist(mouse)); % add peak labels to plot
            title(sprintf('Mouse: %s, Stage: %s, Event: %d', animalNames{mouse}, stage_labels{stage}, events{mouse}(event)));
                
            if CS_nums(stage) == 25
                CS_header = {'Time (CS 1-5)', 'Signal (CS 1-5)', 'Time (CS 6-10)', 'Signal (CS 6-10)', 'Time (CS 11-15)',...
                    'Signal (CS 11-15)', 'Time (CS 16-20)', 'Signal (CS 16-20)', 'Time (CS 21-25)', 'Signal (CS 21-25)'};
                ITI_header = {'Time (ITI 1-5)', 'Signal (ITI 1-5)', 'Time (ITI 6-10)', 'Signal (ITI 6-10)', 'Time (ITI 11-15)',...
                    'Signal (ITI 11-15)', 'Time (ITI 16-20)', 'Signal (ITI 16-20)', 'Time (ITI 21-25)', 'Signal (ITI 21-25)'};

                CS_t1 = []; ITI_t1 = [];
                CS_t2 = []; ITI_t2 = [];
                CS_t3 = []; ITI_t3 = [];
                CS_t4 = []; ITI_t4 = [];
                CS_t5 = []; ITI_t5 = [];

                CS_pk1 = []; ITI_pk1 = [];
                CS_pk2 = []; ITI_pk2 = [];
                CS_pk3 = []; ITI_pk3 = [];
                CS_pk4 = []; ITI_pk4 = [];
                CS_pk5 = []; ITI_pk5 = [];

                for i=1:5
                    CS_t1 = [CS_t1; locs(locs >= CS_start_times(i) & locs <= CS_end_times(i))];
                    ITI_t1 = [ITI_t1; locs(locs >= ITI_start_times(i) & locs <= ITI_end_times(i))];
                    CS_pk1 = [CS_pk1; pks(locs >= CS_start_times(i) & locs <= CS_end_times(i))];
                    ITI_pk1 = [ITI_pk1; pks(locs >= ITI_start_times(i) & locs <= ITI_end_times(i))];
                end
                for i=6:10
                    CS_t2 = [CS_t2; locs(locs >= CS_start_times(i) & locs <= CS_end_times(i))];
                    ITI_t2 = [ITI_t2; locs(locs >= ITI_start_times(i) & locs <= ITI_end_times(i))];
                    CS_pk2 = [CS_pk2; pks(locs >= CS_start_times(i) & locs <= CS_end_times(i))];
                    ITI_pk2 = [ITI_pk2; pks(locs >= ITI_start_times(i) & locs <= ITI_end_times(i))];
                end
                for i=11:15
                    CS_t3 = [CS_t3; locs(locs >= CS_start_times(i) & locs <= CS_end_times(i))];
                    ITI_t3 = [ITI_t3; locs(locs >= ITI_start_times(i) & locs <= ITI_end_times(i))];
                    CS_pk3 = [CS_pk3; pks(locs >= CS_start_times(i) & locs <= CS_end_times(i))];
                    ITI_pk3 = [ITI_pk3; pks(locs >= ITI_start_times(i) & locs <= ITI_end_times(i))];
                end
                for i=16:20
                    CS_t4 = [CS_t4; locs(locs >= CS_start_times(i) & locs <= CS_end_times(i))];
                    ITI_t4 = [ITI_t4; locs(locs >= ITI_start_times(i) & locs <= ITI_end_times(i))];
                    CS_pk4 = [CS_pk4; pks(locs >= CS_start_times(i) & locs <= CS_end_times(i))];
                    ITI_pk4 = [ITI_pk4; pks(locs >= ITI_start_times(i) & locs <= ITI_end_times(i))];
                end
                for i=21:25
                    CS_t5 = [CS_t5; locs(locs >= CS_start_times(i) & locs <= CS_end_times(i))];
                    ITI_t5 = [ITI_t5; locs(locs >= ITI_start_times(i) & locs <= ITI_end_times(i))];
                    CS_pk5 = [CS_pk5; pks(locs >= CS_start_times(i) & locs <= CS_end_times(i))];
                    ITI_pk5 = [ITI_pk5; pks(locs >= ITI_start_times(i) & locs <= ITI_end_times(i))];
                end

                writecell(CS_header,output_filename,'Range','A1','Sheet',sprintf('%s_ev%d', stage_labels{stage}, events{mouse}(event)));
                writematrix([CS_t1 CS_pk1],output_filename,'Range','A2','Sheet',sprintf('%s_ev%d', stage_labels{stage}, events{mouse}(event)));
                writematrix([CS_t2 CS_pk2],output_filename,'Range','C2','Sheet',sprintf('%s_ev%d', stage_labels{stage}, events{mouse}(event)));
                writematrix([CS_t3 CS_pk3],output_filename,'Range','E2','Sheet',sprintf('%s_ev%d', stage_labels{stage}, events{mouse}(event)));
                writematrix([CS_t4 CS_pk4],output_filename,'Range','G2','Sheet',sprintf('%s_ev%d', stage_labels{stage}, events{mouse}(event)));
                writematrix([CS_t5 CS_pk5],output_filename,'Range','I2','Sheet',sprintf('%s_ev%d', stage_labels{stage}, events{mouse}(event)));
                
                writecell(ITI_header,output_filename,'Range','L1','Sheet',sprintf('%s_ev%d', stage_labels{stage}, events{mouse}(event)));
                writematrix([ITI_t1 ITI_pk1],output_filename,'Range','L2','Sheet',sprintf('%s_ev%d', stage_labels{stage}, events{mouse}(event)));
                writematrix([ITI_t2 ITI_pk2],output_filename,'Range','N2','Sheet',sprintf('%s_ev%d', stage_labels{stage}, events{mouse}(event)));
                writematrix([ITI_t3 ITI_pk3],output_filename,'Range','P2','Sheet',sprintf('%s_ev%d', stage_labels{stage}, events{mouse}(event)));
                writematrix([ITI_t4 ITI_pk4],output_filename,'Range','R2','Sheet',sprintf('%s_ev%d', stage_labels{stage}, events{mouse}(event)));
                writematrix([ITI_t5 ITI_pk5],output_filename,'Range','T2','Sheet',sprintf('%s_ev%d', stage_labels{stage}, events{mouse}(event)));

            else % CS_nums(stage) == 5
               CS_header = {'Time (CS 1)', 'Signal (CS 1)', 'Time (CS 2)', 'Signal (CS 2)', 'Time (CS 3)',...
                    'Signal (CS 3)', 'Time (CS 4)', 'Signal (CS 4)', 'Time (CS 5)', 'Signal (CS 5)'};
                ITI_header = {'Time (ITI 1)', 'Signal (ITI 1)', 'Time (ITI 2)', 'Signal (ITI 2)', 'Time (ITI 3)',...
                    'Signal (ITI 3)', 'Time (ITI 4)', 'Signal (ITI 4)', 'Time (ITI 5)', 'Signal (ITI 5)'};

                CS_t1 = locs(locs >= CS_start_times(1) & locs <= CS_end_times(1));
                ITI_t1 = locs(locs >= ITI_start_times(1) & locs <= ITI_end_times(1));
                CS_pk1 = pks(locs >= CS_start_times(1) & locs <= CS_end_times(1));
                ITI_pk1 = pks(locs >= ITI_start_times(1) & locs <= ITI_end_times(1));

                CS_t2 = locs(locs >= CS_start_times(2) & locs <= CS_end_times(2));
                ITI_t2 = locs(locs >= ITI_start_times(2) & locs <= ITI_end_times(2));
                CS_pk2 = pks(locs >= CS_start_times(2) & locs <= CS_end_times(2));
                ITI_pk2 = pks(locs >= ITI_start_times(2) & locs <= ITI_end_times(2));

                CS_t3 = locs(locs >= CS_start_times(3) & locs <= CS_end_times(3));
                ITI_t3 = locs(locs >= ITI_start_times(3) & locs <= ITI_end_times(3));
                CS_pk3 = pks(locs >= CS_start_times(3) & locs <= CS_end_times(3));
                ITI_pk3 = pks(locs >= ITI_start_times(3) & locs <= ITI_end_times(3));

                CS_t4 = locs(locs >= CS_start_times(4) & locs <= CS_end_times(4));
                ITI_t4 = locs(locs >= ITI_start_times(4) & locs <= ITI_end_times(4));
                CS_pk4 = pks(locs >= CS_start_times(4) & locs <= CS_end_times(4));
                ITI_pk4 = pks(locs >= ITI_start_times(4) & locs <= ITI_end_times(4));

                CS_t5 = locs(locs >= CS_start_times(5) & locs <= CS_end_times(5));
                ITI_t5 = locs(locs >= ITI_start_times(5) & locs <= ITI_end_times(5));
                CS_pk5 = pks(locs >= CS_start_times(5) & locs <= CS_end_times(5));
                ITI_pk5 = pks(locs >= ITI_start_times(5) & locs <= ITI_end_times(5));

                writecell(CS_header,output_filename,'Range','A1','Sheet',sprintf('%s_ev%d', stage_labels{stage}, events{mouse}(event)));
                writematrix([CS_t1 CS_pk1],output_filename,'Range','A2','Sheet',sprintf('%s_ev%d', stage_labels{stage}, events{mouse}(event)));
                writematrix([CS_t2 CS_pk2],output_filename,'Range','C2','Sheet',sprintf('%s_ev%d', stage_labels{stage}, events{mouse}(event)));
                writematrix([CS_t3 CS_pk3],output_filename,'Range','E2','Sheet',sprintf('%s_ev%d', stage_labels{stage}, events{mouse}(event)));
                writematrix([CS_t4 CS_pk4],output_filename,'Range','G2','Sheet',sprintf('%s_ev%d', stage_labels{stage}, events{mouse}(event)));
                writematrix([CS_t5 CS_pk5],output_filename,'Range','I2','Sheet',sprintf('%s_ev%d', stage_labels{stage}, events{mouse}(event)));
                
                writecell(ITI_header,output_filename,'Range','L1','Sheet',sprintf('%s_ev%d', stage_labels{stage}, events{mouse}(event)));
                writematrix([ITI_t1 ITI_pk1],output_filename,'Range','L2','Sheet',sprintf('%s_ev%d', stage_labels{stage}, events{mouse}(event)));
                writematrix([ITI_t2 ITI_pk2],output_filename,'Range','N2','Sheet',sprintf('%s_ev%d', stage_labels{stage}, events{mouse}(event)));
                writematrix([ITI_t3 ITI_pk3],output_filename,'Range','P2','Sheet',sprintf('%s_ev%d', stage_labels{stage}, events{mouse}(event)));
                writematrix([ITI_t4 ITI_pk4],output_filename,'Range','R2','Sheet',sprintf('%s_ev%d', stage_labels{stage}, events{mouse}(event)));
                writematrix([ITI_t5 ITI_pk5],output_filename,'Range','T2','Sheet',sprintf('%s_ev%d', stage_labels{stage}, events{mouse}(event)));
            end
        end
    end
end
