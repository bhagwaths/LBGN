% collect all animal names and blockpaths from user, label blockpaths with animal name
animalNames={'AS-vHIP-BLA-1';...
             'AS-vHIP-BLA-3';...
             'AS-vHIP-BLA-4';...
             'AS-vHIP-BLA-5';...
             'AS-vHIP-BLA-6';...
             'AS-vHIP-BLA-7';...
             'AS-vHIP-BLA-8';...
             'AS-vHIP-BLA-1';...
             'AS-vHIP-BLA-2';...
             'AS-vHIP-BLA-4';...
             'AS-vHIP-BLA-5';...
             'AS-vHIP-BLA-6';...
             'AS-vHIP-BLA-7';...
             'AS-vHIP-BLA-8'};

blockpaths= {'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day10\AS_vHIP_BLA_1-240825-075336'...
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day10\AS_vHIP_BLA_3-240825-102700'...
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day10\AS_vHIP_BLA_4-241211-111554'...
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day10\AS_vHIP_BLA_5-240825-125622'...
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day10\AS_vHIP_BLA_6-241211-134522'...
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day10\AS_vHIP_BLA_7-240825-152531'...
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day10\AS_vHIP_BLA_8-241211-161427'...
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day10\AS_vHIP_BLA_1-240825-075336'...
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day10\AS_vHIP_BLA_2-241211-084241'...
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day10\AS_vHIP_BLA_4-241211-111554'...
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day10\AS_vHIP_BLA_5-240825-125622'...
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day10\AS_vHIP_BLA_6-241211-134522'...
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day10\AS_vHIP_BLA_7-240825-152531'...
'C:\Users\bhagwaths\Desktop\AS-vHIP-BLA_DLC_results\photometry data\by day\Day10\AS_vHIP_BLA_8-241211-161427'};


threshold = [0.7; 0.4; 1.1; 0.5; 0.5; 0.4; 0.3;
           0.7; 0.4; 0.5; 0.6; 0.4; 0.4; 0.4];
 
groupNames={'BLA','vHIP'};

 
groups= {'BLA';'BLA';'BLA';'BLA';'BLA';'BLA';'BLA';
         'vHIP';'vHIP';'vHIP';'vHIP';'vHIP';'vHIP';'vHIP'};

%YOU WILL NEED TO CHANGE THIS 
%stream codes:
%12 means 'ax05G','ax70G'
%34 means 'a_05G','a_70G'



whichStreams= [12; 12; 12; 12; 12; 12; 12;
               34; 34; 34; 34; 34; 34; 34];

firstTTL=[1289;1236;1210;1228;1235;1228;1266;
          1289;1367;1210;1228;1235;1228;1266];

AUC_ranges = {[-1200,-20];
              [100,1800];
              [1800,3600];
              [3600,5400];
              [5400,7200];
              [0,7200]};

AUC_filename = 'AS-vHIP-BLA_stress_day10_AUC.xlsx';

numAnimals=numel(animalNames);
dataStruct_names=animalNames;
startTime=zeros(1,numAnimals);
Channel_405_name=animalNames;
Channel_465_name=animalNames;

%make table with all animal info

Table=table(animalNames,blockpaths',groups,dataStruct_names,startTime',Channel_405_name,Channel_465_name,whichStreams);
Headers={'animalNames','blockpath','group','dataStruct_names','startTime','Channel_405_name','Channel_465_name','whichStreams'};
Table.Properties.VariableNames(1:8)=Headers;
% %fill in animal names
%%

%run TDTbin2mat on all of these, fill in the table, and store the datastructures in workspace
%for each animal....

for aaa=1:numAnimals
    animalName=Table.animalNames{aaa};
    blockpath=Table.blockpath{aaa};
    whichStreams=Table.whichStreams(aaa);
    START=firstTTL(aaa);
    [zallSingle, ts1] = DrugOneTrial_FN_noTTL(animalName, blockpath,whichStreams,START);
    zAll{1,aaa}=zallSingle;
    [maxtab,mintab]=peakdet(zAll{1,aaa},threshold(aaa),ts1);
    
    if length(maxtab)~=length(mintab)
        maxtab = maxtab(1:end-1,:);
    end

    peak_AUCs = peakAUC(maxtab,zAll{1,aaa},ts1);

    maxpeak{1,aaa}=maxtab;
    minpeak{1,aaa}=mintab;
    amplitude{1,aaa}=maxpeak{1,aaa}(:,3)-minpeak{1,aaa}(:,3);
    peak_AUCs_combined{1,aaa}=peak_AUCs;

%% to apply 2SD filter for peaks
    filtmaxtab=[];
    filtmintab=[];
    filtamp=[];
    meanzall = mean(zAll{1,aaa});
    stdev_z = std(zAll{1,aaa});
    thresh=2*stdev_z+meanzall;

    for i=1:length(maxtab)
        diff=maxtab(i,3)-mintab(i,3);
        if diff > thresh
            filtmaxtab=[filtmaxtab; maxtab(i,:)];
            filtmintab=[filtmintab; mintab(i,:)];
            filtamp=[filtamp; maxtab(i,2) diff];
        end
    end

    filt_maxpeak{1,aaa}=filtmaxtab;
    filt_minpeak{1,aaa}=filtmintab;
    filt_amp{1,aaa}=filtamp;
   
end
%
% organize peaks for pharmacology

peaknum=[]; bslpeak=[]; bslmaxamp=[];
for an=1:numAnimals
    peaknum=find(maxpeak{1,an}(:,2)<0);
    bslpeak(an,1)=numel(peaknum);
    if ~isempty(peaknum)
        bslmaxamp(an,1)=max(amplitude{1,an}(peaknum));
    else
        bslmaxamp(an,1)=0;
    end
end
%%

% organize peaks for pharmacology by bins (10 min bin)

start = [-1200 60 1800 3600 5400];
stop = [0 1800 3600 5400 7200];

durations = stop - start;

baselinepeaks = [];
totalpeaks = [];
pharmpeaks = cell(1,length(start)-1);
avgampbsl=[];
avgamptotal=[];
avgamppharm= cell(1,length(start)-1);

basepeakAUCs = [];
avgpeakAUCs = cell(1,length(start)-1);
avgpeakAUCstotal = [];

total_time_range = [start(2), stop(end)];

for i=1:numAnimals
    bslnum=find(maxpeak{1,i}(:,2)<stop(1) & maxpeak{1,i}(:,2)>=start(1));
    baselinepeaks=[baselinepeaks; numel(bslnum)];
    avgampbsl=[avgampbsl; mean(amplitude{1,i}(bslnum))];
    basepeakAUCs=[basepeakAUCs; mean(peak_AUCs_combined{i}(bslnum))];
    
    for j=2:length(start)
        pharmnum{j-1} = find(maxpeak{1,i}(:,2)<stop(j) & maxpeak{1,i}(:,2)>=start(j));
        pharmpeaks{j-1}=[pharmpeaks{j-1}; numel(pharmnum{j-1})];
        avgamppharm{j-1}=[avgamppharm{j-1}; mean(amplitude{1,i}(pharmnum{j-1}))];
        avgpeakAUCs{j-1}=[avgpeakAUCs{j-1}; mean(peak_AUCs_combined{i}(pharmnum{j-1}))];
    end

    totalnum=find(maxpeak{1,i}(i,2)<total_time_range(2) & maxpeak{1,i}(:,2)>total_time_range(1));
    totalpeaks=[totalpeaks; numel(totalnum)];
    avgamptotal=[avgamptotal; mean(amplitude{1,i}(totalnum))];
    avgpeakAUCstotal=[avgpeakAUCstotal; mean(peak_AUCs_combined{i}(totalnum))];
end

for i=1:numAnimals
    baselinefreq = baselinepeaks / durations(1);
    totalfreq = totalpeaks / (total_time_range(2) - total_time_range(1));
end

pharmfreq = [];
for i=1:numel(pharmpeaks)
    pharmfreq = [pharmfreq, pharmpeaks{i} / durations(i+1)];
end
%%
filename = 'AS-vHIP-BLA_stress_day1_2_HB.xlsx';
sheetname = 'Peaks Stress';
header = {'Animal Name'; 'Peaks '+string(start(1))+'-'+string(stop(1)); 'Peaks '+string(start(2))+'-'+string(stop(2)); 
    'Peaks '+string(start(3))+'-'+string(stop(3));  'Peaks '+string(start(4))+'-'+string(stop(4)); 
    'Peaks '+string(start(5))+'-'+string(stop(5)); 'Peaks '+string(total_time_range(1))+'-'+string(total_time_range(2));
    'Average Amp '+string(start(1))+'-'+string(stop(1)); 'Average Amp '+string(start(2))+'-'+string(stop(2));
    'Average Amp '+string(start(3))+'-'+string(stop(3)); 'Average Amp '+string(start(4))+'-'+string(stop(4));
    'Average Amp '+string(start(5))+'-'+string(stop(5)); 'Average Amp '+string(total_time_range(1))+'-'+string(total_time_range(2));
    'Average Freq '+string(start(1))+'-'+string(stop(1)); 'Average Freq '+string(start(2))+'-'+string(stop(2));
    'Average Freq '+string(start(3))+'-'+string(stop(3)); 'Average Freq '+string(start(4))+'-'+string(stop(4));
    'Average Freq '+string(start(5))+'-'+string(stop(5)); 'Average Freq '+string(total_time_range(1))+'-'+string(total_time_range(2));
    'Average Peak AUC '+string(start(1))+'-'+string(stop(1)); 'Average Peak AUC '+string(start(2))+'-'+string(stop(2));
    'Average Peak AUC '+string(start(3))+'-'+string(stop(3)); 'Average Peak AUC '+string(start(4))+'-'+string(stop(4));
    'Average Peak AUC '+string(start(5))+'-'+string(stop(5)); 'Average Peak AUC '+string(total_time_range(1))+'-'+string(total_time_range(2))};

pharmpeaks_combined = [];
avgamppharm_combined = [];
avgpeakAUCs_combined = [];

for i=1:length(start)-1
    pharmpeaks_combined = [pharmpeaks_combined pharmpeaks{i}];
    avgamppharm_combined = [avgamppharm_combined avgamppharm{i}];
    avgpeakAUCs_combined = [avgpeakAUCs_combined avgpeakAUCs{i}];
end

writecell(header.', filename, 'Sheet', sheetname, 'Range', 'A1')
writecell(animalNames, filename, 'Sheet', sheetname, 'Range', 'A2');
writematrix(baselinepeaks, filename, 'Sheet', sheetname, 'Range', 'B2');
writematrix(pharmpeaks_combined, filename, 'Sheet', sheetname, 'Range', 'C2');
writematrix(totalpeaks, filename, 'Sheet', sheetname, 'Range', 'G2');
writematrix(avgampbsl, filename, 'Sheet', sheetname, 'Range', 'H2');
writematrix(avgamppharm_combined, filename, 'Sheet', sheetname, 'Range', 'I2');
writematrix(avgamptotal, filename, 'Sheet', sheetname, 'Range', 'M2');
writematrix([baselinefreq, pharmfreq, totalfreq], filename, 'Sheet', sheetname, 'Range', 'N2');
writematrix([basepeakAUCs, avgpeakAUCs_combined, avgpeakAUCstotal], filename, 'Sheet', sheetname, 'Range', 'T2');

headers = {'Time Max'; 'Max Peak'; 'Time Min'; 'Min Peak'; 'Amplitude'; 'Peak Duration'; 'Frequency';'Peak AUC'};
for i=1:numAnimals
    writecell(headers.', filename, 'Sheet', sprintf('%s (%s)', animalNames{i}, groups{i}), 'Range', 'A1');
    writematrix(maxpeak{1,i}(:,2:3), filename, 'Sheet', sprintf('%s (%s)', animalNames{i}, groups{i}), 'Range', 'A2');
    writematrix(minpeak{1,i}(:,2:3), filename, 'Sheet', sprintf('%s (%s)', animalNames{i}, groups{i}), 'Range', 'C2');
    writematrix(amplitude{1,i}(:), filename, 'Sheet', sprintf('%s (%s)', animalNames{i}, groups{i}), 'Range', 'E2');
    writematrix(minpeak{1,i}(:,2) - maxpeak{1,i}(:,2), filename, 'Sheet', sprintf('%s (%s)', animalNames{i}, groups{i}), 'Range', 'F2');
    writematrix((size(maxpeak{1,i}, 1) ./ (minpeak{1,i}(:,2) - maxpeak{1,i}(:,2))), filename, 'Sheet', sprintf('%s (%s)', animalNames{i}, groups{i}), 'Range', 'G2');
    writematrix(peak_AUCs_combined{1,i}, filename, 'Sheet', sprintf('%s (%s)', animalNames{i}, groups{i}), 'Range', 'H2');
end
%%

%Make each animals' data same length
%find smallest 
[rr,cc]=cellfun(@size,zAll);
[minRowAn,whichR]=min(rr);
[minColAn,whichC]=min(cc);

for col=1:numAnimals
    zAll{1,col}=zAll{1,col}(:,1:minColAn);
    zAll{1,col}=zAll{1,col}(1:minRowAn,:);
end

%

%% 
% 
g1_rows=1; g2_rows=1;

% g1=dm (whatever you put first for groupNames); g2=vm
g1_lump=[]; g2_lump=[];
for jj=1:numAnimals
    if strcmp(groupNames{1}, Table.group{jj})
        z_g1{1,g1_rows}=zAll{1,jj};
        g1_lump=[g1_lump; zAll{1,jj}];
        g1_rows=g1_rows+1;
    elseif strcmp(groupNames{2}, Table.group{jj})
        z_g2{1,g2_rows}=zAll{1,jj};
        g2_lump=[g2_lump; zAll{1,jj}];
        g2_rows=g2_rows+1;    
    end
end

%%

%ALL TRIALS STATS
    %GROUP 1 stats
    zg1_50=mean(g1_lump,1);
    stdDev1=std(g1_lump,1);
    [num_g1,~]=size(g1_lump);
    SEM_g1=stdDev1./(sqrt(num_g1));
    lo_g1=zg1_50-SEM_g1;
    hi_g1=zg1_50+SEM_g1;
    
    %GROUP 2 stats
    zg2_50=mean(g2_lump,1);
    stdDev2=std(g2_lump,1);
    [num_g2,~]=size(g2_lump);
    SEM_g2=stdDev2./(sqrt(num_g2));
    lo_g2=zg2_50-SEM_g2;
    hi_g2=zg2_50+SEM_g2;

%%
durations = cellfun(@(x) x(2) - x(1), AUC_ranges);
max_duration = max(durations);
norm_factors = max_duration ./ durations;

for i=1:numel(AUC_ranges)
    AUC_g1{i} = trapz(g1_lump(:,ts1>=AUC_ranges{i}(1) & ts1<AUC_ranges{i}(2)),2) * norm_factors(i);
    AUC_g2{i} = trapz(g2_lump(:,ts1>=AUC_ranges{i}(1) & ts1<AUC_ranges{i}(2)),2) * norm_factors(i);
end

header = cellfun(@(x) sprintf('%d-%ds', x(1), x(2)), AUC_ranges, 'UniformOutput', false)';
AUC_g1_table = (array2table(cell2mat(AUC_g1),'VariableNames',header));
AUC_g2_table = (array2table(cell2mat(AUC_g2),'VariableNames',header));

writetable(AUC_g1_table,AUC_filename,'Sheet',groupNames{1});
writetable(AUC_g2_table,AUC_filename,'Sheet',groupNames{2});

 %% Figure 3: Z SCORE BY GROUP 1 and 2
% 
% 
% % 
% p1=patch([-100 55 55 -110], [-5 -5 10 10], [1 1 1], 'EdgeColor','none'); hold on;

hold on
%plot G1 SEM
xxx1=[ts1, ts1(end:-1:1)];
yyy1=[lo_g1, hi_g1(end:-1:1)];
hp1= fill(xxx1,yyy1,[ .8 .8 .8]); hold on;
set(hp1,'FaceColor', [.8 .8 .8],'EdgeColor','none');hold on;

%plot G2 SEM
xxx2=[ts1, ts1(end:-1:1)];
yyy2=[lo_g2, hi_g2(end:-1:1)];
hp2= fill(xxx2,yyy2,[0.9 .85 0.7]); hold on;
set(hp2,'FaceColor', [0.9 .85 0.7],'EdgeColor','none');hold on;

%plot avg Z scores
p2=plot(ts1, zg1_50, 'k', 'LineWidth', 1,'DisplayName','z-score'); hold on;
p3=plot(ts1, zg2_50,  'color',[0.85 .55 0], 'LineWidth', 1,'DisplayName','z-score'); hold on;

  

% uistack(p1,'top') %you can also do uistack(b,'bottom')
    plot(xlim,[0 0],'k--')

xlim([-1200 7200]);ylim([-3 12]);
p1=patch([-200 5 5 -200], [-3 -3 12 12], [1 1 1], 'EdgeColor','none'); hold on;

%  
  %% Figure 3: Z SCORE BY GROUP BLA

hold on
%plot G1 SEM
xxx1=[ts1, ts1(end:-1:1)];
yyy1=[lo_g1, hi_g1(end:-1:1)];
hp1= fill(xxx1,yyy1,[ .7 .8 .9]); hold on;
set(hp1,'FaceColor', [.7 .8 .9],'EdgeColor','none');hold on;


%plot avg Z scores
p2=plot(ts1, zg1_50,  'color',[0.04 .03 0.3], 'LineWidth', 1,'DisplayName','z-score'); hold on;



% uistack(p1,'top') %you can also do uistack(b,'bottom')
    plot(xlim,[0 0],'k--')

xlim([-1200 7200]);ylim([-2 10]);
p1=patch([-20 100 100 -20], [-2 -2 10 10], [1 1 1], 'EdgeColor','none'); hold on;


%% Figure 3: Z SCORE BY GROUP vHIP

hold on
%plot G2 SEM
xxx2=[ts1, ts1(end:-1:1)];
yyy2=[lo_g2, hi_g2(end:-1:1)];
hp2= fill(xxx2,yyy2,[.65 .75 .65]); hold on;
set(hp2,'FaceColor',[.65 .75 .65],'EdgeColor','none');hold on;

%plot avg Z scores

p3=plot(ts1, zg2_50, 'color',[0.2 0.3 0.1],  'LineWidth', 1,'DisplayName','z-score'); hold on;

  

% uistack(p1,'top') %you can also do uistack(b,'bottom')
    plot(xlim,[0 0],'k--')

xlim([-1200 7200]);ylim([-2 10]);
p1=patch([-20 100 100 -20], [-2 -2 10 10], [1 1 1], 'EdgeColor','none'); hold on;