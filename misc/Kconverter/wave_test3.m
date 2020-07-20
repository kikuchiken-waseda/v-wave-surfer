function wave_test3(sensorNumbers,msg)

% coded by T. Kitamura of Konan Univ.

% Define
if nargin == 0
    sensorNumbers = 10:13; % ここでバイトプレート上のセンサー番号のデフォルトを設定できる
end

warning ('off','MATLAB:table:ModifiedAndSavedVarnames');

% STEP 1 ------------------------------------------------------------
if nargin < 2
    disp('まずはバイトプレート上のセンサー番号を確認します．')
    disp('バイトプレートを噛んだ状態のTSVファイルを選択してください．[Enter]');
    input('')
end

% Load data measured while the participant bit the bite plate
[bitePlateFile,path] = uigetfile('*.tsv');
if isequal(bitePlateFile,0)
    error('Cancel was selected. Please try again.');
end
[wt,bitePlateSensors] = wave_tsvread2(fullfile(path,bitePlateFile));

if nargin < 2
    disp('バイトプレート上のセンサー番号を指定してください．[Enter]');
    input('')
end

% Get sensor numbers
prompt = {'front','back','left','right'};
title = 'Input';
dims = [1 10];
definput = {num2str(sensorNumbers(1)),...
    num2str(sensorNumbers(2)),...
    num2str(sensorNumbers(3)),...
    num2str(sensorNumbers(4))};
bitePlateSensorNumbers_ = inputdlg(prompt,title,dims,definput);
bitePlateSensorNumbers = str2double(bitePlateSensorNumbers_);
if isempty(bitePlateSensorNumbers)
    error('Cancel was selected. Please try again.');
end

% Rotate axis
rotBitePlateSensors = wave_rotate_occplane(...
    bitePlateSensors,bitePlateSensors,bitePlateSensorNumbers);

if nargin < 2
    disp('バイトプレート上のセンサーをプロットします．');
end

% Plot sensors on bite plate
for i = 1:length(bitePlateSensorNumbers)
    x = -mean(rotBitePlateSensors{bitePlateSensorNumbers(i)}.xyz(:,3));
    y = mean(rotBitePlateSensors{bitePlateSensorNumbers(i)}.xyz(:,1));
    z = mean(rotBitePlateSensors{bitePlateSensorNumbers(i)}.xyz(:,2));
    plot3(x,y,z,'o','MarkerSize',14)
    hold on
    text(x,y,z,num2str(bitePlateSensorNumbers(i)));
end
plot3([-20 50],[0 0],[0 0],'k-')
plot3([0 0],[-25 25],[0 0],'k-')
axis equal; grid on; hold off

if nargin < 2
    disp('配置を確認してください．[Enter]');
    input('')
end

% Go ahead ?
answer = questdlg('センサーはXY平面上で十字に配置されていますか?',...
    'Confirm',...
    'Yes','No','Yes');
if strcmp(answer,'No')
    error('Set the sensor numbers again.');
end
outfile = replace(bitePlateFile,'.tsv','_rot.tsv');
wave_tsvwrite2(wt,rotBitePlateSensors,fullfile(path,outfile));

% STEP 2 ------------------------------------------------------------
if nargin < 2
    disp('回転させるファイルを指定してください(複数選択可)．[Enter]');
    input('')
end

% Load data
[infiles,path] = uigetfile('*.tsv','MultiSelect','on');
if isequal(infiles,0)
    error('Cancel was selected. Please try again.');
end

if iscell(infiles)
    len = length(infiles);
else
    len = 1;
end

% Speech channel
if nargin < 2
    disp('音声チャネルを指定してください．[Enter]');
    input('')
end

answer = questdlg('音声チャネルを指定してください．',...
    'Select',...
    'L','R','LR','L');
switch answer
    case 'L'
        ch = 1;
    case 'R'
        ch = 2;
    case 'LR'
        ch = 0;
end

% Rotation
for i = 1:len
    if len > 1
        infile = infiles{i};
    else
        infile = infiles;
    end
    fprintf(1,'%s\n',infile);
    [wt,sensors] = wave_tsvread2(fullfile(path,infile));
    outfile = replace(infile,'.tsv','_rot.tsv');
    rotSensors = wave_rotate_occplane(...
        bitePlateSensors,sensors,bitePlateSensorNumbers);
    wave_tsvwrite2(wt,rotSensors,fullfile(path,outfile));

    % Copy WAV-files
    inwavfile = replace(infile,'.tsv','.wav');
    [y,fs] = audioread(fullfile(path,inwavfile));
    outwavfile = replace(infile,'.tsv','_rot.wav');
    if ch == 0
        audiowrite(fullfile(path,outwavfile),y,fs);
    else
        audiowrite(fullfile(path,outwavfile),y(:,ch),fs);
    end
end

if nargin < 2
    disp('処理が完了しました．');
end
warning ('on','MATLAB:table:ModifiedAndSavedVarnames');

end


% ------------------------------------------------------------
% WAVE_TSVREAD2
% ------------------------------------------------------------
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


% ------------------------------------------------------------
% WAVE_TSVWRITE2
% ------------------------------------------------------------
function wave_tsvwrite2(wavTime,sensors,file)

[fid,msg] = fopen(file,'w');
if fid < 0
    error(msg);
end

% Header
fprintf(fid,'AudioTime[s]');
fprintf(fid,'\tMeasId');
fprintf(fid,'\tWavId');
for j = 1:length(sensors)
    fprintf(fid,'\tSensor %d Id', j);
    fprintf(fid,'\tSensor %d state', j);
    fprintf(fid,'\tX[mm]');
    fprintf(fid,'\tY[mm]');
    fprintf(fid,'\tZ[mm]');
    fprintf(fid,'\tQ0');
    fprintf(fid,'\tQx');
    fprintf(fid,'\tQy');
    fprintf(fid,'\tQz');
end
fprintf(fid, '\n');

for i = 1:length(wavTime)
    % AudioTime[s], MeasId, WavId
    fprintf(fid,'%f\t',wavTime(i));
    fprintf(fid,'%d\t',i-1);
    fprintf(fid,'0\t'); % WavIdの決定手法が不明

    % Sensors
    for j = 1:length(sensors)
        % Sensor Id
        fprintf(fid,'%d\t',j);

        % Sensor state
        fprintf(fid,'%d\t',sensors{j}.state(i));

        % XYZ
        if j == 1
            for k = 1:7
                fprintf(fid, '0\t'); % the origin of the 3D space
            end
        else
            fprintf(fid,'%f\t%f\t%f\t',...
                sensors{j}.xyz(i,1),...
                sensors{j}.xyz(i,2),...
                sensors{j}.xyz(i,3));

            % Qx4
            for k = 1:4
                fprintf(fid,'0\t');
            end
        end

    end
    fprintf(fid,'\n');
end

fclose(fid);

end


% ------------------------------------------------------------
% WAVE_ROTATE_OCCPLANE
% ------------------------------------------------------------
function pos = wave_rotate_occplane(posBp, pos, id)
% pos = wave_rotate_occplane(posBp, pos, id)
%
% posBp: position data of biteplate
% pos: position data for rotating
% id: [front back left right] (2015/02/19 leftとrightの順序を入れ替え)

% coded by T. Kitamura of Konan Univ.


% 咬合面計測プレート上の4つのセンサの重心 (replace mean_wo_nan to with mean)
front = mean( posBp{id(1)}.xyz );
back = mean( posBp{id(2)}.xyz );
left = mean( posBp{id(3)}.xyz );
right = mean( posBp{id(4)}.xyz );

% (0) ----------------------------------------------------------
% 原点にシフト

% 咬合面計測プレート上の4点のシフト
center = center_of_cross(front, back, left, right);
front = front - center;
back = back - center;
left = left - center;
right = right - center;

% 調音データのシフト
for i = 2:length(pos)
    for j = 1:length( pos{i}.xyz )
        % データのない部分はスキップ
        % 2015/02/17 途中からデータが現れる場合に対応
        if ~isnan( pos{i}.xyz(j,1) )
            pos{i}.xyz(j,:) = pos{i}.xyz(j,:) - center;
        end
    end
end

% (1) ----------------------------------------------------------
% backを原点としたベクトルを用意
vecL = left - back;
vecR = right - back;

% 外積
c = cross(vecL, vecR);

% 回転
tmp = [c(1) c(2)];
theta = acos( dot(tmp, [0 1]) / norm(tmp) );
if c(1) < 0
    theta = -theta;
end

% z軸中心の回転行列
rot = [cos(theta) -sin(theta) 0;...
    sin(theta) cos(theta) 0;...
    0 0 1];

% 調音データの回転
for i = 2:length(pos)
    for j = 1:length( pos{i}.xyz )
        if ~isnan( pos{i}.xyz(j,1) )
            pos{i}.xyz(j,:) = rot * pos{i}.xyz(j,:)';
        end
    end
end

% 咬合面計測プレート上の4点の回転
rotF = rot * front';
rotB = rot * back';
rotL = rot * left';
rotR = rot * right';

% (2) ----------------------------------------------------------
% backを原点としたベクトルを用意
vecR = rotR - rotB;
vecL = rotL - rotB;

% 外積
c = cross(vecL, vecR);

% 回転
tmp = [c(2) c(3)];
theta = acos( dot(tmp, [1 0]) / norm(tmp) );
if c(2) > 0 && c(3) > 0
    theta = -theta;
elseif c(2) < 0 && c(3) < 0
    theta = -theta;
end

% x軸中心の回転行列
rot = [1 0 0;...
    0 cos(theta) -sin(theta);...
    0 sin(theta) cos(theta)];

% 調音データの回転
for i = 2:length(pos)
    for j = 1:length( pos{i}.xyz )
        if ~isnan( pos{i}.xyz(j,1) )
            pos{i}.xyz(j,:) = rot * pos{i}.xyz(j,:)';
        end
    end
end

% 咬合面計測プレート上の4点の回転
rotF = rot * rotF;
rotB = rot * rotB;
rotL = rot * rotL;
rotR = rot * rotR;

% (3) ----------------------------------------------------------
% backからfrontへ向かうベクトルを用意
vec = rotF - rotB;

% 回転
tmp = [vec(1) vec(3)];
theta = acos( dot(tmp, [-1 0]) / norm(tmp) );
if vec(3) > 0
    theta = -theta;
end

% y軸中心の回転行列
rot = [cos(theta) 0 sin(theta);...
    0 1 0;...
    -sin(theta) 0 cos(theta)];

% 調音データの回転
for i = 2:length(pos)
    for j = 1:length( pos{i}.xyz )
        if ~isnan( pos{i}.xyz(j,1) )
            pos{i}.xyz(j,:) = rot * pos{i}.xyz(j,:)';
        end
    end
end

% 咬合面計測プレート上の4点の回転
rotF = rot * rotF;
rotB = rot * rotB;
rotL = rot * rotL;
rotR = rot * rotR;

% (4) ----------------------------------------------------------
% Z軸を反転
for i = 1:length(pos)
    for j = 1:length( pos{i}.xyz )
        if ~isnan( pos{i}.xyz(j,1) )
            pos{i}.xyz(j,3) = -pos{i}.xyz(j,3);
        end
    end
end

% (5) ----------------------------------------------------------
% x軸が前後になるように (2016/11/19修正)
% y軸中心の回転行列
rot = [cos(pi/2) 0 sin(pi/2);...
    0 1 0;...
    -sin(pi/2) 0 cos(pi/2)];

% 調音データの回転
for i = 2:length(pos)
    for j = 1:length( pos{i}.xyz )
        if ~isnan( pos{i}.xyz(j,1) )
            pos{i}.xyz(j,:) = rot * pos{i}.xyz(j,:)';
        end
    end
end

end

% --------------------------------------------------------------
% 本来，バイトプレート上の前後左右のセンサを結ぶ十字の交点を求めるのが正しいが，
% 横着をしてバイトプレート上の左右のセンサの平均座標で代用している
function c = center_of_cross(f, b, l, r)

c = (l + r) / 2;

end
