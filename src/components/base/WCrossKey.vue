<template>
  <div :style="btnSetStyle">
    <div class="cross-layout">
      <v-btn class="position-up" fab dark :color="color" @click="upFunc">
        <v-icon dark> {{ upIcon }} </v-icon>
      </v-btn>
      <v-btn class="position-left" fab dark :color="color" @click="leftFunc">
        <v-icon dark>{{ leftIcon }}</v-icon>
      </v-btn>
      <v-icon v-if="icon" class="position-center" dark :color="iconColor">
        {{ icon }}
      </v-icon>
      <v-btn class="position-right" fab dark :color="color" @click="rightFunc">
        <v-icon dark>{{ rightIcon }}</v-icon>
      </v-btn>
      <v-btn class="position-down" fab dark :color="color" @click="downFunc">
        <v-icon dark>{{ downIcon }}</v-icon>
      </v-btn>
    </div>
  </div>
</template>

<script>
import colors from "vuetify/lib/util/colors";
export default {
  name: "WCrossKey",
  props: {
    color: {
      type: String,
      default: "grey",
    },
    backgroundColor: {
      type: String,
      default: function () {
        const cStrs = this.color.split(" ");
        if (cStrs.length == 1) {
          return `${cStrs[0]} darken-1`;
        } else {
          const cOpt = Number(cStrs[1].split("-")[1]);
          return `${cStrs[0]} darken-${cOpt + 1}`;
        }
      },
    },
    icon: {
      type: String,
    },
    upIcon: {
      type: String,
      default: "mdi-menu-up",
    },
    downIcon: {
      type: String,
      default: "mdi-menu-down",
    },
    leftIcon: {
      type: String,
      default: "mdi-menu-left",
    },
    rightIcon: {
      type: String,
      default: "mdi-menu-right",
    },
    Icon: {
      type: String,
      default: "mdi-menu-up",
    },

    iconColor: {
      type: String,
      default: function () {
        return "`${this.color.split(' ')[0]} darken-3`";
      },
    },
    upFunc: {
      type: Function,
      required: true,
    },
    leftFunc: {
      type: Function,
      required: true,
    },
    rightFunc: {
      type: Function,
      required: true,
    },
    downFunc: {
      type: Function,
      required: true,
    },
  },
  data: () => ({}),
  computed: {
    btnSetStyle: function () {
      const cStrs = this.backgroundColor.split(" ");
      let cOpt = "base";
      if (cStrs.length > 1) {
        cOpt = cStrs[1].replace("-", "");
      }
      return {
        display: "inline-block",
        padding: "10px",
        "background-color": colors[cStrs[0]][cOpt],
        "border-radius": "50%",
      };
    },
  },
};
</script>

<style scoped>
.cross-layout {
  display: grid;
  grid-template-columns: 56px 56px 56px;
  grid-template-rows: 56px 56px 56px;
}
.cross-layout .position-up {
  grid-row: 1 / 2;
  grid-column: 2 / 3;
}
.cross-layout .position-left {
  grid-row: 2 / 3;
  grid-column: 1 / 2;
}
.cross-layout .position-center {
  grid-row: 2 / 3;
  grid-column: 2 / 3;
}
.cross-layout .position-right {
  grid-row: 2 / 3;
  grid-column: 3/4;
}
.cross-layout .position-down {
  grid-row: 3 / 4;
  grid-column: 2/3;
}
</style>
