<template>
  <v-container grid-list-md>
    <v-layout wrap v-show="$store.state.is_loading">
      <v-progress-circular
        :size="100"
        :width="10"
        color="purple"
        indeterminate
      />
    </v-layout>
    <v-layout wrap v-show="!$store.state.is_loading">
      <v-flex xs12> </v-flex>
      <v-flex xs12>
        <v-layout wrap row>
          <v-wave :frame_rate="data.fps" :series="items" />
          <v-flex ml-2>
            <v-audio :audio="audio" />
          </v-flex>
        </v-layout>
      </v-flex>
      <v-flex xs12>
        <v-audio-list />
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
import VAudio from "@/components/VAudio";
import VAudioList from "@/components/VAudioList";
import VWave from "@/components/VWave";

import data from "@/assets/data/pretest_000.json";
import wav from "@/assets/data/pretest_000_left.wav";

export default {
  components: {
    VAudioList,
    VAudio,
    VWave
  },
  data: () => ({
    audio: wav,
    data: data
  }),
  computed: {
    items: function() {
      return this.data.sensers;
    }
  },
  beforeDestroy() {
    if (this.wav) {
      this.wav = null;
    }
    if (this.data) {
      this.data = null;
    }
  }
};
</script>
