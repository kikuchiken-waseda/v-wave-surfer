# -*- coding: utf-8 -*
"""WAVE から出力されたTSV をJSONフォーマットに変更する."""


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


if __name__ == "__main__":
    from pathlib import Path
    for p in Path(__file__).parent.glob("*.tsv"):
        fname = p.resolve()
        fps, body = load_tsv(fname)
        print(fps)
        # parser(body)
