stages = {"habituation", "conditioning", "extinction 1", "extinction 2", "retrieval"};

animal_names = {"GR12", "GR15", "GR18", "GR28" "GR45", "GR46"};

output_filename = 'two_photon_analysis_behavior.xlsx';

binned_output_filename = 'two_photon_analysis_behavior_bin.xlsx';

files = {

% habituation
{"C:\Users\bhagwaths\Downloads\drive-download-20240315T194834Z-001\RawBehavData_rowRawBehavDataBin_colEvent_GR12-day1.parquet";
"C:\Users\bhagwaths\Downloads\drive-download-20240315T194834Z-001\RawBehavData_rowRawBehavDataBin_colEvent_GR15-day1.parquet";
"C:\Users\bhagwaths\Downloads\drive-download-20240315T194834Z-001\RawBehavData_rowRawBehavDataBin_colEvent_GR18-day1.parquet";
"C:\Users\bhagwaths\Downloads\drive-download-20240315T194834Z-001\RawBehavData_rowRawBehavDataBin_colEvent_GR28-day1.parquet";
"C:\Users\bhagwaths\Downloads\drive-download-20240315T194834Z-001\RawBehavData_rowRawBehavDataBin_colEvent_GR45-day1.parquet";
"C:\Users\bhagwaths\Downloads\drive-download-20240315T194834Z-001\RawBehavData_rowRawBehavDataBin_colEvent_GR46-day1.parquet"};

% conditioning
{"C:\Users\bhagwaths\Downloads\drive-download-20240315T194834Z-001\RawBehavData_rowRawBehavDataBin_colEvent_GR12-day2.parquet";
"C:\Users\bhagwaths\Downloads\drive-download-20240315T194834Z-001\RawBehavData_rowRawBehavDataBin_colEvent_GR15-day2.parquet";
"C:\Users\bhagwaths\Downloads\drive-download-20240315T194834Z-001\RawBehavData_rowRawBehavDataBin_colEvent_GR18-day2.parquet";
"C:\Users\bhagwaths\Downloads\drive-download-20240315T194834Z-001\RawBehavData_rowRawBehavDataBin_colEvent_GR28-day2.parquet";
"C:\Users\bhagwaths\Downloads\drive-download-20240315T194834Z-001\RawBehavData_rowRawBehavDataBin_colEvent_GR45-day2.parquet";
"C:\Users\bhagwaths\Downloads\drive-download-20240315T194834Z-001\RawBehavData_rowRawBehavDataBin_colEvent_GR46-day2.parquet"};

% extinction 1
{"C:\Users\bhagwaths\Downloads\drive-download-20240315T194834Z-001\RawBehavData_rowRawBehavDataBin_colEvent_GR12-day3.parquet";
"C:\Users\bhagwaths\Downloads\drive-download-20240315T194834Z-001\RawBehavData_rowRawBehavDataBin_colEvent_GR15-day3.parquet";
"C:\Users\bhagwaths\Downloads\drive-download-20240315T194834Z-001\RawBehavData_rowRawBehavDataBin_colEvent_GR18-day3.parquet";
"C:\Users\bhagwaths\Downloads\drive-download-20240315T194834Z-001\RawBehavData_rowRawBehavDataBin_colEvent_GR28-day3.parquet";
"C:\Users\bhagwaths\Downloads\drive-download-20240315T194834Z-001\RawBehavData_rowRawBehavDataBin_colEvent_GR45-day3.parquet";
"C:\Users\bhagwaths\Downloads\drive-download-20240315T194834Z-001\RawBehavData_rowRawBehavDataBin_colEvent_GR46-day3.parquet"};

% extinction 2
{"C:\Users\bhagwaths\Downloads\drive-download-20240315T194834Z-001\RawBehavData_rowRawBehavDataBin_colEvent_GR12-day4.parquet";
"C:\Users\bhagwaths\Downloads\drive-download-20240315T194834Z-001\RawBehavData_rowRawBehavDataBin_colEvent_GR15-day4.parquet";
"C:\Users\bhagwaths\Downloads\drive-download-20240315T194834Z-001\RawBehavData_rowRawBehavDataBin_colEvent_GR18-day4.parquet";
"C:\Users\bhagwaths\Downloads\drive-download-20240315T194834Z-001\RawBehavData_rowRawBehavDataBin_colEvent_GR28-day4.parquet";
"C:\Users\bhagwaths\Downloads\drive-download-20240315T194834Z-001\RawBehavData_rowRawBehavDataBin_colEvent_GR45-day4.parquet";
"C:\Users\bhagwaths\Downloads\drive-download-20240315T194834Z-001\RawBehavData_rowRawBehavDataBin_colEvent_GR46-day4.parquet"};

% retrieval
{"C:\Users\bhagwaths\Downloads\drive-download-20240315T194834Z-001\RawBehavData_rowRawBehavDataBin_colEvent_GR12-day5.parquet";
"C:\Users\bhagwaths\Downloads\drive-download-20240315T194834Z-001\RawBehavData_rowRawBehavDataBin_colEvent_GR15-day5.parquet";
"C:\Users\bhagwaths\Downloads\drive-download-20240315T194834Z-001\RawBehavData_rowRawBehavDataBin_colEvent_GR18-day5.parquet";
"C:\Users\bhagwaths\Downloads\drive-download-20240315T194834Z-001\RawBehavData_rowRawBehavDataBin_colEvent_GR28-day5.parquet";
"C:\Users\bhagwaths\Downloads\drive-download-20240315T194834Z-001\RawBehavData_rowRawBehavDataBin_colEvent_GR45-day5.parquet";
"C:\Users\bhagwaths\Downloads\drive-download-20240315T194834Z-001\RawBehavData_rowRawBehavDataBin_colEvent_GR46-day5.parquet"};

};

mouse_data = cell(1,numel(stages));

CS_start_times = cell(1,numel(stages));
CS_start_idx = cell(1,numel(stages));
CS_end_times = cell(1,numel(stages));
CS_end_idx = cell(1,numel(stages));

preCS_start_times = cell(1,numel(stages));
preCS_start_idx = cell(1,numel(stages));
preCS_end_times = cell(1,numel(stages));
preCS_end_idx = cell(1,numel(stages));

% note CS start and end times and idx
for stage=1:numel(stages)
    CS_start_times{stage} = cell(1,numel(animal_names));
    CS_start_idx{stage} = cell(1,numel(animal_names));
    CS_end_times{stage} = cell(1,numel(animal_names));
    CS_end_idx{stage} = cell(1,numel(animal_names));

    preCS_start_times{stage} = cell(1,numel(animal_names));
    preCS_start_idx{stage} = cell(1,numel(animal_names));
    preCS_end_times{stage} = cell(1,numel(animal_names));
    preCS_end_idx{stage} = cell(1,numel(animal_names));

    for mouse=1:numel(animal_names)
       mouse_data{stage}{mouse} = parquetread(files{stage}{mouse});
       first_idx = 1;
       last_idx = numel(mouse_data{stage}{mouse}.CStrain);

       % fps = numel(mouse_data{stage}{mouse}.SecTime) / (mouse_data{stage}{mouse}.SecTime(end) - mouse_data{stage}{mouse}.SecTime(1));

       cons_CS = 0;
       for i=first_idx:last_idx
            if mouse_data{stage}{mouse}.CStrain(i) == 1
                if cons_CS == 0
                    CS_start_times{stage}{mouse} = [CS_start_times{stage}{mouse}; mouse_data{stage}{mouse}.SecTime(i)];
                    CS_start_idx{stage}{mouse} = [CS_start_idx{stage}{mouse}; i];
                    preCS_end_times{stage}{mouse} = [preCS_end_times{stage}{mouse}; mouse_data{stage}{mouse}.SecTime(i-1)];
                    preCS_end_idx{stage}{mouse} = [preCS_end_idx{stage}{mouse}; i-1];
                end
                cons_CS = cons_CS + 1;
            else
                if cons_CS > 0
                    CS_end_times{stage}{mouse} = [CS_end_times{stage}{mouse}; mouse_data{stage}{mouse}.SecTime(i-1)];
                    CS_end_idx{stage}{mouse} = [CS_end_idx{stage}{mouse}; i];
                end
                cons_CS = 0;
            end
       end
       preCS_start_times{stage}{mouse} = preCS_end_times{stage}{mouse} - 30;
       preCS_start_idx{stage}{mouse} = [];
       for i=numel(preCS_start_times{stage}{mouse})
           if ~isempty(preCS_start_times{stage}{mouse})
               [~, closest_time_idx] = min(abs(mouse_data{stage}{mouse}.SecTime - preCS_start_times{stage}{mouse}(i)));
               preCS_start_idx{stage}{mouse} = [preCS_start_idx{stage}{mouse}; closest_time_idx];
           end
       end
    end
end

% mean of each CS
all_stage_CS = cell(1,numel(stages));
all_stage_preCS = cell(1,numel(stages));
for stage=1:numel(stages)
    stage_CS = [];
    stage_preCS = [];
    for mouse=1:numel(animal_names)
        mouse_CS = [];
        mouse_preCS = [];
        for CS=1:numel(CS_start_idx{stage}{mouse})
            mean_CS = mean(mouse_data{stage}{mouse}.Movement(CS_start_idx{stage}{mouse}(CS):CS_end_idx{stage}{mouse}(CS)));
            mean_preCS = mean(mouse_data{stage}{mouse}.Movement(preCS_start_idx{stage}{mouse}(CS):preCS_end_idx{stage}{mouse}(CS)));
            mouse_CS = [mouse_CS; mean_CS];
            mouse_preCS = [mouse_preCS; mean_preCS];
        end
        if isempty(CS_start_idx{stage}{mouse})
            mouse_CS = NaN(5,1);
            mouse_preCS = NaN(5,1);
        end
        stage_CS = [stage_CS mouse_CS];
        stage_preCS = [stage_preCS mouse_preCS];
    end
    all_stage_CS{stage} = stage_CS;
    all_stage_preCS{stage} = stage_preCS;
end

% mean of each 5-CS bin
all_stage_CS_bin = cell(1,numel(stages));
all_stage_preCS_bin = cell(1,numel(stages));
for stage=1:numel(stages)
    if stage == 3 || stage == 4
        st = 1; en = 5;
        for bin=1:5
            all_stage_CS_bin{stage} = [all_stage_CS_bin{stage}; mean(all_stage_CS{stage}(st:en,:),1)];
            all_stage_preCS_bin{stage} = [all_stage_preCS_bin{stage}; mean(all_stage_preCS{stage}(st:en,:),1)];
            st = st + 5;
            en = en + 5;
        end
    else
        all_stage_CS_bin{stage} = mean(all_stage_CS{stage},1);
        all_stage_preCS_bin{stage} = mean(all_stage_preCS{stage},1);
    end
end

% Write to Excel
Header = {"GR12 (pre)", "GR12 (CS)", "GR15 (pre)", "GR15 (CS)", "GR18 (pre)", "GR18 (CS)", "GR28 (pre)", "GR28 (CS)",...
    "GR45 (pre)", "GR45 (CS)", "GR46 (pre)", "GR46 (CS)"};

for stage=1:numel(stages)
    stage_preCS_CS = [];
    stage_preCS_CS_bin = [];
    for mouse=1:numel(animal_names)
        stage_preCS_CS = [stage_preCS_CS, all_stage_preCS{stage}(:,mouse), all_stage_CS{stage}(:,mouse)];
        stage_preCS_CS_bin = [stage_preCS_CS_bin, all_stage_preCS_bin{stage}(:,mouse), all_stage_CS_bin{stage}(:,mouse)];
    end
    writecell(Header, output_filename, 'Range', 'A1', 'Sheet', stages{stage});
    writematrix(stage_preCS_CS, output_filename, 'Range', 'A2', 'Sheet', stages{stage});
    writecell(Header, binned_output_filename, 'Range', 'A1', 'Sheet', stages{stage});
    writematrix(stage_preCS_CS_bin, binned_output_filename, 'Range', 'A2', 'Sheet', stages{stage});
end