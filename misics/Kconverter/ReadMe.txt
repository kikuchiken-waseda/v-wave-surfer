WAVE�f�[�^���o�C�g�v���[�g�̈ʒu�ɍ��킹��ϊ��v���O����
���E�̃o�C�g�v���[�g�̒��_�����_�Ƃ��āA
�o�C�g�v���[�g�̙����ʂ�xy���ʂƂ��A
�O�エ��э��E��xy���Ƃ�����ɐ����Ȏ���z���Ƃ�����W�n�ɕϊ�����X�N���v�g�ł���B

�I���W�i���f�[�^��WAVEfront ver.1�̃f�[�^�`���ɕϊ����Ă���쓮������K�v������B
preprocess_2017�̃\�t�g��p���ĕϊ��ł���B

�f�[�^�̓ǂݍ��݁iat��audiotime�j
 >> [at1,bp]=wave_tsvread('biteplate.tsv'); % �o�C�g�v���[�g�̃t�@�C��
 >> [at2,task]=wave_tsvread('task.tsv'); % ���b�^�X�N�̃t�@�C��

��]����
 >> rot_task = wave_rotate_occplane(bp, task, 8:11); % 
3�ڂ̈����̓o�C�g�v���[�g�̃Z���TID�ɑΉ�

�ۑ�
 >> wave_tsvwrite(at2, rot_task, 'rot_task.tsv');
���̌�Ctask.wav��rot_task.wav�ɃR�s�[���Ȃ��ƁCVisArtico�ŉ������o�Ȃ�

���W�g���[�X�f�[�^�̏���
 >> [at3,pal]=wave_tsvread('palate.tsv');
 >> rot_pal = wave_rotate_occplane(pal, pal, 8:11); % 
1�ڂ�2�ڂ̈����͓���
 >> wave_tsvwrite(at3, rot_pal, 'pal_rot.tsv');
