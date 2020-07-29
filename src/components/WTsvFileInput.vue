<template>
  <v-file-input
    prepend-icon="mdi-cube-outline"
    accept=".tsv"
    label="wave data (.tsv)"
    @change="onFileChange"
  />
</template>

<script>
export default {
  name: "w-tsv-file-input",
  props: {
    value: {
      type: Object,
      default: () => {
        return {
          times: [],
          sensors: [],
          headers: [],
        };
      },
    },
    timeColIdx: {
      type: Number,
      default: 0,
    },
    sensorColWidth: {
      type: Number,
      default: 10,
    },
  },
  computed: {
    obj: {
      get: function () {
        return this.value;
      },
      set: function (val) {
        this.$emit("input", val);
      },
    },
  },
  methods: {
    onFileChange: function (file) {
      if (file) {
        if (file.name.lastIndexOf(".") >= 0) {
          const fr = new FileReader();
          fr.readAsText(file);
          fr.addEventListener("load", () => {
            this.loadTsv(fr.result);
          });
        }
      }
    },
    loadTsv: function (text) {
      const times = [];
      const sensors = {};
      const sensorNames = [];
      const lines = text.split("\n");
      const headers = lines[0].split("\t").filter((x) => x != " ");
      const sensorNum = (headers.length - 1) / this.sensorColWidth;

      // チャンネル情報の取得
      for (let step = 0; step < sensorNum; step++) {
        const baseIdx = step * this.sensorColWidth + 1;
        const key = headers[baseIdx];
        sensorNames.push(key);
        sensors[key] = [];
      }

      // チャンネル毎の値を取得
      lines.forEach((line, index) => {
        if (index > 0) {
          if (line) {
            const cols = line.split("\t").filter((x) => x != " ");
            const time = Number(cols[this.timeColIdx]);
            times.push(time);
            for (let step = 0; step < sensorNum; step++) {
              const baseIdx = step * this.sensorColWidth + 1;
              const key = cols[baseIdx];
              if (key) {
                const item = {
                  name: key,
                  time: time,
                  frame: Number(cols[baseIdx + 1]),
                  state: cols[baseIdx + 2],
                  q0: Number(cols[baseIdx + 3]),
                  qx: Number(cols[baseIdx + 4]),
                  qy: Number(cols[baseIdx + 5]),
                  qz: Number(cols[baseIdx + 6]),
                  tx: Number(cols[baseIdx + 7]),
                  ty: Number(cols[baseIdx + 8]),
                  Tz: Number(cols[baseIdx + 9]),
                };
                sensors[key].push(item);
              }
            }
          }
        }
      });
      this.obj = {
        headers: sensorNames,
        sensors: sensors,
        times: times,
      };
    },
  },
};
</script>
