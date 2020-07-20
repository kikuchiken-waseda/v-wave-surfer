function [audiotime, pos] = wave_tsvread(tsvfile)
% [audiotime, pos] = wave_tsvread(tsvfile)
%
% tsvfile: name of input TSV file (string)
% autiotime: data of 1st column of TSV file (vector)
% pos: sensor position data (cell)

% coded by T. Kitamura of Konan Univ.

% Define
NCOLUMNS_FOR_A_SENSOR = 9;
AUDIOTIME = 1;
WAVID = 3;

% Load all of the file
data = importdata(tsvfile, '\t');
[nRows, nColumns] = size(data.data);

% The number of sensors
nColumns_ = (nColumns-WAVID) - mod((nColumns-WAVID), NCOLUMNS_FOR_A_SENSOR); % 2014/01/29
nSensors = nColumns_ / NCOLUMNS_FOR_A_SENSOR;

% AudioTime[s]
audiotime = data.data(1:nRows, AUDIOTIME);

% For each sensor
pos = cell(nSensors, 1);
for i = 1:nSensors
    firstColumn = WAVID + (i-1)*NCOLUMNS_FOR_A_SENSOR + 1;
    id = data.data(1, firstColumn) + 1;
    status = data.data(1:nRows, firstColumn + 1);
    xColumn = firstColumn + 2;
    zColumn = xColumn + 2;
    xyz = data.data(1:nRows, xColumn:zColumn);
    
    pos{i} = struct(...
        'id', id,...
        'status', status,...
        'xyz', xyz);
end
