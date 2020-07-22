<template>
  <v-dialog width="600px">
    <template v-slot:activator="{ on, attrs }">
      <v-btn icon v-bind="attrs" v-on="on">
        <v-icon>mdi-help</v-icon>
      </v-btn>
    </template>
    <v-card>
      <v-card-title v-if="title">
        <span class="headline">{{ title }}</span>
      </v-card-title>
      <v-card-text>
        <slot> </slot>
      </v-card-text>
    </v-card>
  </v-dialog>
</template>

<script>
export default {
  name: "WHelpDialog",
  props: {
    title: {
      type: String,
    },
  },
};
</script>

<style scoped></style>
