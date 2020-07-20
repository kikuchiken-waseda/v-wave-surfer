<template>
  <v-app>
    <w-app-bar app />
    <v-main>
      <v-container class="fill-height" fluid>
        <router-view></router-view>
      </v-container>
    </v-main>
  </v-app>
</template>

<script>
import WAppBar from "@/components/base/WAppBar.vue";
export default {
  name: "App",
  data: () => ({}),
  components: {
    WAppBar,
  },
};
</script>
