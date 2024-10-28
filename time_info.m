clear
close all

% obtain the time information of TLP INI FIN

read_dir_TLP = fullfile(pwd,'minion_pics/');
read_dir_INI = fullfile(pwd,'minion_pics/INI/');
read_dir_FIN = fullfile(pwd,'minion_pics/FIN/');
list_TLP = dir(fullfile(read_dir_TLP,'*.jpg'));
list_INI = dir(fullfile(read_dir_INI,'*.jpg'));
list_FIN = dir(fullfile(read_dir_FIN,'*.jpg'));


%% TLP
expression = '(?<id1>\d+)-(?<id2>\d+)-(?<year>\d+)-(?<month>\d+)-(?<date>\d+)_(?<hour>\d+)-(?<minute>\d+)-(?<second>\d+)_IMG-TLP.jpg';
timeInfo = struct('id1', {}, 'id2', {}, 'year', {}, 'month', {}, 'date', {}, 'hour', {}, 'minute', {}, 'second', {});
for i = 1:length(list_TLP)
    try
        timeInfo(i) = regexp(list_TLP(i).name,expression,'names');
    catch
    end
end

tMatrix_TLP = zeros(length(list_TLP),6);

for i = 1:length(list_TLP)
    tMatrix_TLP(i,1) = str2double(timeInfo(i).year);
    tMatrix_TLP(i,2) = str2double(timeInfo(i).month);
    tMatrix_TLP(i,3) = str2double(timeInfo(i).date);
    tMatrix_TLP(i,4) = str2double(timeInfo(i).hour);
    tMatrix_TLP(i,5) = str2double(timeInfo(i).minute);
    tMatrix_TLP(i,6) = str2double(timeInfo(i).second);
end

time_TLP = datetime(tMatrix_TLP);

clearvars timeInfo expression

%% INI
expression = '(?<id1>\d+)-(?<id2>\d+)-(?<year>\d+)-(?<month>\d+)-(?<date>\d+)_(?<hour>\d+)-(?<minute>\d+)-(?<second>\d+)_IMG-INI.jpg';
timeInfo = struct('id1', {}, 'id2', {}, 'year', {}, 'month', {}, 'date', {}, 'hour', {}, 'minute', {}, 'second', {});
for i = 1:length(list_INI)
    try
        timeInfo(i) = regexp(list_INI(i).name,expression,'names');
    catch
    end
end

tMatrix_INI = zeros(length(list_INI),6);

for i = 1:length(list_INI)
    tMatrix_INI(i,1) = str2double(timeInfo(i).year);
    tMatrix_INI(i,2) = str2double(timeInfo(i).month);
    tMatrix_INI(i,3) = str2double(timeInfo(i).date);
    tMatrix_INI(i,4) = str2double(timeInfo(i).hour);
    tMatrix_INI(i,5) = str2double(timeInfo(i).minute);
    tMatrix_INI(i,6) = str2double(timeInfo(i).second);
end

time_INI = datetime(tMatrix_INI);

clearvars timeInfo expression

%% FNI
expression = '(?<id1>\d+)-(?<id2>\d+)-(?<year>\d+)-(?<month>\d+)-(?<date>\d+)_(?<hour>\d+)-(?<minute>\d+)-(?<second>\d+)_IMG-FIN.jpg';
timeInfo = struct('id1', {}, 'id2', {}, 'year', {}, 'month', {}, 'date', {}, 'hour', {}, 'minute', {}, 'second', {});
for i = 1:length(list_FIN)
    try
        timeInfo(i) = regexp(list_FIN(i).name,expression,'names');
    catch
    end
end

tMatrix_FIN = zeros(length(list_FIN),6);

for i = 1:length(list_FIN)
    tMatrix_FIN(i,1) = str2double(timeInfo(i).year);
    tMatrix_FIN(i,2) = str2double(timeInfo(i).month);
    tMatrix_FIN(i,3) = str2double(timeInfo(i).date);
    tMatrix_FIN(i,4) = str2double(timeInfo(i).hour);
    tMatrix_FIN(i,5) = str2double(timeInfo(i).minute);
    tMatrix_FIN(i,6) = str2double(timeInfo(i).second);
end

time_FIN = datetime(tMatrix_FIN);

clearvars timeInfo expression i 