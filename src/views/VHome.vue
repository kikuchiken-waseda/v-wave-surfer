<template>
  <v-container grid-list-md>
    <v-layout wrap>
      <v-flex xs12>
        <v-layout wrap row>
          <v-flex xs6>
            <v-wave />
          </v-flex>
          <v-flex xs6>
            <v-audio-list />
          </v-flex>
        </v-layout>
      </v-flex>
      <v-flex xs12>
        <v-audio :audio="audio" />
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
import VAudio from "@/components/VAudio";
import VAudioList from "@/components/VAudioList";
import VWave from "@/components/VWave";

export default {
  components: {
    VAudio,
    VAudioList,
    VWave
  },
  data: () => ({
    audio: require("../assets/data/pretest_000_left.wav")
  })
};
</script>

<style></style>
