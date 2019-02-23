<template>
  <v-container grid-list-md>
    <v-layout wrap>
      <v-flex xs12>
        <v-layout wrap row>
          <v-wave :frame_rate="data.fps" :series="items" />
          <!-- 
            <v-flex ml-2>
              <v-audio-list />
            </v-flex>
          -->
        </v-layout>
      </v-flex>
      <v-flex xs12>
        <!-- 
          <v-audio :audio="audio" />
        -->
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
// import VAudio from "@/components/VAudio";
// import VAudioList from "@/components/VAudioList";
import VWave from "@/components/VWave";
import api from "@/api.js";

export default {
  components: {
    // VAudio,
    // VAudioList,
    VWave
  },
  data: () => ({
    audio: api.pretest.audio,
    data: api.pretest.data,
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
  }),
  computed: {
    items: function() {
      const sensers = this.data.sensers;
      return sensers;
    }
  }
};
</script>
