# -*- coding: utf-8 -*
"""同階層に存在する WAVE-TSV ファイルを JSON フォーマットに変更."""


def load_tsv(fname):
    import csv
    sensers = []
    with open(fname, "r") as f:
        reader = csv.reader(f, delimiter="\t", skipinitialspace=True)
        header = [x for x in next(reader) if x]
        for row in reader:
            row = [x for x in row if x]
            item = parse(row)
            sensers.extend(item)
    return sensers


def parse(row):
    """それぞれのフレームに起ける各センサーの情報を抽出します．"""
    time = float(row[0])
    body = row[1:]
    sensers = []
    for i in range(int((len(body) - 1) / 10)):
        senser = body[i * 10: (i + 1) * 10]
        if senser[2] == "OK":
            item = {
                "t_x": int(float(senser[7]) * 1000) / 1000,
                "t_y": int(float(senser[8]) * 1000) / 1000,
                "t_z": int(float(senser[9]) * 1000) / 1000
            }
            print(item)
        sensers.append(item)
    return sensers


# def normarize(data, minimal=5, maxim=5):
#     return [
#         (x - min(data)) / max(data) - min(data) * (maxim - minimal) + minimal
#         for x in data
#     ]
# 
# 
# def cleanup(sensers):
#     x_array = normarize([x.get("t_x") for x in sensers])
#     y_array = normarize([x.get("t_y") for x in sensers])
#     z_array = normarize([x.get("t_z") for x in sensers])
#     series = []
#     old_frame = None
#     for i, x in emulate(sensers):
#         frame = x["frame"]
#         if old_frame != frame:
#             series.append(data)
#             data = []
#         data.append({"id": x["id"], "frame": frame, "t_x": x_array[i], "t_y":
#                      y_array[i], "t_z": x_array[i]})
#         old_frame = frame
#     return series



def main(fname):
    sensers = load_tsv(fname)
    x = []
    y = []
    z = []
    for s in sensers:
        x.append(s["t_x"])
        y.append(s["t_y"])
        z.append(s["t_z"])
    print("x: {} - {}".format(min(x), max(x)))
    print("y: {} - {}".format(min(y), max(y)))
    print("z: {} - {}".format(min(z), max(z)))


if __name__ == "__main__":
    from pathlib import Path
    from operator import itemgetter
    for p in Path(__file__).parent.glob("*.tsv"):
        fname = p.resolve()
        main(fname)


