function [Min, Sec, MAC, SS] = readcsvr(file,len)

fid = fopen(file);
RawData = textscan(fid, '%s %s %s %s', 'delimiter', ','); % Get data
fclose(fid);

% Data1=replace(RawData{1,1}, '"', '');
% Data2=replace(RawData{1,2}, '"', '');
% Data3=replace(RawData{1,3}, '"', '');

Data1=RawData{1,1};
Data2=RawData{1,2};
Data3=RawData{1,3};

S = regexp(Data1, ':', 'split');
Min = zeros(len,1);
Sec = zeros(len,1);
% Modified according to the file format
% If there is only one ":", go PART1, otherwise go PART2
% PART1 START
for i = 1:len
    Min(i,1) = str2double(cell2mat(S{i,1}(1)));
    Sec(i,1) = str2double(cell2mat(S{i,1}(2)));
end
% PART1 END
% PART2 START
% for i = 1:len
%     Min(i,1) = str2double(cell2mat(S{i,1}(2)));
%     Sec(i,1) = str2double(cell2mat(S{i,1}(3)));
% end
% PART2 END

MAC = Data2(1:len);
SS = Data3(1:len);

end