<template>
  <v-row class="home" align="center" justify="center">
    <v-col cols="6">
      <v-card>
        <v-system-bar color="indigo darken-2" dark>
          <v-spacer></v-spacer>
          <v-icon>mdi-window-minimize</v-icon>
          <v-icon>mdi-window-maximize</v-icon>
          <v-icon>mdi-close</v-icon>
        </v-system-bar>
        <v-toolbar color="indigo" dark>
          <v-toolbar-title>A-3D-VC</v-toolbar-title>
          <v-spacer></v-spacer>
          <w-help-dialog title="A-3D-VC の使い方">
            <p>まずは WAVE データ(.tsv) を選択してください.</p>
          </w-help-dialog>
        </v-toolbar>
        <v-card-text>
          <w-tsv-file-input v-model="bitePlateSensors" />
        </v-card-text>
        <v-list v-if="bitePlateSensors.headers.length > 0">
          <v-subheader
            >センサー数: {{ bitePlateSensors.headers.length }} 個</v-subheader
          >
          <v-list-item v-for="(name, key) in bitePlateSensorNames" :key="key">
            <v-list-item-content>
              <v-list-item-title>{{ name }}</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </v-list>
      </v-card>
    </v-col>
  </v-row>
</template>

<script>
import WHelpDialog from "@/components/base/WHelpDialog";
import WTsvFileInput from "@/components/WTsvFileInput";
export default {
  name: "a-3d-vc",
  components: {
    WHelpDialog,
    WTsvFileInput,
  },
  data: () => ({
    sensorNumbers: [10, 11, 12, 13],
    bitePlateSensors: {
      times: [],
      sensors: [],
      headers: [],
    },
  }),
  methods: {
    renserBitePlate: function () {
      // バイトプレートの可視化
    },
    rotate: function () {
      // wave_rotate_occplane を参考に回転を定義
      const f = this.bitePlateSensors.sensors[this.bitePlateSensorNames[0]];
      const b = this.bitePlateSensors.sensors[this.bitePlateSensorNames[1]];
      const l = this.bitePlateSensors.sensors[this.bitePlateSensorNames[2]];
      const r = this.bitePlateSensors.sensors[this.bitePlateSensorNames[3]];
      console.log(f, b, l, r);
    },
    get_center_of_cross(f, b, l, r) {
      // 四点の中心を算出
      return {
        y: (f + b) / 2,
        x: (l + r) / 2,
      };
    },
  },
  computed: {
    bitePlateSensorNames: function () {
      const names = [];
      if (this.bitePlateSensors.headers.length > 0) {
        return this.sensorNumbers.map((i) => {
          return this.bitePlateSensors.headers[i];
        });
      }
      return names;
    },
  },
};
</script>
