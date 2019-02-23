function wave_tsvwrite(at, pos, file)
% wave_tsvwrite(at, pos, file)
%
% at: audiotime (vector)
% pos: sensor position data (cell)
% file: name of output TSV file (string)

% Memo
% XYZのところだけ入力し，クオータニオンは無視
% リファレンスセンサの座標を(0,0,0)にしていることに注意．
% 2014/11/17 ヘッダ情報の出力を追加．1-3列の出力を追加(逆になぜこれまで出力していなかったのか)

% coded by T. Kitamura of Konan Univ.

[fid, msg] = fopen(file, 'w');
if fid < 0
    error(msg);
end

% Header
fprintf(fid, 'AudioTime[s]');
fprintf(fid, '\tMeasId');
fprintf(fid, '\tWavId');
for j = 1:length(pos)
    fprintf(fid, '\tSensor %d Id', pos{j}.id);
    fprintf(fid, '\tSensor %d Status', pos{j}.id);
    fprintf(fid, '\tX[mm]');
    fprintf(fid, '\tY[mm]');
    fprintf(fid, '\tZ[mm]');
    fprintf(fid, '\tQ0');
    fprintf(fid, '\tQx');
    fprintf(fid, '\tQy');
    fprintf(fid, '\tQz');
end
fprintf(fid, '\n');

for i = 1:length(at)
    % AudioTime[s], MeasId, WavId
    fprintf(fid, '%f\t', at(i));
    fprintf(fid, '%d\t', i-1);
    fprintf(fid, '0\t'); % WavIdの決定手法が不明
    
    % Sensors
    for j = 1:length(pos)
        % Sensor Id
        fprintf(fid, '%d\t', pos{j}.id);
    
        % Sensor status
%         fprintf(fid, '55\t');
        fprintf(fid, '%d\t', pos{j}.status(i));
    
        % XYZ+Qx4
        if j == 1
            for k = 1:7
                fprintf(fid, '0\t');
            end
        elseif isnan(pos{j}.xyz(i,1))
            for k = 1:7
                fprintf(fid, '\t');
            end
        else
            fprintf(fid, '%f\t%f\t%f\t',...
                pos{j}.xyz(i,1),...
                pos{j}.xyz(i,2),...
                pos{j}.xyz(i,3));
            for k = 1:4
                fprintf(fid, '0\t');
            end
        end
    end
    fprintf(fid, '\n');
end

fclose(fid);
