import Vue from "vue";
import VueRouter from "vue-router";
import P3DVisualController from "../views/P3DVisualController.vue";
import A3DVisualController from "../views/A3DVisualController.vue";

Vue.use(VueRouter);

const routes = [
  {
    path: "/",
    name: "Home",
    component: P3DVisualController,
  },
  {
    path: "/wave",
    name: "wave",
    component: A3DVisualController,
  },
  {
    path: "/about",
    name: "About",
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: () =>
      import(/* webpackChunkName: "about" */ "../views/About.vue"),
  },
];

const router = new VueRouter({
  mode: "history",
  base: process.env.BASE_URL,
  routes,
});

export default router;
