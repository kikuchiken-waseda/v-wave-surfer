# -*- coding: utf-8 -*
"""同階層に存在する WAVE-TSV ファイルを JSON フォーマットに変更."""
from tqdm import tqdm


def load_tsv(fname):
    import csv
    sensers = []
    times = []
    with open(fname, "r") as f:
        reader = csv.reader(f, delimiter="\t", skipinitialspace=True)
        next(reader)
        for row in reader:
            row = [x for x in row if x]
            time, item = parse(row)
            times.append(time)
            sensers.extend(item)
    fps = round(times[1] - times[0], 4)
    return fps, sensers


def parse(row):
    """それぞれのフレームに起ける各センサーの情報を抽出します．"""
    time = float(row[0])
    body = row[1:]
    sensers = []
    for i in range(int((len(body) - 1) / 10)):
        senser = body[i * 10:(i + 1) * 10]
        if senser[2] == "OK":
            item = {
                "id": senser[0],
                "time": time,
                "state": senser[2],
                "frame": int(senser[1]),
                "q_0": float(senser[3]),
                "q_x": float(senser[4]),
                "q_y": float(senser[5]),
                "q_z": float(senser[6]),
                "t_x": float(senser[7]),
                "t_y": float(senser[8]),
                "t_z": float(senser[9])
            }
        else:
            item = {
                "id": senser[0],
                "time": time,
                "frame": int(senser[1]),
                "state": senser[2]
            }
        sensers.append(item)
    return time, sensers


def normarize(data, minimal=-5, maxim=5):
    _min = min(data)
    _max = max(data)
    _range = maxim - minimal
    tmp = _max - _min
    return [(x - _min) / tmp * _range + minimal for x in data]


def cleanup(sensers):
    x_array = normarize([x["t_x"] for x in sensers if x.get("t_x")])
    y_array = normarize([x["t_y"] for x in sensers if x.get("t_y")])
    z_array = normarize([x["t_z"] for x in sensers if x.get("t_z")])
    series = []
    errors = []
    offset = 0
    old_frame = None
    data = None
    for i, x in enumerate(tqdm(sensers)):
        frame = x["frame"]
        if old_frame != frame:
            if data:
                series.append(data)
            data = []
        if x["state"] == "OK":
            data.append({
                "id": x["id"],
                "state": x["state"],
                "time": round(x["time"], 3),
                "t_x": x_array[i - offset],
                "t_y": y_array[i - offset],
                "t_z": z_array[i - offset]
            })
        else:
            errors.append(i)
            offset = offset + 1
            data.append(x)
        old_frame = frame
    print(min(errors))
    return series


def main(fname):
    from json import dumps
    fps, sensers = load_tsv(fname)
    series = cleanup(sensers)
    dic = {"fps": fps, "sensers": series}
    return dumps(dic, indent=2)


if __name__ == "__main__":
    from pathlib import Path
    for p in Path(__file__).parent.glob("*.tsv"):
        fname = p.resolve()
        json_str = main(fname)

        json_name = "{}.json".format(fname.stem)
        with open(json_name, "w") as f:
            f.write(json_str)
