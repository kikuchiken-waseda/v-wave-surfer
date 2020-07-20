<template>
  <div ref="canvas-container" v-resize="onResize">
    <canvas ref="canvas"></canvas>
  </div>
</template>

<script>
import * as THREE from "three";
import OBJLoader from "three-obj-loader";
OBJLoader(THREE);

export default {
  name: "w-palate",
  data() {
    const scene = new THREE.Scene();
    const renderer = null;
    const camera = new THREE.PerspectiveCamera(
      50,
      window.innerWidth / window.innerHeight,
      0.1,
      2000
    );
    const light = new THREE.DirectionalLight(0xffffff);
    const geometry = new THREE.BoxGeometry(1, 1, 1);
    const material = new THREE.MeshNormalMaterial();
    const cube = new THREE.Mesh(geometry, material);
    const dodeca = null;
    return { dodeca, scene, renderer, camera, light, geometry, material, cube };
  },
  props: {
    aspect: {
      type: Number,
      default: 1,
    },
  },
  methods: {
    onResize: function () {
      this.$nextTick(() => {
        const container = this.$refs["canvas-container"];
        const canvas = this.$refs.canvas;
        canvas.width = container.clientWidth;
        canvas.height = container.clientWidth / this.aspect;
        this.renderer.setPixelRatio(window.devicePixelRatio);
        this.renderer.setSize(
          container.clientWidth,
          container.clientWidth / this.aspect
        );
        this.camera.aspect = this.aspect;
        this.camera.updateProjectionMatrix();
      });
    },
    load_obj: function (obj_path) {
      const vm = this;
      this.$nextTick(() => {
        const loader = new THREE.OBJLoader();
        loader.load(obj_path, function (res) {
          vm.dodeca = res;
          vm.scene.add(vm.dodeca);
          vm.renderer.render(vm.scene, vm.camera);
        });
      });
    },
    animetion() {
      this.$nextTick(() => {
        requestAnimationFrame(() => {
          this.animetion();
        });
        if (this.dodeca) {
          // this.dodeca.rotation.x += 0.01;
          // this.dodeca.rotation.y += 0.01;
          //this.dodeca.rotation.z += 0.01;
          this.renderer.render(this.scene, this.camera);
        }
      });
    },
  },
  mounted() {
    this.onResize();
    const canvas = this.$refs.canvas;
    this.renderer = new THREE.WebGLRenderer({
      antialias: true,
      canvas: canvas,
    });
    // 地面を作成
    if (this.scene) {
      const plane2 = new THREE.GridHelper(600);
      const plane = new THREE.AxesHelper(300);
      this.scene.add(plane);
      this.scene.add(plane2);
    }
    this.camera.position.set(0, 0, 200);
    this.light.position.set(0, 0, 10);
    this.scene.add(this.light);
    this.load_obj("/data/asai.obj");
    this.animetion();
  },
};
</script>
<style>
body {
  margin: 0;
  overflow: hidden;
}
</style>
