<template>
  <v-row class="home" align="center" justify="center">
    <v-col cols="6">
      <v-file-input
        accept="application/x-tgif"
        label="File input"
        @change="onFileCange"
      />
      <w-palate v-if="plateUrl" :src="plateUrl" />
    </v-col>
  </v-row>
</template>

<script>
import WPalate from "@/components/WPalate.vue";
export default {
  name: "Home",
  data: () => ({
    plateUrl: null,
  }),
  methods: {
    onFileCange: function (e) {
      if (e === undefined || e === null) this.plateUrl = null;
      if (e.name.lastIndexOf(".") <= 0) this.plateUrl = null;
      if (e.type == "application/x-tgif") {
        const fr = new FileReader();
        fr.readAsDataURL(e);
        fr.addEventListener("load", () => {
          this.plateUrl = fr.result;
        });
      }
    },
  },
  components: {
    WPalate,
  },
};
</script>
