function pos = wave_rotate_occplane(posBp, pos, id, debug)
% pos = wave_rotate_occplane(posBp, pos, id, debag)
%
% posBp: position data of biteplate
% pos: position data for rotating
% id: [front back left right] (2015/02/19 left��right�̏��������ւ�)

% coded by T. Kitamura of Konan Univ.

if nargin < 4
    debug = false;
end

% �����ʌv���v���[�g���4�̃Z���T�̏d�S
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
% ���_�ɃV�t�g

% �����ʌv���v���[�g���4�_�̃V�t�g
center = center_of_cross(front, back, left, right);
front = front - center;
back = back - center;
left = left - center;
right = right - center;

% �����f�[�^�̃V�t�g
for i = 2:length(pos)
    for j = 1:length( pos{i}.xyz )
        % �f�[�^�̂Ȃ������̓X�L�b�v
        % 2015/02/17 �r������f�[�^�������ꍇ�ɑΉ�
        if ~isnan( pos{i}.xyz(j,1) )
            pos{i}.xyz(j,:) = pos{i}.xyz(j,:) - center;
        end
    end
end

% (1) ----------------------------------------------------------
% back�����_�Ƃ����x�N�g����p��
vecL = left - back;
vecR = right - back;

% �O��
c = cross(vecL, vecR);

% ��]
tmp = [c(1) c(2)];
theta = acos( dot(tmp, [0 1]) / norm(tmp) );
if c(1) < 0
    theta = -theta;
end

% z�����S�̉�]�s��
rot = [cos(theta) -sin(theta) 0;...
    sin(theta) cos(theta) 0;...
    0 0 1];

% �����f�[�^�̉�]
for i = 2:length(pos)
    for j = 1:length( pos{i}.xyz )
        if ~isnan( pos{i}.xyz(j,1) )
            pos{i}.xyz(j,:) = rot * pos{i}.xyz(j,:)';
        end
    end
end

% �����ʌv���v���[�g���4�_�̉�]
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
% back�����_�Ƃ����x�N�g����p��
vecR = rotR - rotB;
vecL = rotL - rotB;

% �O��
c = cross(vecL, vecR);

% ��]
tmp = [c(2) c(3)];
theta = acos( dot(tmp, [1 0]) / norm(tmp) );
if c(2) > 0 && c(3) > 0
    theta = -theta;
elseif c(2) < 0 && c(3) < 0
    theta = -theta;
end

% x�����S�̉�]�s��
rot = [1 0 0;...
    0 cos(theta) -sin(theta);...
    0 sin(theta) cos(theta)];

% �����f�[�^�̉�]
for i = 2:length(pos)
    for j = 1:length( pos{i}.xyz )
        if ~isnan( pos{i}.xyz(j,1) )
            pos{i}.xyz(j,:) = rot * pos{i}.xyz(j,:)';
        end
    end
end

% �����ʌv���v���[�g���4�_�̉�]
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
% back����front�֌������x�N�g����p��
vec = rotF - rotB;

% ��]
tmp = [vec(1) vec(3)];
theta = acos( dot(tmp, [-1 0]) / norm(tmp) );
if vec(3) > 0
    theta = -theta;
end

% y�����S�̉�]�s��
rot = [cos(theta) 0 sin(theta);...
    0 1 0;...
    -sin(theta) 0 cos(theta)];

% �����f�[�^�̉�]
for i = 2:length(pos)
    for j = 1:length( pos{i}.xyz )
        if ~isnan( pos{i}.xyz(j,1) )
            pos{i}.xyz(j,:) = rot * pos{i}.xyz(j,:)';
        end
    end
end

% �����ʌv���v���[�g���4�_�̉�]
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
% Z���𔽓]
for i = 1:length(pos)
    for j = 1:length( pos{i}.xyz )
        if ~isnan( pos{i}.xyz(j,1) )
            pos{i}.xyz(j,3) = -pos{i}.xyz(j,3);
        end
    end
end

% (5) ----------------------------------------------------------
% x�����O��ɂȂ�悤�� (2016/11/19�C��)
% y�����S�̉�]�s��
rot = [cos(pi/2) 0 sin(pi/2);...
    0 1 0;...
    -sin(pi/2) 0 cos(pi/2)];

% �����f�[�^�̉�]
for i = 2:length(pos)
    for j = 1:length( pos{i}.xyz )
        if ~isnan( pos{i}.xyz(j,1) )
            pos{i}.xyz(j,:) = rot * pos{i}.xyz(j,:)';
        end
    end
end


% --------------------------------------------------------------
% �{���C�o�C�g�v���[�g��̑O�㍶�E�̃Z���T�����ԏ\���̌�_�����߂�̂����������C
% ���������ăo�C�g�v���[�g��̍��E�̃Z���T�̒��S���W�ő�p���Ă���
function c = center_of_cross(f, b, l, r)

c = (l + r) / 2;
