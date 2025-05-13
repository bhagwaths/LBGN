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
 
blockpaths = {'C:\Users\bhagwaths\Documents\AS-vHIP-BLA\day 1 120224\AS_vHIP_BLA_1-240816-084831'...
'C:\Users\bhagwaths\Documents\AS-vHIP-BLA\day 1 120224\AS_vHIP_BLA_3-240816-113157'...
'C:\Users\bhagwaths\Documents\AS-vHIP-BLA\day 1 120224\AS_vHIP_BLA_4-241202-122100'...
'C:\Users\bhagwaths\Documents\AS-vHIP-BLA\day 1 120224\AS_vHIP_BLA_5-240816-141239'...
'C:\Users\bhagwaths\Documents\AS-vHIP-BLA\day 1 120224\AS_vHIP_BLA_6-241202-150136'...
'C:\Users\bhagwaths\Documents\AS-vHIP-BLA\day 1 120224\AS_vHIP_BLA_7-240816-165607'...
'C:\Users\bhagwaths\Documents\AS-vHIP-BLA\day 1 120224\AS_vHIP_BLA_8-241202-174523'...
'C:\Users\bhagwaths\Documents\AS-vHIP-BLA\day 1 120224\AS_vHIP_BLA_1-240816-084831'...
'C:\Users\bhagwaths\Documents\AS-vHIP-BLA\day 1 120224\AS_vHIP_BLA_2-241202-093735'...
'C:\Users\bhagwaths\Documents\AS-vHIP-BLA\day 1 120224\AS_vHIP_BLA_4-241202-122100'...
'C:\Users\bhagwaths\Documents\AS-vHIP-BLA\day 1 120224\AS_vHIP_BLA_5-240816-141239'...
'C:\Users\bhagwaths\Documents\AS-vHIP-BLA\day 1 120224\AS_vHIP_BLA_6-241202-150136'...
'C:\Users\bhagwaths\Documents\AS-vHIP-BLA\day 1 120224\AS_vHIP_BLA_7-240816-165607'...
'C:\Users\bhagwaths\Documents\AS-vHIP-BLA\day 1 120224\AS_vHIP_BLA_8-241202-174523'};

threshold = [0.5; 0.4; 0.6; 0.4; 0.5; 0.4; 0.5;
            0.4; 0.4; 0.4; 0.4; 0.5; 0.5; 0.4];
 
groupNames={'BLA','vHIP'};

 
groups= {'BLA';'BLA';'BLA';'BLA';'BLA';'BLA';'BLA';
         'vHIP';'vHIP';'vHIP';'vHIP';'vHIP';'vHIP';'vHIP'};

%YOU WILL NEED TO CHANGE THIS 
%stream codes:
%12 means 'ax05G','ax70G'
%34 means 'a_05G','a_70G'



whichStreams= [12; 12; 12; 12; 12; 12; 12;
               34; 34; 34; 34; 34; 34; 34];

firstTTL=[1617;1322;1438;1255;1452;1246;1268;
          1617;1529;1438;1255;1452;1246;1268];


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

    maxpeak{1,aaa}=maxtab;
    minpeak{1,aaa}=mintab;
    amplitude{1,aaa}=maxpeak{1,aaa}(:,3)-minpeak{1,aaa}(:,3);

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
%

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

total_time_range = [start(2), stop(end)];

for i=1:numAnimals
    bslnum=find(maxpeak{1,i}(:,2)<stop(1) & maxpeak{1,i}(:,2)>=start(1));
    baselinepeaks=[baselinepeaks; numel(bslnum)];
    avgampbsl=[avgampbsl; mean(amplitude{1,i}(bslnum))];
    
    for j=2:length(start)
        pharmnum{j-1} = find(maxpeak{1,i}(:,2)<stop(j) & maxpeak{1,i}(:,2)>=start(j));
        pharmpeaks{j-1}=[pharmpeaks{j-1}; numel(pharmnum{j-1})];
        avgamppharm{j-1}=[avgamppharm{j-1}; mean(amplitude{1,i}(pharmnum{j-1}))];
    end

    totalnum=find(maxpeak{1,i}(i,2)<total_time_range(2) & maxpeak{1,i}(:,2)>total_time_range(1));
    totalpeaks=[totalpeaks; numel(totalnum)];
    avgamptotal=[avgamptotal; mean(amplitude{1,i}(totalnum))];
end

for i=1:numAnimals
    baselinefreq = baselinepeaks / durations(1);
    totalfreq = totalpeaks / (total_time_range(2) - total_time_range(1));
end

pharmfreq = [];
for i=1:numel(pharmpeaks)
    pharmfreq = [pharmfreq, pharmpeaks{i} / durations(i+1)];
end

filename = 'AS-vHIP-BLA_stress_day1_2.xlsx';
sheetname = 'Peaks Stress';
header = {'Animal Name'; 'Peaks '+string(start(1))+'-'+string(stop(1)); 'Peaks '+string(start(2))+'-'+string(stop(2)); 
    'Peaks '+string(start(3))+'-'+string(stop(3));  'Peaks '+string(start(4))+'-'+string(stop(4)); 
    'Peaks '+string(start(5))+'-'+string(stop(5)); 'Peaks '+string(total_time_range(1))+'-'+string(total_time_range(2));
    'Average Amp '+string(start(1))+'-'+string(stop(1)); 'Average Amp '+string(start(2))+'-'+string(stop(2));
    'Average Amp '+string(start(3))+'-'+string(stop(3)); 'Average Amp '+string(start(4))+'-'+string(stop(4));
    'Average Amp '+string(start(5))+'-'+string(stop(5)); 'Average Amp '+string(total_time_range(1))+'-'+string(total_time_range(2));
    'Average Freq '+string(start(1))+'-'+string(stop(1)); 'Average Freq '+string(start(2))+'-'+string(stop(2));
    'Average Freq '+string(start(3))+'-'+string(stop(3)); 'Average Freq '+string(start(4))+'-'+string(stop(4));
    'Average Freq '+string(start(5))+'-'+string(stop(5)); 'Average Freq '+string(total_time_range(1))+'-'+string(total_time_range(2))};

pharmpeaks_combined = [];
avgamppharm_combined = [];

for i=1:length(start)-1
    pharmpeaks_combined = [pharmpeaks_combined pharmpeaks{i}];
    avgamppharm_combined = [avgamppharm_combined avgamppharm{i}];
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

headers = {'Time Max'; 'Max Peak'; 'Time Min'; 'Min Peak'; 'Amplitude'; 'Peak Duration'; 'Frequency'};
for i=1:numAnimals
    writecell(headers.', filename, 'Sheet', sprintf('%s (%s)', animalNames{i}, groups{i}), 'Range', 'A1');
    writematrix(maxpeak{1,i}(:,2:3), filename, 'Sheet', sprintf('%s (%s)', animalNames{i}, groups{i}), 'Range', 'A2');
    writematrix(minpeak{1,i}(:,2:3), filename, 'Sheet', sprintf('%s (%s)', animalNames{i}, groups{i}), 'Range', 'C2');
    writematrix(amplitude{1,i}(:), filename, 'Sheet', sprintf('%s (%s)', animalNames{i}, groups{i}), 'Range', 'E2');
    writematrix(minpeak{1,i}(:,2) - maxpeak{1,i}(:,2), filename, 'Sheet', sprintf('%s (%s)', animalNames{i}, groups{i}), 'Range', 'F2');
    writematrix((size(maxpeak{1,i}, 1) ./ (minpeak{1,i}(:,2) - maxpeak{1,i}(:,2))), filename, 'Sheet', sprintf('%s (%s)', animalNames{i}, groups{i}), 'Range', 'G2');
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

% %Find AUCs for each animal in group 1
% [rows,~]=size(g1_lump);
% for n=1:rows 
%     AUC_g1base(n)=trapz(g1_lump(n,ts1>-700 & ts1<-100))/100;
%     AUC_g1_30(n)=trapz(g1_lump(n,ts1>0 & ts1<1800))/300;
%     AUC_g1_60(n)=trapz(g1_lump(n,ts1>1800 & ts1<3600))/300;
%     AUC_g1_90(n)=trapz(g1_lump(n,ts1>3600 & ts1<5400))/300;
%     AUC_g1_120(n)=trapz(g1_lump(n,ts1>3600 & ts1<7200))/300;
%     AUC_g1_all(n)=trapz(g1_lump(n,ts1>0 & ts1<7200))/1200;
% end
% 
% %Find AUCs for each animal in group 2
% [rows,~]=size(g2_lump);
% for n=1:rows
%     AUC_g2base(n)=trapz(g2_lump(n,ts1>-700 & ts1<-100))/100;
%     AUC_g2_30(n)=trapz(g2_lump(n,ts1>0 & ts1<3600))/300;
%     AUC_g2_60(n)=trapz(g2_lump(n,ts1>1800 & ts1<3600))/300;
%     AUC_g2_90(n)=trapz(g2_lump(n,ts1>3600 & ts1<5400))/300;
%     AUC_g2_120(n)=trapz(g2_lump(n,ts1>3600 & ts1<7200))/300;
%     AUC_g2_all(n)=trapz(g2_lump(n,ts1>0 & ts1<7200))/1200;
% end
% 
% AUC_g1_heading = ["AUC_g1base" "AUC_g1_30" "AUC_g1_60"  "AUC_g1_90"  "AUC_g1_120"  "AUC_g1_all"];
% AUC_g1 = [AUC_g1base; AUC_g1_30; AUC_g1_60; AUC_g1_90; AUC_g1_120; AUC_g1_all];
% AUC_g1_transposed = AUC_g1';
% AUC_g1_table = array2table(AUC_g1_transposed, "VariableNames", AUC_g1_heading);
% 
% AUC_g2_heading = ["AUC_g2t1base" "AUC_g2_30" "AUC_g2_60"  "AUC_g2_90" "AUC_g2_120"  "AUC_g2_all"];
% AUC_g2 = [AUC_g2base; AUC_g2_30; AUC_g2_60; AUC_g2_90; AUC_g2_120; AUC_g2_all];
% AUC_g2_transposed = AUC_g2';
% AUC_g2_table = array2table(AUC_g2_transposed, "VariableNames", AUC_g2_heading);    

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
