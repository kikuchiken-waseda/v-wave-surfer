function pos = wave_rotate_occplane(posBp, pos, id, debug)
% pos = wave_rotate_occplane(posBp, pos, id, debag)
%
% posBp: position data of biteplate
% pos: position data for rotating
% id: [front back left right] (2015/02/19 leftとrightの順序を入れ替え)

% coded by T. Kitamura of Konan Univ.

if nargin < 4
    debug = false;
end

% 咬合面計測プレート上の4つのセンサの重心
front = mean_wo_nan( posBp{id(1)}.xyz );
back = mean_wo_nan( posBp{id(2)}.xyz );
left = mean_wo_nan( posBp{id(3)}.xyz );
right = mean_wo_nan( posBp{id(4)}.xyz );

if debug
    hold off
    plot3([front(1) back(1)],[front(2) back(2)],[front(3) back(3)],'bo--');
    hold on
    plot3([right(1) left(1)],[right(2) left(2)],[right(3) left(3)],'ro--');
end

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

if debug
    c = c / norm(c) * 10;
    cent = [(right(1)+left(1))/2 (right(2)+left(2))/2 (right(3)+left(3))/2];
    plot3([cent(1) cent(1)+c(1)],[cent(2) cent(2)+c(2)],[cent(3) cent(3)+c(3)],'ko-');
    plot3([rotF(1) rotB(1)],[rotF(2) rotB(2)],[rotF(3) rotB(3)],'bo-.');
    plot3([rotR(1) rotL(1)],[rotR(2) rotL(2)],[rotR(3) rotL(3)],'ro-.');
    xlabel('x'); ylabel('y'); zlabel('z')
    axis equal; grid on; view(0,90)
%     return
end

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

if debug
    plot3([rotF(1) rotB(1)],[rotF(2) rotB(2)],[rotF(3) rotB(3)],'bo-');
    plot3([rotR(1) rotL(1)],[rotR(2) rotL(2)],[rotR(3) rotL(3)],'ro-');
    xlabel('x'); ylabel('y'); zlabel('z')
    axis equal; grid on; view(-90,0)
%     return
end

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
    
if debug
    plot3([rotF(1) rotB(1)],[rotF(2) rotB(2)],[rotF(3) rotB(3)],'bo-', 'linewidth', 2);
    plot3([rotR(1) rotL(1)],[rotR(2) rotL(2)],[rotR(3) rotL(3)],'ro-', 'linewidth', 2);
    xlabel('x'); ylabel('y'); zlabel('z')
    axis equal; grid on
    view(0, 0)
end

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


% --------------------------------------------------------------
% 本来，バイトプレート上の前後左右のセンサを結ぶ十字の交点を求めるのが正しいが，
% 横着をしてバイトプレート上の左右のセンサの中心座標で代用している
function c = center_of_cross(f, b, l, r)

c = (l + r) / 2;
