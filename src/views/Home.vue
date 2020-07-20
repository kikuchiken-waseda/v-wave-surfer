<template>
  <v-row class="home" align="center" justify="center">
    <v-col cols="6">
      <w-palate />
    </v-col>
  </v-row>
</template>

<script>
import WPalate from "@/components/WPalate.vue";
export default {
  name: "Home",
  components: {
    WPalate,
  },
};
</script>
