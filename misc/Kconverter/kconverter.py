
function [wavTime,sensors] = wave_tsvread2(infile)

% Define
NCOLUMNS_FOR_A_SENSOR = 10;

% Load data
T = readtable(infile,'filetype','text','delimiter','\t');
C = table2cell(T);
[nRows, nColumns] = size(C);

% Wav Time
wavTime = [C{:,1}];

% The number of sensors (assuming two SCUs)
nSensors = floor(nColumns / NCOLUMNS_FOR_A_SENSOR);

% Load sensor data
sensors = cell(nSensors,1);
firstColumn = 2;
for n = 1:nSensors
    id = C{1,firstColumn};
    while isnan(id)
        firstColumn = firstColumn + 1;
        id = C{1,firstColumn};
    end
    state = zeros(nRows,1);
    xyz = zeros(nRows,3);
    for k = 1:nRows
        if strcmp(C{k,firstColumn+2},'OK')
            state(k) = 55;
            xyz(k,:) = [C{k,(firstColumn+7):(firstColumn+9)}];
        else % Bad fit, Processing error, Signal too small
            state(k) = 119;
        end
    end
    sensors{n} = struct(...
        'id', id,...
        'state', state,...
        'xyz', xyz);

    % Increment
    firstColumn = firstColumn + NCOLUMNS_FOR_A_SENSOR;
end

end

