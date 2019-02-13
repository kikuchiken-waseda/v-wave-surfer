<template>
  <v-card>
    <v-card>
      <div id="spectrogram" />
      <div id="waveform" />
      <div id="timeline" />
    </v-card>
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
import WaveSurfer from "wavesurfer.js";
import TimelinePlugin from "wavesurfer.js/dist/plugin/wavesurfer.timeline.js";
import SpectrogramPlugin from "wavesurfer.js/dist/plugin/wavesurfer.spectrogram.js";

export default {
  data: () => ({
    wavesurfer: null,
    intervalId: undefined,
    play_time: 0,
    options: {
      container: "#waveform",
      waveColor: "violet",
      progressColor: "purple",
      minPxPerSec: 100,
      scrollParent: true,
      plugins: [
        TimelinePlugin.create({
          container: "#timeline"
        }),
        SpectrogramPlugin.create({
          container: "#spectrogram"
        })
      ]
    }
  }),
  props: ["audio"],
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
          return this.play_time + this.wavesurfer.getCurrentTime();
        }
      },
      set: function(seconds) {
        if (seconds >= this.duration) {
          this.wavesurfer.seekTo(1);
        } else {
          this.wavesurfer.seekTo(seconds / this.duration);
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
      this.$nextTick(() => {
        this.wavesurfer = WaveSurfer.create(this.options);
        this.wavesurfer.load(file);
        this.wavesurfer.setCurrentTime(10);
      });
    },
    play: function() {
      if (this.is_playing) {
        this.wavesurfer.pause();
        if (this.intervalId !== undefined) {
          this.play_time = 0;
          clearInterval(this.intervalId);
        }
      } else {
        this.wavesurfer.play();
        let self = this;
        this.intervalId = setInterval(function() {
          if (self.current_time < self.duration) {
            if (self.is_playing) {
              self.play_time += 0.001;
            }
          }
        }, 1);
      }
    }
  },
  mounted: function() {
    this.load(this.audio);
  },
  beforeDestroy() {
    if (clearInterval !== undefined) {
      clearInterval(this.intervalId);
    }
  }
};
</script>

<style scoped></style>
