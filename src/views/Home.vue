<template>
  <v-row class="home" align="center" justify="center">
    <v-col cols="6">
      <hello-world />
    </v-col>
  </v-row>
</template>

<script>
import HelloWorld from "@/components/HelloWorld.vue";
export default {
  name: "Home",
  components: {
    HelloWorld,
  },
};
</script>
