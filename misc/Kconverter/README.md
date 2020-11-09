# Kconverter
WAVEデータをバイトプレートの位置に合わせる変換プログラムです.

左右のバイトプレートの中点を原点として、
バイトプレートの咬合面を xy 平面とし、
前後および左右を xy 軸としそれに垂直な軸を z 軸とする座標系に変換する.

オリジナルデータを WAVEfront ver.1 のデータ形式に変換してから作動させる必要がある.
preprocess_2017 のソフトを用いて変換できる.

データの読み込み（atはaudiotime）
```
>> [at1,bp]=wave_tsvread('biteplate.tsv'); % バイトプレートのファイル
>> [at2,task]=wave_tsvread('task.tsv'); % 発話タスクのファイル
```

回転処理
```
>> rot_task = wave_rotate_occplane(bp, task, 8:11); %
```

3つ目の引数はバイトプレートのセンサIDに対応

保存
```
>> wave_tsvwrite(at2, rot_task, 'rot_task.tsv');
```

この後，task.wav を rot_task.wav にコピーしないと，VisArticoで音声が出ない

口蓋トレースデータの処理
```
>> [at3,pal]=wave_tsvread('palate.tsv');
>> rot_pal = wave_rotate_occplane(pal, pal, 8:11); %
```

1つ目と2つ目の引数は同じ

```
>> wave_tsvwrite(at3, rot_pal, 'pal_rot.tsv');
```
