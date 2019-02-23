# -*- coding: utf-8 -*
"""同階層に存在する WAVE-TSV ファイルを JSON フォーマットに変更."""


def load_tsv(fname):
    import csv
    sensers = []
    times = []
    with open(fname, "r") as f:
        reader = csv.reader(f, delimiter="\t", skipinitialspace=True)
        header = [x for x in next(reader) if x]
        for row in reader:
            row = [x for x in row if x]
            time, item = parse(row)
            times.append(time)
            sensers.append(item)
    fps = round(times[1] - times[0], 4)
    return fps, sensers


def parse(row):
    """それぞれのフレームに起ける各センサーの情報を抽出します．"""
    time = float(row[0])
    body = row[1:]
    sensers = []
    for i in range(int((len(body) - 1) / 10)):
        senser = body[i * 10: (i + 1) * 10]
        item = {
            "id": senser[0],
            "frame": senser[1],
            "State": senser[2],
            "q_0": senser[3],
            "q_x": senser[4],
            "q_y": senser[5],
            "q_z": senser[6],
            "t_x": senser[7],
            "t_y": senser[8],
            "t_z": senser[9]
        }
        sensers.append(item)
    return time, sensers


def main(fname):
    from json import dumps
    fps, sensers = load_tsv(fname)
    dic = {
        "fps": fps,
        "sensers": sensers
    }
    return dumps(dic, indent=2)


if __name__ == "__main__":
    from pathlib import Path
    from operator import itemgetter
    for p in Path(__file__).parent.glob("*.tsv"):
        fname = p.resolve()
        json_str = main(fname)

        json_name = "{}.json".format(fname.stem)
        with open(json_name, "w") as f:
            f.write(json_str)

