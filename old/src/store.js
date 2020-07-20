import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    is_loading: false,
    is_playing: false,
    current_frame: 0,
    current_time: 0
  },
  mutations: {
    play(state) {
      state.is_playing = true;
    },
    stop(state) {
      state.is_playing = false;
    },
    set_loading(state, val) {
      state.is_loading = val;
    },
    set_current_frame(state, val) {
      state.current_frame = val;
    },
    set_current_time(state, val) {
      state.current_time = val;
    }
  },
  actions: {}
});
