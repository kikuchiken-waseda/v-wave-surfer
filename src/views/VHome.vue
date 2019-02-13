<template>
  <v-container grid-list-md>
    <v-layout wrap>
      <v-flex xs12>
        <v-layout wrap row>
          <v-wave :frame_rate="frame_rate" :series="series" />
          <v-flex ml-2>
            <v-audio-list />
          </v-flex>
        </v-layout>
      </v-flex>
      <v-flex xs12>
        <v-flex xs12>
          <v-audio :audio="audio" />
        </v-flex>
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
    audio: require("../assets/data/pretest_000_left.wav"),
    frame_rate: 0.1,
    series: [
      [
        { x: 0, y: 1, z: 1 },
        { x: 1, y: 1, z: 1 },
        { x: 2, y: 1, z: 1 },
        { x: 3, y: 1, z: 1 },
        { x: 4, y: 1, z: 1 }
      ],
      [
        { x: 0, y: 2, z: 1 },
        { x: 1, y: 2, z: 1 },
        { x: 2, y: 2, z: 1 },
        { x: 3, y: 2, z: 1 },
        { x: 4, y: 2, z: 1 }
      ],
      [
        { x: 0, y: 3, z: 1 },
        { x: 1, y: 3, z: 1 },
        { x: 2, y: 3, z: 1 },
        { x: 3, y: 3, z: 1 },
        { x: 4, y: 3, z: 1 }
      ],
      [
        { x: 0, y: 4, z: 1 },
        { x: 1, y: 4, z: 1 },
        { x: 2, y: 4, z: 1 },
        { x: 3, y: 4, z: 1 },
        { x: 4, y: 4, z: 1 }
      ],
      [
        { x: 0, y: 5, z: 1 },
        { x: 1, y: 5, z: 1 },
        { x: 2, y: 5, z: 1 },
        { x: 3, y: 5, z: 1 },
        { x: 4, y: 5, z: 1 }
      ]
    ]
  })
};
</script>

<style></style>
