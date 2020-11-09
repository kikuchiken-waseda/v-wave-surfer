# -*- coding: utf-8 -*
"""kconverter.py"""
from statistics import mean
import math
import csv

import numpy as np


def center_of_cross(fs, bs, ls, rs):
    """
    バイトプレート上の前後左右のセンサを結ぶ十字の交点を求める

    横着をしてバイトプレート上の左右のセンサの平均座標で代用している
    """
    return [
        [(l + r) / 2 for l, r in zip(ls, rs)],
        [(f + b) / 2 for f, b in zip(fs, bs)],
    ]



def wave_tsvread2(path):
    """
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
    """
    # Define
    NCOLUMNS = 10;
    sensers = []
    waveTime = []
    with open(path) as f:
        for i, cols in enumerate(csv.reader(f, delimiter='\t')):
            if i == 0:
                nColumns = len(cols)
                nSensors = int(math.floor(nColumns / NCOLUMNS))
            else:
                cols = [l for l in cols if l != " "]
                waveTime.append(cols[0])
                sensers.append([
                    {
                        "id": cols[1:][idx:idx + NCOLUMNS][0],
                        "frame": cols[1:][idx:idx + NCOLUMNS][1],
                        "state": cols[1:][idx:idx + NCOLUMNS][2],
                        "Q0": float(cols[1:][idx:idx + NCOLUMNS][3]),
                        "Qx": float(cols[1:][idx:idx + NCOLUMNS][4]),
                        "Qy": float(cols[1:][idx:idx + NCOLUMNS][5]),
                        "Qz": float(cols[1:][idx:idx + NCOLUMNS][6]),
                        "x": float(cols[1:][idx:idx + NCOLUMNS][7]),
                        "y": float(cols[1:][idx:idx + NCOLUMNS][8]),
                        "z": float(cols[1:][idx:idx + NCOLUMNS][9])
                    }
                    for idx in range(0, len(cols[1:]), NCOLUMNS)
                ])
    return waveTime, sensers

def wave_rotate_occplane(posBp, pos, bIdx):
    """
    % posBp: position data of biteplate
    % pos: position data for rotating
    % id: [front back left right] (2015/02/19 leftとrightの順序を入れ替え)
    """
    # 咬合面計測プレート上の4つのセンサの重心を取得
    front = [
        mean([s[bIdx[0]]["x"] for s in posBp ]),
        mean([s[bIdx[0]]["y"] for s in posBp ]),
        mean([s[bIdx[0]]["z"] for s in posBp ])
    ]
    back = [
        mean([s[bIdx[1]]["x"] for s in posBp ]),
        mean([s[bIdx[1]]["y"] for s in posBp ]),
        mean([s[bIdx[1]]["z"] for s in posBp ])
    ]
    left = [
        mean([s[bIdx[2]]["x"] for s in posBp ]),
        mean([s[bIdx[2]]["y"] for s in posBp ]),
        mean([s[bIdx[2]]["z"] for s in posBp ])
    ]
    right = [
        mean([s[bIdx[3]]["x"] for s in posBp ]),
        mean([s[bIdx[3]]["y"] for s in posBp ]),
        mean([s[bIdx[3]]["z"] for s in posBp ])
    ]

    # 原点にシフト
    ## 咬合面計測プレート上の4点のシフト
    center, _ = center_of_cross(front, back, left, right);
    front = [f - c for f, c in zip(front, center)]
    back = [b - c for b, c in zip(back, center)]
    left = [l - c for l, c in zip(left, center)]
    right = [r - c for r, c in zip(right, center)]

    ## 調音データのシフト
    for s in pos[1:]:
        for d in s:
            d["x"] = d["x"] - center[0]
            d["y"] = d["y"] - center[1]
            d["z"] = d["z"] - center[2]


    ## (1) z 軸の回転
    ### back を原点としたベクトルを用意
    vecL = [l - b for l, b in zip(left, back)];
    vecR = [r - b for r, b in zip(right, back)];

    ### 外積
    c = np.cross(vecL, vecR)

    ### 回転
    ### z軸中心の回転行列
    ### 調音データの回転
    ### 咬合面計測プレート上の4点の回転

    ## (2) x 軸の回転
    ### backを原点としたベクトルを用意
    ### 外積
    ### 回転
    ### x軸中心の回転行列
    ### 調音データの回転
    ### 咬合面計測プレート上の4点の回転


    ## (3) z 軸の回転
    ### back から front へ向かうベクトルを用意
    ### 回転
    ### y 軸中心の回転行列
    ### 調音データの回転
    ### 咬合面計測プレート上の4点の回転


    ## (4) ----------------------------------------------------------
    ### Z 軸を反転

    ## (5) ----------------------------------------------------------
    ### x 軸が前後になるように (2016/11/19修正)
    ### y 軸中心の回転行列
    ### 調音データの回転
    return pos


if __name__ == "__main__":
    # ここでバイトプレート上のセンサー番号のデフォルトを設定できる
    sensorNumbers = [9, 10, 11, 12]
    bpath = "../wave/bite_000.tsv"
    waveTime, bsensors = wave_tsvread2(bpath)
    rotBitePlateSensors = wave_rotate_occplane(
        bsensors,
        bsensors,
        sensorNumbers
    )
