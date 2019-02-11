<template>
  <v-card>
    <div id="waveform" />
    <v-card-actions>
      <v-btn icon @click="play()">
        <v-icon>{{ this.play_icon }}</v-icon>
      </v-btn>
      <span> {{ current_time }} / {{ duration }} </span>
      <v-spacer></v-spacer>
      <v-btn icon><v-icon>bookmark</v-icon></v-btn>
      <v-btn icon><v-icon>share</v-icon></v-btn>
    </v-card-actions>
  </v-card>
</template>

<script>
import WaveSurfer from "wavesurfer";
export default {
  data: () => ({
    wavesurfer: null
  }),
  computed: {
    duration() {
      if (this.wavesurfer === null) {
        return 0;
      } else {
        return this.wavesurfer.getDuration();
      }
    },
    current_time: {
      get: function() {
        if (this.wavesurfer === null) {
          return 0;
        } else {
          return this.wavesurfer.getCurrentTime();
        }
      }
    },
    is_playing() {
      if (this.wavesurfer === null) {
        return false;
      } else {
        return this.wavesurfer.isPlaying();
      }
    },
    play_icon() {
      if (this.is_playing) {
        return "pause";
      }
      return "play_arrow";
    }
  },
  methods: {
    load: function(file) {
      this.wavesurfer.load(file);
    },
    play: function() {
      if (this.is_playing) {
        this.wavesurfer.pause();
      } else {
        this.wavesurfer.play();
      }
    }
  },
  mounted: function() {
    const file = require("../assets/data/pretest_000_left.wav");
    this.$nextTick(() => {
      this.wavesurfer = new WaveSurfer.create({
        container: "#waveform",
        waveColor: "violet",
        progressColor: "purple",
        plugins: []
      });
      this.load(file);
    });
  }
};
</script>

<style scoped></style>
