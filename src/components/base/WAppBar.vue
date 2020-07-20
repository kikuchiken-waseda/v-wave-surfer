<template>
  <v-app-bar app color="primary" dark>
    <v-app-bar-nav-icon @click.stop="drawer = !drawer"></v-app-bar-nav-icon>
    <v-toolbar-title class="ml-0 pl-4">
      <span class="hidden-sm-and-down">{{ $store.state.app }}</span>
    </v-toolbar-title>
    <v-spacer></v-spacer>
    <v-btn :href="$store.state.github" target="_blank" text>
      <span class="mr-2">Github</span>
      <v-icon>mdi-github</v-icon>
    </v-btn>
  </v-app-bar>
</template>

<script>
export default {
  name: "w-app-bar",
};
</script>

<style scoped></style>
