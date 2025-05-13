function data = read_photometry_data_3(blockpath,firstTTL)

data = TDTbin2mat(blockpath);

%%

%create epocs 3 sessions for trials
%session1
data.epocs.Session.name = 'Session';
data.epocs.Session.onset =firstTTL;
data.epocs.Session.offset = data.epocs.Session.onset+ ones(numel(data.epocs.Session.onset))*60;
data.epocs.Session.data = ones(numel(data.epocs.Session.onset));

end