<template>
  <v-row class="home" align="center" justify="center">
    <v-col cols="12">
      <v-card>
        <v-system-bar color="indigo darken-2" dark>
          <v-spacer></v-spacer>
          <v-icon>mdi-window-minimize</v-icon>
          <v-icon>mdi-window-maximize</v-icon>
          <v-icon>mdi-close</v-icon>
        </v-system-bar>
        <v-toolbar color="indigo" dark>
          <v-toolbar-title>P-3D-VC</v-toolbar-title>
          <v-spacer></v-spacer>
          <w-help-dialog title="P-3D-VC の使い方">
            <p v-for="(text, i) in helpTexts" :key="i">
              {{ text }}
            </p>
          </w-help-dialog>
        </v-toolbar>
        <v-card-text>
          <v-file-input
            prepend-icon="mdi-cube-outline"
            accept="application/x-tgif"
            label="3D Palate Data (.obj)"
            @change="onFileChange"
          />
        </v-card-text>
        <v-row v-if="plateUrl">
          <v-col cols="6">
            <w-palate
              ref="palate"
              v-if="plateUrl"
              :src="plateUrl"
              :camera-position="cameraPosition"
            />
          </v-col>
          <v-col cols="6">
            <v-card-actions>
              <v-switch
                v-model="is90mode"
                label="90 度回転モード"
                color="blue"
                hide-details
              />
              <v-spacer />
              <v-switch
                v-model="isRotmode"
                label="オブジェクト回転モード"
                color="teal"
                hide-details
              />
            </v-card-actions>
            <v-card-actions>
              <w-cross-key
                color="blue darken-1"
                background-color="blue darken-4"
                icon-color="white"
                icon="mdi-video"
                up-icon="mdi-arrow-up-bold"
                left-icon="mdi-arrow-left-bold"
                right-icon="mdi-arrow-right-bold"
                down-icon="mdi-arrow-down-bold"
                :up-func="inc90CRotY"
                :left-func="dec90CRotX"
                :right-func="inc90CRotX"
                :down-func="dec90CRotY"
                v-if="is90mode"
              />
              <w-cross-key
                color="amber darken-1"
                background-color="amber darken-2"
                icon-color="white"
                icon="mdi-video"
                up-icon="mdi-arrow-up-bold"
                left-icon="mdi-arrow-left-bold"
                right-icon="mdi-arrow-right-bold"
                down-icon="mdi-arrow-down-bold"
                :up-func="incCRotY"
                :left-func="decCRotX"
                :right-func="incCRotX"
                :down-func="decCRotY"
                v-else
              />
              <v-spacer />
              <w-up-down-key
                icon="mdi-alpha-z-circle-outline"
                color="teal darken-1"
                background-color="teal darken-4"
                :up-func="incORotZ"
                :down-func="decORotZ"
                v-if="isRotmode"
              />
              <w-up-down-key
                icon="mdi-alpha-z-circle-outline"
                :up-func="incOZ"
                :down-func="decOZ"
                v-else
              />
              <v-spacer />
              <w-cross-key
                icon="mdi-cube-scan"
                color="teal darken-1"
                background-color="teal darken-4"
                :up-func="incORotX"
                :left-func="decORotY"
                :right-func="incORotY"
                :down-func="decORotX"
                v-if="isRotmode"
              />
              <w-cross-key
                icon="mdi-cube-scan"
                :up-func="incOY"
                :left-func="decOX"
                :right-func="incOX"
                :down-func="decOY"
                v-else
              />
            </v-card-actions>
            <v-card-text>
              <v-subheader>camera position (z)</v-subheader>
              <v-slider
                v-model="cameraPosition"
                min="0"
                max="400"
                prepend-icon="mdi-cube-outline"
              >
                <template v-slot:thumb-label>
                  <v-icon dark>mdi-video</v-icon>
                </template>
              </v-slider>
            </v-card-text>
            <v-card-actions>
              <v-btn @click="saveObj" block color="primary" dark>
                Download 3D Data
              </v-btn>
            </v-card-actions>
            <v-card-actions>
              <v-btn @click="toPoints" block color="primary" dark>
                To Point
              </v-btn>
            </v-card-actions>
            <v-card-actions>
              <v-btn @click="rmPoints" block color="primary" dark>
                Remove Point
              </v-btn>
            </v-card-actions>
          </v-col>
        </v-row>
      </v-card>
    </v-col>
  </v-row>
</template>

<script>
import WPalate from "@/components/WPalate.vue";
import WCrossKey from "@/components/base/WCrossKey";
import WUpDownKey from "@/components/base/WUpDownKey";
import WHelpDialog from "@/components/base/WHelpDialog";
export default {
  name: "p-3d-vc",
  components: {
    WPalate,
    WCrossKey,
    WUpDownKey,
    WHelpDialog,
  },
  data: () => ({
    plateUrl: null,
    is90mode: false,
    isRotmode: false,
    cameraPosition: 200,
    count90CRot: {
      incX: 0,
      decX: 0,
      incY: 0,
      decY: 0,
    },
  }),
  methods: {
    onFileChange: function (e) {
      if (e === undefined || e === null) this.plateUrl = null;
      if (e.name.lastIndexOf(".") <= 0) this.plateUrl = null;
      const fr = new FileReader();
      fr.readAsDataURL(e);
      fr.addEventListener("load", () => {
        this.plateUrl = fr.result;
      });
    },
    saveObj: function () {
      if (this.$refs.palate) this.$refs.palate.saveObj();
    },
    toPoints: function () {
      if (this.$refs.palate) this.$refs.palate.toPoints();
    },
    rmPoints: function () {
      if (this.$refs.palate) this.$refs.palate.removePoints();
    },
    incOX: function () {
      if (this.$refs.palate) this.$refs.palate.incOX();
    },
    decOX: function () {
      if (this.$refs.palate) this.$refs.palate.decOX();
    },
    incOY: function () {
      if (this.$refs.palate) this.$refs.palate.incOY();
    },
    decOY: function () {
      if (this.$refs.palate) this.$refs.palate.decOY();
    },
    incOZ: function () {
      if (this.$refs.palate) this.$refs.palate.incOZ();
    },
    decOZ: function () {
      if (this.$refs.palate) this.$refs.palate.decOZ();
    },
    incORotX: function () {
      if (this.$refs.palate) this.$refs.palate.incORotX();
    },
    decORotX: function () {
      if (this.$refs.palate) this.$refs.palate.decORotX();
    },
    incORotY: function () {
      if (this.$refs.palate) this.$refs.palate.incORotY();
    },
    decORotY: function () {
      if (this.$refs.palate) this.$refs.palate.decORotY();
    },
    incORotZ: function () {
      if (this.$refs.palate) this.$refs.palate.incORotZ();
    },
    decORotZ: function () {
      if (this.$refs.palate) this.$refs.palate.decORotZ();
    },
    incCRotX: function () {
      if (this.$refs.palate) this.$refs.palate.incCRotX();
    },
    decCRotX: function () {
      if (this.$refs.palate) this.$refs.palate.decCRotX();
    },
    incCRotY: function () {
      if (this.$refs.palate) this.$refs.palate.incCRotY();
    },
    decCRotY: function () {
      if (this.$refs.palate) this.$refs.palate.decCRotY();
    },
    inc90CRotX: function () {
      if (this.$refs.palate) {
        this.count90CRot.incX += 1;
        let rot = 0;
        if (this.count90CRot.incX % 4 == 1) {
          rot = 90;
        } else if (this.count90CRot.incX % 4 == 2) {
          rot = 0;
        } else if (this.count90CRot.incX % 4 == 3) {
          rot = -90;
        }
        this.$refs.palate.updateCRotX(rot);
      }
    },
    dec90CRotX: function () {
      if (this.$refs.palate) {
        this.count90CRot.decX += 1;
        let rot = 0;
        if (this.count90CRot.decX % 4 == 1) {
          rot = -90;
        } else if (this.count90CRot.decX % 4 == 2) {
          rot = 0;
        } else if (this.count90CRot.decX % 4 == 3) {
          rot = 90;
        }
        this.$refs.palate.updateCRotX(rot);
      }
    },
    inc90CRotY: function () {
      if (this.$refs.palate) {
        this.count90CRot.incY += 1;
        let rot = 0;
        if (this.count90CRot.incY % 4 == 1) {
          rot = 90;
        } else if (this.count90CRot.incY % 4 == 2) {
          rot = 0;
        } else if (this.count90CRot.incY % 4 == 3) {
          rot = -90;
        }
        this.$refs.palate.updateCRotY(rot);
      }
    },
    dec90CRotY: function () {
      if (this.$refs.palate) {
        this.count90CRot.decY += 1;
        let rot = 0;
        if (this.count90CRot.decY % 4 == 1) {
          rot = -90;
        } else if (this.count90CRot.decY % 4 == 2) {
          rot = 0;
        } else if (this.count90CRot.decY % 4 == 3) {
          rot = 90;
        }
        this.$refs.palate.updateCRotY(rot);
      }
    },
  },
  computed: {
    helpTexts: () => [
      "まずは硬口蓋データを選択してください.",
      "その後, 以下のコントローラが表示されます.",
      "",
      "90度回転モードスイッチ: カメラ十字キーのモードを変更します.",
      "オブジェクト回転モードスイッチ: オブジェクト十字キーおよびオブジェクト Z キーのモードを変更します",
      "カメラ十字キー: カメラを回転させます. 十字キーが青くなっている場合, 90 度ずつの回転になります",
      "オブジェクト十字キー: オブジェクトの位置を変更します. 十字キーが緑になっている場合, オブジェクトを回転させます",
      "オブジェクトZキー: オブジェクトの位置(Z軸方向)を変更します",
      "十字キーが緑になっている場合, オブジェクトを回転させます",
      "camera position: カメラとオブジェクトとの距離を変更します",
    ],
  },
};
</script>
