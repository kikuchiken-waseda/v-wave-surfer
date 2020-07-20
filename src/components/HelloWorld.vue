<template>
  <canvas ref="canvas" width="600" height="400"></canvas>
</template>

<script>
import * as THREE from "three";
import OBJLoader from "three-obj-loader";
OBJLoader(THREE);

export default {
  name: "RotateBox",
  data() {
    const scene = new THREE.Scene();
    const renderer = null;
    const camera = new THREE.PerspectiveCamera(75, 600 / 400, 0.1, 1000);
    const light = new THREE.DirectionalLight(0xffffff);
    const geometry = new THREE.BoxGeometry(1, 1, 1);
    const material = new THREE.MeshNormalMaterial();
    const cube = new THREE.Mesh(geometry, material);
    const dodeca = null;
    return { dodeca, scene, renderer, camera, light, geometry, material, cube };
  },
  methods: {
    load_obj: function (obj_path) {
      const vm = this;
      this.$nextTick(() => {
        const loader = new THREE.OBJLoader();
        loader.load(obj_path, function (res) {
          vm.dodeca = res;
          vm.scene.add(vm.dodeca);
          vm.camera.position.z = 130; // カメラを遠ざける
          vm.renderer.render(vm.scene, vm.camera);
        });
      });
    },
    animetion() {
      requestAnimationFrame(() => {
        this.animetion();
      });
      this.dodeca.rotation.x += 0.01;
      this.dodeca.rotation.y += 0.01;
      this.renderer.render(this.scene, this.camera);
    },
  },
  mounted() {
    const canvas = this.$refs.canvas;
    this.renderer = new THREE.WebGLRenderer({
      antialias: true,
      canvas: canvas,
    });
    this.camera.position.set(0, 0, 2);
    this.light.position.set(0, 0, 10);
    this.scene.add(this.light);
    this.load_obj("/data/asai.obj");
    this.animetion();
  },
};
</script>

<style></style>
