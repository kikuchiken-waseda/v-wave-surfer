import Vue from "vue";
import "./plugins/vuetify";
import App from "./App.vue";
import router from "./router";
import store from "./store";
import VueThreejs from "vue-threejs";

Vue.config.productionTip = false;

new Vue({
  router,
  store,
  VueThreejs,
  render: h => h(App)
}).$mount("#app");
